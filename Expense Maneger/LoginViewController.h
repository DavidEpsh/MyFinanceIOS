//
//  LoginViewController.h
//  Expense Maneger
//
//  Created by Admin on 1/9/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userTV;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTV;

- (IBAction)login:(id)sender;
- (IBAction)signup:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *signupBtn;

-(BOOL) validEmail:(NSString*) emailString;
-(void)makeToast:(NSString*)toastMsg;

@end
