//
//  TakePicture2ViewController.h
//  Expense Maneger
//
//  Created by Admin on 1/12/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TakePicture2ViewController : UIViewController <UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    UIImagePickerController *picker;
    UIImage *image;
    
}


@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;

- (IBAction)takePhoto:(id)sender;

- (IBAction)choosePhoto:(id)sender;
@end
