//
//  LoginViewController.m
//  Expense Maneger
//
//  Created by Admin on 1/9/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "LoginViewController.h"
#import "Model.h"
#import "ModelParse.h"
#import "ModelSql.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = YES;

    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([Model instance].user != nil) {
        [self performSegueWithIdentifier:@"toApp" sender:self];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login:(id)sender {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
    if([self validEmail:self.userTV.text] && self.PasswordTV.text.length >= 4){

    [[Model instance] login:self.userTV.text pwd:self.PasswordTV.text block:^(BOOL res) {
        if (res) {
            //[[Model instance] getAllRelevantExpensesAsync :^(NSError* res){
//                [self.activityIndicator stopAnimating];
//                self.activityIndicator.hidden = YES;
                [self performSegueWithIdentifier:@"toApp" sender:self];
        }
    }];
    }else if([self validEmail:self.userTV.text] == NO){
        self.activityIndicator.hidden = YES;
        [self makeToast:@"Incorrect Email"];
    }else{
        self.activityIndicator.hidden = YES;
        [self makeToast:@"Password must be more than 4 charaters"];
    }
    
    
}

- (IBAction)signup:(id)sender {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    
    if([self validEmail:self.userTV.text] && self.PasswordTV.text.length >= 4){
        
    [[Model instance] signup:self.userTV.text pwd:self.PasswordTV.text block:^(BOOL res) {
        self.activityIndicator.hidden = YES;
        if (res) {
            [self performSegueWithIdentifier:@"toApp" sender:self];
        }
    }];
    }else if([self validEmail:self.userTV.text] == NO){
        self.activityIndicator.hidden = YES;
        [self makeToast:@"Incorrect Email"];
    }else{
        self.activityIndicator.hidden = YES;
        [self makeToast:@"Password must be more than 4 charaters"];
    }
}

-(BOOL) validEmail:(NSString*) emailString {
    
    if([emailString length]==0){
        return NO;
    }
    
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];

    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

-(void)makeToast:(NSString*)toastMsg {
    UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Invalid input" message: toastMsg preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Dismiss" style: UIAlertActionStyleDestructive handler: ^(UIAlertAction *action) {
    }];
    [controller addAction: alertAction];
    [self presentViewController:controller animated:YES completion:nil];
}



@end
