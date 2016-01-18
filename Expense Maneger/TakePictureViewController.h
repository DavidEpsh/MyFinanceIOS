//
//  TakePictureViewController.h
//  Expense Maneger
//
//  Created by Admin on 1/11/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TakePictureViewController;

@interface TakePictureViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    UIImagePickerController *picker;
    UIImage *image;
    NSString *imagePath;
    
}

- (IBAction)takePhoto:(id)sender;

- (IBAction)choosePhoto:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (copy) void(^callback)(UIImage *value1, NSString *value2);
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)onSave:(NSString*)imagePath;

@end
