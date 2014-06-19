//
//  PhotoPickerViewController.m
//  fun4
//
//  Created by Ni Yan on 6/12/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "PhotoPickerViewController.h"

@interface PhotoPickerViewController ()

@end

@implementation PhotoPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{

    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)useCamera:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        
    {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
    }
    else
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker animated:YES completion:nil];
}



- (IBAction)useCameraRoll:(id)sender {
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *) Picker {
    
    [[Picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *) Picker

didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    pickedImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [[Picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    

    
}
@end
