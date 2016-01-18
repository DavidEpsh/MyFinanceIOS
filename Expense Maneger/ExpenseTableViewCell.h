//
//  ExpenseTableViewCell.h
//  Expense Maneger
//
//  Created by Admin on 1/7/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *exName;
@property (weak, nonatomic) IBOutlet UILabel *category;
@property (weak, nonatomic) IBOutlet UILabel *date;

@property NSString* imageName;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
