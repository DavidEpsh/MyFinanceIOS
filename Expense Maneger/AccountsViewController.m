//
//  AccountsViewController.m
//  Expense Maneger
//
//  Created by Admin on 1/14/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "AccountsViewController.h"
#import "AccountsTableViewCell.h"
#import "NewExpenseViewController.h"
#import "ModelSql.h"
#import "Model.h"
#import <Parse/Parse.h>


@interface AccountsViewController ()

@end

@implementation AccountsViewController

@synthesize pickerData;
@synthesize myTableView;

- (void)viewDidLoad {
    [super viewDidLoad];

    myTableView.dataSource=self;
    myTableView.delegate=self;
    
    _pickerData = [[NSArray alloc]initWithArray:[[Model instance] getAllSheetNames]];
    expenses = [[NSArray alloc] init];
    
    if ([_pickerData count] > 0) {
        _currentSheet = [_pickerData objectAtIndex:0];
        expenses = [[Model instance]getExpensesForSheet:_currentSheet useSheetName:YES];
    }
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:refreshControl];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefreshWithoutRefreshControl) name:@"updateParent" object:nil];
}

//The void statment to configue the REST of a pickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;//The Lable
}
//How many Rows of Data the picker display = How many Rows in NSArray
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_pickerData count];
}

//To Display the Title of the Row
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_pickerData objectAtIndex:row];
}

 -(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     _currentSheet = [_pickerData objectAtIndex:row];
     expenses = [[Model instance]getExpensesForSheet:_currentSheet useSheetName:YES];
     [self.myTableView reloadData];
     //[self.myTableView popViewControllerAnimated:YES];
     
 }- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return expenses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AccountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsCell" forIndexPath:indexPath];

    Expense* exp = [expenses objectAtIndex:indexPath.row];
    cell.exName.text = exp.exname;
    cell.category.text = exp.excategory;
    
    cell.imageName = exp.eximage;
    cell.imageView.image = nil;
    [cell.activityIndicator startAnimating];
    if (exp.eximage != nil && ![exp.eximage isEqualToString:@""]) {
        [[Model instance] getExpenseImage:exp block:^(UIImage *image) {
            if ([cell.imageName isEqualToString:exp.eximage]){
                cell.activityIndicator.hidden = YES;
                if (image != nil) {
                    cell.imageView.image = image;
                    [cell.activityIndicator stopAnimating];
                }else{
                    cell.imageView.image = [UIImage imageNamed:@"messi.jpg"];
                }
            }
        }];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"images.jpeg"];
    }
    
    return cell;
}

- (void)alertTextFieldDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = login.text.length > 2;
    }
}

- (IBAction)addNewAccount:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New user" message:@"Enter username" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        
        if ([AccountsViewController validEmail:textField.text]) {
            NSString* currentSheetId = [[Model instance] getSheetId:_currentSheet];
            [[Model instance]addUserSheet:textField.text sheetId:currentSheetId withParse:YES];
            
        }else{
            UIAlertController *controller = [UIAlertController alertControllerWithTitle: @"Invalid input" message: @"Please enter a valid email address" preferredStyle: UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle: @"Dismiss" style: UIAlertActionStyleDestructive handler: ^(UIAlertAction *action) {
            }];
            [controller addAction: alertAction];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}


+(BOOL) validEmail:(NSString*) emailString {
    
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

- (IBAction)addSheet:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add New Shared Account" message:@"Enter Account Name" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:nil];
    
    [alert addAction: [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *textField = alert.textFields[0];
        NSString* timeInMillisecond = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        NSString* formattedTime = [timeInMillisecond substringToIndex:9];
        _currentSheet = textField.text;
        [[Model instance]addSheet:_currentSheet sheetId:formattedTime withParse:YES];
        [[Model instance]addUserSheet:[[Model instance] user] sheetId:formattedTime withParse:YES];
        _pickerData = [[NSArray alloc]initWithArray:[[Model instance] getAllSheetNames]];
        
        [self.myTableView reloadData];
        [self.pickerData reloadAllComponents];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editExpenseFromSheet"]) {
        NSIndexPath *indexPath = [self.myTableView indexPathForSelectedRow];
        NewExpenseViewController *destViewController = segue.destinationViewController;
        destViewController.currExpense = [expenses objectAtIndex:indexPath.row];
        destViewController.editMode = [NSNumber numberWithInt:1];
        
    }else if ([segue.identifier isEqualToString:@"toNewExpenseFromSheet"]) {
        NewExpenseViewController *destViewController = segue.destinationViewController;
        NSString* sheet = [[Model instance]getSheetId:_currentSheet];
        destViewController.sheetId = sheet;
    }
}

-(void)onRefresh:(UIRefreshControl *)refreshControl{
    [[Model instance]getAllRelevantExpensesAsync:^{
        expenses = [[Model instance]getExpensesForSheet:_currentSheet useSheetName:YES];
        [self.myTableView reloadData];
        [refreshControl endRefreshing];
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)onRefreshWithoutRefreshControl{
    [[Model instance]getAllRelevantExpensesAsync:^{
        expenses = [[Model instance]getExpensesForSheet:_currentSheet useSheetName:YES];
        [self.myTableView reloadData];
    }];
}

@end
