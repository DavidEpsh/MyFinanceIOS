//
//  TripsTableViewCell.h
//  Expense Maneger
//
//  Created by Admin on 1/12/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageViewTrip;

@property NSString* imageName;

@property (weak, nonatomic) IBOutlet UILabel *trName;

@property (weak, nonatomic) IBOutlet UILabel *category;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
