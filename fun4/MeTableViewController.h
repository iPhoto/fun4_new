//
//  MeTableViewController.h
//  fun4
//
//  Created by Ni Yan on 6/15/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MeTableViewController : UITableViewController<UITextFieldDelegate, UIActionSheetDelegate>
{
    UITextField *nameInput;
    UITextField *phoneInput;
}

@property (strong, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *phone;


@end
