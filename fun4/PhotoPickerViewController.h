//
//  PhotoPickerViewController.h
//  fun4
//
//  Created by Ni Yan on 6/12/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPickerViewController : UIViewController
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPopoverControllerDelegate>
{
    UIImagePickerController *picker;
    IBOutlet UIImageView * selectedImage;
    IBOutlet UIImageView *pickedImage;
}
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)useCamera:(id)sender;
- (IBAction)useCameraRoll:(id)sender;

@end
