//
//  PreferenceViewController.h
//  fun4
//
//  Created by Ni Yan on 6/9/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface PreferenceViewController : UIViewController
- (IBAction)search:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *resultLabel;

@end
