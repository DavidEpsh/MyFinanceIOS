//
//  AccountsViewController.m
//  Expense Maneger
//
//  Created by Admin on 1/14/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "AccountsViewController.h"
#import "AccountsTableViewCell.h"
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
/*
    self.navigationItem.title = @"Share Accouts";
    
    expenses = [[NSArray alloc] init];
    
    expenses = [[Model instance]getExpensesForSheet:[NSString stringWithFormat:@"%@",@"Share Accouts"]];

    if(sheetId == nil ){
        sheetId = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    }

*/
    
    //Title for Rows of Picker
    _pickerData = [[NSArray alloc]initWithObjects:@"Row1", @"Row 2", @"Row3", @"Row 4", nil];
    
    // Do any additional setup after loading the view.
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
     int select = (int)row;
     if (select == 0) {
     self.label.text = @"Row 1 was selected";
     }
     if (select == 1) {
         self.label.text = @"Row 2 was selected";
         
     }
     if (select == 2) {
         self.label.text = @"Row 3 was selected";
         
     }
     if (select == 3) {
         self.label.text = @"Row 4 was selected";
         
     }
     
 }- (void)didReceiveMemoryWarning {
     [super didReceiveMemoryWarning];
     // Dispose of any resources that can be recreated.
 }

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    return 5;
    //expenses.count;
}

/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 NSLog(@"cellForRowAtIndexPath");
 
    AccountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsCell"];
     
 //AccountsTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"AccountsCell"];
 
 NSLog(@"cellForRowAtIndexPath");
 
 cell.textLabel.text = @"Test";
 
 return cell;
 }
*/



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

        AccountsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountsCell" forIndexPath:indexPath];

    Expense* exp = [expenses objectAtIndex:indexPath.row];
    cell.exName.text = exp.exname;
    cell.category.text = exp.excategory;
    cell.date.text = exp.exdate;
    
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
                    cell.imageView.image = [UIImage imageNamed:@"BeautifulCat.jpg"];
                }
            }
        }];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"troll.jpg"];
    }
    
    return cell;
}


/*
-(void)onSave:(id)newExpense {
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
*/
/*
- (IBAction)newUser:(id)sender {
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Hello!" message:@"Please enter your name:" delegate:self cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [alert textFieldAtIndex:0];
    alertTextField.keyboardType = UIKeyboardTypeNumberPad;
    alertTextField.placeholder = @"Enter your name";
    [alert show];
    
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString* input = [[alertView textFieldAtIndex:0] text];
    if(sheetId != nil){
        sheetId = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
        [[Model instance] addSheet:@"Trip" sheetId:sheetId];
        [[Model instance] addUserSheetToSQL:input sheetId:sheetId];
    }
}

*/


//#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
