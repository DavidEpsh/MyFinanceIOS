//
//  AccountsTableViewCell.h
//  Expense Maneger
//
//  Created by Admin on 1/14/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSString* imageName;

@property (weak, nonatomic) IBOutlet UILabel *exName;

@property (weak, nonatomic) IBOutlet UILabel *category;

@property (weak, nonatomic) IBOutlet UILabel *date;


@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
