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
#import "ModelSql.h"
#import <Parse/Parse.h>

@interface ExpenseTableViewController ()

@end

@implementation ExpenseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    expenses = [[NSArray alloc] init];
    NSMutableArray* currentExpenses = [[NSMutableArray alloc] init];
    [self.activityIndicator startAnimating];
    
    [[Model instance]getAllRelevantExpensesAsync:^{
        expenses = [[Model instance]getExpensesForSheet:[NSString stringWithFormat:@"%@",[Model instance].user] useSheetName:NO];
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        
        for (int i=0; i < expenses.count % 7; i++) {
            [currentExpenses addObject:[expenses objectAtIndex:i]];
        }
        
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRefresh) name:@"updateParent" object:nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    //self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
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
        cell.imageView.image = [UIImage imageNamed:@"images.jpeg"];
    }

    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // when reaching bottom, load more
    
    float offs = (scrollView.contentOffset.y+scrollView.bounds.size.height);
    float val = (scrollView.contentSize.height);
    if (offs==val)
    {
        //add more data on your data array
    }
}

-(void)onSave:(id)newExpense {
    expenses = [[Model instance]getExpensesForSheet:[NSString stringWithFormat:@"%@",@"My Account"] useSheetName:NO];
    [self.tableView reloadData];
//   [self.navigationController popViewControllerAnimated:YES];
}

-(void)onRefresh{
    [[Model instance]getAllRelevantExpensesAsync:^{
        expenses = [[Model instance]getExpensesForSheet:[NSString stringWithFormat:@"%@",[Model instance].user] useSheetName:NO];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        //[self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"editExpenseNew"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NewExpenseViewController *destViewController = segue.destinationViewController;
        destViewController.currExpense = [expenses objectAtIndex:indexPath.row];
        destViewController.editMode = [NSNumber numberWithInt:1];
//        destViewController.expenseAmountText = [[expenses objectAtIndex:indexPath.row] examount];
//        destViewController.expenseCategoryText = [[expenses objectAtIndex:indexPath.row] excategory];
//        destViewController.expenseDateText = [[expenses objectAtIndex:indexPath.row] exdate];
//        destViewController.expenseImagePath = [[expenses objectAtIndex:indexPath.row] eximage];
//        destViewController.expenseRepeatingText = [[expenses objectAtIndex:indexPath.row] isRepeating];
//        destViewController.sheetId = [Model instance].user;
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
