//
//  NewExpenseViewController.h
//  Expense Maneger
//
//  Created by Admin on 12/24/15.
//  Copyright © 2015 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"
#import <sqlite3.h>

@protocol NewExpenseDelegate <NSObject>
-(void)onSave:(Expense*)newExpense;
@end

@protocol CheckBoxDelegate <NSObject>
-(void)onSavebox;
@end

@interface NewExpenseViewController : UIViewController
{
    UIDatePicker *datePicker;
    BOOL nonchecked;
}

@property id<NewExpenseDelegate, CheckBoxDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *expenseName;
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *date;

- (IBAction)cancelAct:(id)sender;

- (IBAction)saveAct:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)toTakePhotoViewContr:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
- (IBAction)checkBox:(id)sender;


@end
