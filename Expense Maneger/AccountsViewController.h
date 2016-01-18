//
//  AccountsViewController.h
//  Expense Maneger
//
//  Created by Admin on 1/14/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NewTripViewController.h"
#import "PNChart.h"

@interface AccountsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    NSArray* expenses;
    NSMutableArray* currentExpenses;
    NSString* sheetId;
    NSArray* _pickerData;
    NSString* _currentSheet;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerData;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *addNewUser;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIButton *addNewSheet;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *righButton;
@property (weak, nonatomic) NSString *sheetIdString;





+(BOOL) validEmail:(NSString*) emailString;


@end
