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

@class NewExpenseViewController;

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
    UIImage *image;
    NSString *imageName;
}

@property id<NewExpenseDelegate, CheckBoxDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *expenseName;
@property (weak, nonatomic) IBOutlet UITextField *category;
@property (weak, nonatomic) IBOutlet UITextField *amount;
@property (weak, nonatomic) IBOutlet UITextField *date;
@property (weak, nonatomic) IBOutlet UIButton *buttonDelete;
@property (weak, nonatomic) NSNumber *editMode;
@property (weak, nonatomic) NSNumber *expenseRepeatingText;
@property (weak, nonatomic) NSString *sheetId;
//@property (weak, nonatomic) UIImage *image;
//@property (weak, nonatomic) NSString *imagePath;
@property (weak, nonatomic) Expense *currExpense;


- (IBAction)cancelAct:(id)sender;

- (IBAction)saveAct:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

- (IBAction)toTakePhotoViewContr:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkBoxBtn;
- (IBAction)checkBox:(id)sender;



@end
