//
//  NewExpenseViewController.h
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"

@protocol NewExpenseDelegate <NSObject>

-(void)onSave:(Expense*)newExpense;

@end


@interface NewExpenseViewController : UIViewController
{
    UIDatePicker *datePicker;
//    NSMutableArray* expenses;
}

@property id<NewExpenseDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *expenseName;
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *date;

- (IBAction)takePicture:(id)sender;

- (IBAction)cancelAct:(id)sender;

- (IBAction)saveAct:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *takePicturBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end
