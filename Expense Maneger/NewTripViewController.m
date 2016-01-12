//
//  NewTripViewController.m
//  Expense Maneger
//
//  Created by Admin on 1/12/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "NewTripViewController.h"
#import "Model.h"
#import "ModelSql.h"
#import "ModelParse.h"

@interface NewTripViewController ()

@end

@implementation NewTripViewController
@synthesize checkBoxBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Trip";
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    nonchecked = [defaults boolForKey:@"boxIsChecked"];
    [self checkBoxBtn];
    
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.date setInputView:datePicker];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.date setInputAccessoryView:toolBar];

}

-(void)ShowSelectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    self.date.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.date resignFirstResponder];
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

- (IBAction)cancelAct:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)saveAct:(id)sender {
    NSString* exname = [NSString stringWithFormat:@"%@", self.expenseName.text];
    NSString* category = [NSString stringWithFormat:@"%@", self.category.text];
    NSNumber* examount = [NSNumber numberWithInt:[self.amount.text intValue]];
    NSString* st_exdate = [NSString stringWithFormat:@"%@", self.date.text];
    NSString* currentUser = [[Model instance]getCurrentUser];
    NSString* timeInMillisecond = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    Expense* exp = [[Expense alloc] init:timeInMillisecond exname:exname excategory:category examount:examount exdate:st_exdate eximage:@"" userName:currentUser sheetId:@"My Trip" isRepeating:@(0) isSaved:@(1)];
    
    [self.delegate onSave:exp];
    [[Model instance]addExp:exp withParse:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@synthesize expenseName;
@synthesize category;
@synthesize amount;
@synthesize date;


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField{
    [theTextField resignFirstResponder];
    return YES;
}

- (IBAction)toTakePhotoViewContr:(id)sender {
}
- (IBAction)checkBox:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!nonchecked) {
        [checkBoxBtn setImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
        nonchecked = YES;
        [defaults setBool:nonchecked forKey:@"boxIsChecked"];
    }
    else if (nonchecked){
        [checkBoxBtn setImage:[UIImage imageNamed:@"checkbox_no.png"] forState:UIControlStateNormal];
        nonchecked = NO;
        [defaults setBool:nonchecked forKey:@"boxIsChecked"];
    }
    [defaults synchronize];
}

@end
