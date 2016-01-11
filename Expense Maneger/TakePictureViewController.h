//
//  TakePictureViewController.h
//  Expense Maneger
//
//  Created by Admin on 1/11/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePictureViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    UIImagePickerController *picker;
    UIImage *image;
    
}

- (IBAction)takePhoto:(id)sender;

- (IBAction)choosePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;

@end
