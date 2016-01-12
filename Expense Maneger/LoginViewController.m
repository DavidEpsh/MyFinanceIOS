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
    [[Model instance] login:self.userTV.text pwd:self.PasswordTV.text block:^(BOOL res) {
        if (res) {
            [[Model instance] getExpensesAsynch:^(NSArray *stArray) {
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = YES;
            [self performSegueWithIdentifier:@"toApp" sender:self];
                
            }];
        }
    }];
    
    
}

- (IBAction)signup:(id)sender {
    [self.activityIndicator startAnimating];
    self.activityIndicator.hidden = NO;
    [[Model instance] signup:self.userTV.text pwd:self.PasswordTV.text block:^(BOOL res) {
        self.activityIndicator.hidden = YES;
        if (res) {
            [self performSegueWithIdentifier:@"toApp" sender:self];
        }
    }];
}
@end
