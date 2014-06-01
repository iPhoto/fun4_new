//
//  MeViewController.h
//  fun4
//
//  Created by Ni Yan on 5/26/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeViewController : UIViewController
- (IBAction)saveMe:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *myName;
@property (strong, nonatomic) IBOutlet UITextField *myPhone;
@property (strong, nonatomic) IBOutlet UILabel *myInfoLabel;

@end
