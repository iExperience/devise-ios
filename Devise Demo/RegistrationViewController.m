//
//  RegistrationViewController.m
//  Devise
//
//  Created by Patryk Kaczmarek on 19.11.2014.
//  Copyright (c) 2014 Netguru.co. All rights reserved.
//

#import "RegistrationViewController.h"
#import <Devise/Devise.h>
#import "DVSMacros.h"

static NSString * const DVSEnterSegue = @"enter";

@interface RegistrationViewController ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation RegistrationViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardSizeChanged:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardSizeChanged:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver: self];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView setContentSize: self.contentView.bounds.size];
}

- (void)keyboardSizeChanged:(NSNotification*)notification {
    CGRect keyboardEndFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect keyboardBeginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    if (keyboardBeginFrame.origin.y>keyboardEndFrame.origin.y) {
        self.scrollViewBottomConstraint.constant = keyboardBeginFrame.size.height;
    } else {
        self.scrollViewBottomConstraint.constant = 0;
    }
}

- (IBAction)signUpTouched:(UIBarButtonItem *)sender {
    DVSUser *newUser = [DVSUser user];
    newUser.password = self.passwordTextField.text;
    newUser.email = self.emailTextField.text;
    [newUser registerWithSuccess:^{
        DVSWorkInProgress("Proceed further");
        [self performSegueWithIdentifier:DVSEnterSegue sender:self];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil] show];
    }];
}

@end