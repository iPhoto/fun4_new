//
//  AttractionDetailViewController.h
//  fun4
//
//  Created by Ni Yan on 4/24/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONKit.h"
#import "attractionDetailProtocol.h"

@interface AttractionDetailViewController : UIViewController <attractionDetailProtocol>
@property (weak, nonatomic) id <attractionDetailProtocol> delegate;

@property(nonatomic, retain) NSObject *detail;
@property (strong, nonatomic) IBOutlet UILabel *attractionName;
@property (strong, nonatomic) IBOutlet UILabel *attractionAddress;
@property (strong, nonatomic) IBOutlet UILabel *attractionPhoneNumber;
@property (strong, nonatomic) IBOutlet UIImageView *mainImage;

@end
