//
//  ExpenseTableViewController.m
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import "ExpenseTableViewController.h"
#import "ExpenseTableViewCell.h"
#import "Model.h"
#import <Parse/Parse.h>

@interface ExpenseTableViewController ()

@end

@implementation ExpenseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.activityIndicator startAnimating];
    
    
    self.navigationItem.title = [Model instance].user;
    
    expenses = [[NSArray alloc] init];
    
    
//    [[Model instance] getExpensesAsynch:^(NSArray *stArray) {
//        expenses = stArray;
//        [self.tableView reloadData];
//        [self.activityIndicator stopAnimating];
//        self.activityIndicator.hidden = YES;
//    }];

    
}

 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return expenses.count;
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ExpenseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"expenseCell" forIndexPath:indexPath];
    
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
        cell.imageView.image = [UIImage imageNamed:@"troll.jpg"];
    }
 
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toNewExpense"]) {
        NewExpenseViewController* nextVC = segue.destinationViewController;
        nextVC.delegate = self;
    }
    /*
    else if ([segue.identifier isEqualToString:@"toDetail"]){
        DetailViewController* DetailVC = segue.destinationViewController;
        DetailVC.student = [self.data objectAtIndex:[(UIButton*)sender tag]];
    }
     */
}

-(void)onSave:(id)newExpense {
 //   [self.expenses addObj
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
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
