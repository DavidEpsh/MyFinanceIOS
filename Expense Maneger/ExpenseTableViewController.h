//
//  ExpenseTableViewController.h
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewExpenseViewController.h"

@interface ExpenseTableViewController : UITableViewController<NewExpenseDelegate>{
   NSArray* expenses;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
