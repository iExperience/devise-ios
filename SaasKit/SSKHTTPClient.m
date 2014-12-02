//
//  SSKHTTPClient.m
//  
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "SSKHTTPClient.h"
#import "SSKConfiguration.h"

typedef void (^SSKHTTPClientRetriableBlock)(SSKHTTPClientCompletionBlock block);

@interface SSKHTTPClient ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

- (NSString *)absoluteURLStringForPath:(NSString *)path;
- (void)executeRetriableBlock:(SSKHTTPClientRetriableBlock)retriable completion:(SSKHTTPClientCompletionBlock)completion;

@end

#pragma mark -

@implementation SSKHTTPClient

#pragma mark Object lifecycle

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    static SSKHTTPClient *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithConfiguration:[SSKConfiguration sharedConfiguration]];
    });
    return sharedInstance;
}

- (instancetype)initWithConfiguration:(SSKConfiguration *)configuration {
    self = [super init];
    if (self == nil) return nil;

    self.configuration = configuration;

    self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
    self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

- (instancetype)init {
    return [self initWithConfiguration:nil];
}

- (void)dealloc {
    [self cancelAllRequests];
}

#pragma mark Request management

- (void)GET:(NSString *)path parameters:(NSDictionary *)parameters completion:(SSKHTTPClientCompletionBlock)completion {
    [self executeRetriableBlock:^(SSKHTTPClientCompletionBlock retry) {
        NSAssert(self.configuration.serverURL != nil, @"Server base URL cannot be nil.");
        NSString *actualPath = [self absoluteURLStringForPath:path];
        [self.sessionManager GET:actualPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (retry != NULL) retry(responseObject, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (retry != NULL) retry(nil, error);
        }];
    } completion:completion];
}

- (void)POST:(NSString *)path parameters:(NSDictionary *)parameters completion:(SSKHTTPClientCompletionBlock)completion {
    [self executeRetriableBlock:^(SSKHTTPClientCompletionBlock retry) {
        NSAssert(self.configuration.serverURL != nil, @"Server base URL cannot be nil.");
        NSString *actualPath = [self absoluteURLStringForPath:path];
        [self.sessionManager POST:actualPath parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            if (retry != NULL) retry(responseObject, nil);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (retry != NULL) retry(nil, error);
        }];
    } completion:completion];
}

- (void)cancelAllRequests {
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        [task cancel];
    }
}

#pragma mark Helpers

- (NSString *)absoluteURLStringForPath:(NSString *)path {
    return [[self.configuration.serverURL URLByAppendingPathComponent:path] absoluteString];
}

- (void)executeRetriableBlock:(SSKHTTPClientRetriableBlock)retriable completion:(SSKHTTPClientCompletionBlock)completion {
    static NSUInteger retriesCounter = 0;
    retriable(^(id responseObject, NSError *error) {
        if (error == nil || retriesCounter == self.configuration.numberOfRetries) {
            if (completion != NULL) completion(responseObject, error);
            retriesCounter = 0;
        } else {
            retriesCounter++;
            NSTimeInterval waitDuration = self.configuration.retryTresholdDuration;
            dispatch_time_t gcdDuration = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(waitDuration * NSEC_PER_SEC));
            __weak typeof(self) weakSelf = self;
            dispatch_after(gcdDuration, dispatch_get_main_queue(), ^{
                [weakSelf executeRetriableBlock:retriable completion:completion];
            });
        }
    });
}

@end
