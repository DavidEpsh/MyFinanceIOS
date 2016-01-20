//
//  NewExpenseViewController.m
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "NewExpenseViewController.h"
#import "Model.h"
#import "ModelSql.h"
#import "ModelParse.h"
#import "TakePictureViewController.h"

@interface NewExpenseViewController ()

@end

@implementation NewExpenseViewController
@synthesize checkBoxBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"New Expense";
    
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
    
    
    if(_currExpense != nil){
        expenseName.text = [_currExpense exname];
        category.text = [_currExpense excategory];
        date.text = [_currExpense exdate];
        amount.text = [NSString stringWithFormat:@"%@", [_currExpense examount]];
        _sheetId = [_currExpense sheetId];
        
        if ([[_currExpense isRepeating] isEqualToNumber:[NSNumber numberWithInt:1]]) {
            [checkBoxBtn setImage:[UIImage imageNamed:@"checkbox_yes.png"] forState:UIControlStateNormal];
            nonchecked = YES;
            [defaults setBool:nonchecked forKey:@"boxIsChecked"];
        }
    }
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


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toTakePicture"]) {
        toTakePictureViewConntroller nextVC = segue.destinationViewController;
        nextVC.delegate = self;
}  	
*/

- (IBAction)cancelAct:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAct:(id)sender {
    
    NSString* exname = [NSString stringWithFormat:@"%@", self.expenseName.text];
    NSString* currCategory = [NSString stringWithFormat:@"%@", self.category.text];
    NSNumber* examount = [NSNumber numberWithInt:[self.amount.text intValue]];
    NSString* st_exdate = [NSString stringWithFormat:@"%@", self.date.text];
    NSString* currentUser = [[Model instance]getCurrentUser];
    
    NSNumber* isRepeating;
    if(nonchecked == YES){
        isRepeating = [NSNumber numberWithInt:1];
    }else{
        isRepeating = [NSNumber numberWithInt:0];
    }
    
    if (_sheetId == nil) {
        _sheetId = [[Model instance]getCurrentUser];
    }
    Expense* exp = [Expense alloc];
    
    if (imageName == nil || image == nil) {
        imageName = @"";
    }
    
    if ([_editMode isEqualToNumber:[NSNumber numberWithInt:1]]) {
        exp = [[Expense alloc] init:_currExpense.timeInMillisecond exname:exname excategory:currCategory examount:examount exdate:st_exdate eximage:imageName userName:currentUser sheetId:_sheetId isRepeating:isRepeating isSaved:@(1)];
        [[Model instance]updateExpense:exp];
    }else{
        NSString* timeInMillisecond = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        NSString* formattedTime = [timeInMillisecond substringToIndex:9];
        exp = [[Expense alloc] init:formattedTime exname:exname excategory:currCategory examount:examount exdate:st_exdate eximage:imageName userName:currentUser sheetId:_sheetId isRepeating:isRepeating isSaved:@(1)];
        [[Model instance]addExp:exp withParse:YES];
    }
    
    [[Model instance]saveExpenseImage:exp image:image block:^(NSError *error) {
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateParent" object:nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[TakePictureViewController class]])
    {
        TakePictureViewController *viewController = segue.destinationViewController;
        
        if (_currExpense.eximage != nil && ![_currExpense.eximage isEqualToString:@""]) {
            viewController.imageName = _currExpense.eximage;
        }
        
        viewController.callback = ^(UIImage *value1, NSString *value2) {
            image = value1;
            imageName = value2;
        };
    }
}
- (IBAction)onDelete:(id)sender {
    if (_currExpense != nil) {
        [[Model instance]deleteExpense:_currExpense];
    }
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateParent" object:nil];
}

@end

