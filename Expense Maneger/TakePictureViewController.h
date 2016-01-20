
#import <UIKit/UIKit.h>
#import "Expense.h"
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
@property (weak, nonatomic) Expense *currExpense;

@property (weak, nonatomic) NSString *imageName;
- (IBAction)onSave:(NSString*)imagePath;

@end
