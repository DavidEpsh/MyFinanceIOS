//
//  TakePictureViewController.m
//  Expense Maneger
//
//  Created by Admin on 1/11/16.
//  Copyright © 2016 elena. All rights reserved.
//

#import "TakePictureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "Model.h"


@interface TakePictureViewController ()

@end

@implementation TakePictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_imageName != nil) {
        [self.imageViewPhoto setImage:[[Model instance] readingImageFromFile:_imageName]];
    }else{
        _saveButton.enabled = NO;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)takePhoto:(id)sender {
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)choosePhoto:(id)sender {
    picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    [picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:picker animated:YES completion:NULL];
}

//The void statement for picking the image and display it in.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [self.imageViewPhoto setImage:image];
    _saveButton.enabled = YES;
    
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd-hh:mm:ss"];
        imagePath = [dateFormatter stringFromDate:[NSDate date]];
        imagePath = [imagePath stringByAppendingString:@".jpg"];
    } else {
        NSURL *imagePathTemp = [info objectForKey:@"UIImagePickerControllerReferenceURL"];
        NSString *imageName = [imagePathTemp lastPathComponent];
        imagePath = imageName;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
    
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)onSave:(id)sender {
    if (self.callback)
        self.callback(image, imagePath);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
