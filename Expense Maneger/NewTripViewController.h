//
//  NewTripViewController.h
//  Expense Maneger
//
//  Created by Admin on 1/12/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Expense.h"

@protocol NewTripDelegate <NSObject>
-(void)onSave:(Expense*)newExpense;
@end

@protocol CheckBoxDelegate <NSObject>
-(void)onSavebox;
@end

@interface NewTripViewController : UIViewController
{
    UIDatePicker *datePicker;
    BOOL nonchecked;
}

@property id<NewTripDelegate, CheckBoxDelegate> delegate;

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
