//
//  TripsTableViewController.h
//  Expense Maneger
//
//  Created by Admin on 1/12/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewTripViewController.h"
#import "PNChart.h"


@interface TripsTableViewController : UITableViewController<NewTripDelegate>{
    NSArray* expenses;
    NSString* sheetId;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *toNewTripBtn;

@end
