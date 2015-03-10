//
//  DVSAccountStore.m
//  Devise
//
//  Created by Pawel Bialecki on 09.03.2015.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

#import "DVSAccountStore.h"

@interface DVSAccountStore ()

@property (copy, nonatomic) NSString *accountTypeIdentifier;
@property (copy, nonatomic) NSString *appIDKey;
@property (strong, nonatomic) NSArray *permissions;

@end

@implementation DVSAccountStore

- (instancetype)initWithACAccountTypeIdentifier:(NSString *)accountTypeIdentifier appIDkey:(NSString *)appIDkey permissions:(NSArray *)permissions {
    if (self = [super init]) {
        self.accountTypeIdentifier = accountTypeIdentifier;
        self.appIDKey = appIDkey;
        self.permissions = permissions;
    }
    
    return self;
}

- (void)requestAccessWithCompletion:(ACAccountStoreRequestAccessCompletionHandler)completion {

    NSAssert(self.accountTypeIdentifier != nil, @"accountTypeIdentifier can not be nil!");
    NSAssert(self.appIDKey != nil, @"appIDKey can not be nil!");
    NSAssert(self.permissions != nil, @"permissions can not be nil!");
    
    NSDictionary *options = @{
        ACFacebookAppIdKey : self.appIDKey,
        ACFacebookPermissionsKey : self.permissions,
        ACFacebookAudienceKey : ACFacebookAudienceOnlyMe
    };
    
    [self requestAccessToAccountsWithType:[self accountTypeWithAccountTypeIdentifier:self.accountTypeIdentifier] options:options completion:completion];
}

@end
