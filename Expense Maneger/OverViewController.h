//
//  OverViewController.h
//  Expense Maneger
//
//  Created by David on 1/19/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"

@interface OverViewController : UIViewController{
    NSArray *sheetNamesForPicker;
    PNPieChart *pieChart;
    NSMutableArray *items;
    NSArray *colors;
}

@property (weak, nonatomic) IBOutlet UIPickerView *pickerData;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) NSString *currentSheet;

@end
