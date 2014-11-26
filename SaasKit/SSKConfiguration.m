//
//  SSKConfiguration.m
//
//  Copyright (c) 2014 Netguru Sp. z o.o. All rights reserved.
//

#import "SSKConfiguration.h"
#import "SSKMacros.h"

@interface SSKConfiguration ()

@property (strong, nonatomic) NSMutableDictionary *mutableRoutePaths;

@end

#pragma mark -

@implementation SSKConfiguration

#pragma mark Initialization

- (instancetype)initWithServerURL:(NSURL *)serverURL {
    self = [super init];
    if (self == nil) return nil;
    self.serverURL = serverURL;
    self.logLevel = SSKLogLevelNone;
    [self setPath:@"login" forRoute:SSKRouteLogin];
    [self setPath:@"register" forRoute:SSKRouteRegister];
    [self setPath:@"forgotPassword" forRoute:SSKRouteForgotPassword];
    return self;
}

+ (instancetype)sharedConfiguration {
    static dispatch_once_t onceToken;
    static SSKConfiguration *sharedConfiguration = nil;
    dispatch_once(&onceToken, ^{
        sharedConfiguration = [[self alloc] initWithServerURL:nil];
    });
    return sharedConfiguration;
}

#pragma mark Routes

- (NSMutableDictionary *)mutableRoutePaths {
    if (_mutableRoutePaths != nil) return _mutableRoutePaths;
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    _mutableRoutePaths = dictionary;
    return _mutableRoutePaths;
}

- (NSDictionary *)routePaths {
    return [self.mutableRoutePaths copy];
}

- (NSString *)pathForRoute:(SSKRoute)route {
    return self.mutableRoutePaths[@(route)];
}

- (void)setPath:(NSString *)path forRoute:(SSKRoute)route {
    self.mutableRoutePaths[@(route)] = path;
}

#pragma mark Logging

- (void)logMessage:(NSString *)message {
    switch (self.logLevel) {
        case SSKLogLevelNone: default:
            break;
        case SSKLogLevelWarning:
            NSLog(@"[SAASKIT] %@", message);
            break;
        case SSKLogLevelAssert:
            NSAssert1(NO, @"[SAASKIT] %@", message);
            break;
    }
}

@end