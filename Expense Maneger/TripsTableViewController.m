//
//  TripsTableViewController.m
//  Expense Maneger
//
//  Created by Admin on 1/12/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "TripsTableViewController.h"
#import "TripsTableViewCell.h"
#import "Model.h"
#import <Parse/Parse.h>

@interface TripsTableViewController ()

@end

@implementation TripsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Trip";

    if(sheetId == nil ){
        sheetId = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
    return expenses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripsCell" forIndexPath:indexPath];
    
    Expense* exp = [expenses objectAtIndex:indexPath.row];
    cell.trName.text = exp.exname;
    cell.category.text = exp.excategory;
    
    cell.imageName = exp.eximage;
    cell.imageViewTrip.image = nil;
    [cell.activityIndicator startAnimating];
    if (exp.eximage != nil && ![exp.eximage isEqualToString:@""]) {
        [[Model instance] getExpenseImage:exp block:^(UIImage *image) {
            if ([cell.imageName isEqualToString:exp.eximage]){
                cell.activityIndicator.hidden = YES;
                if (image != nil) {
                    cell.imageViewTrip.image = image;
                    [cell.activityIndicator stopAnimating];
                }
                else{
                    cell.imageViewTrip.image = [UIImage imageNamed:@"BeautifulCat.JPG"];
                }
            }
        }];
        
    }else{
        cell.imageViewTrip.image = [UIImage imageNamed:@"images.jpeg"];
    }

    return cell;
}


-(void)onSave:(id)newExpense {
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
