//
//  PreferenceTableViewController.h
//  fun4
//
//  Created by Ni Yan on 7/12/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coTravelerGenderProtocol.h"

@interface PreferenceTableViewController : UITableViewController
@property (weak, nonatomic) id <coTravelerGenderProtocol> delegate;

@end
