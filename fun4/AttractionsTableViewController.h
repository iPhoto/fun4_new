//
//  AttractionsTableViewController.h
//  fun4
//
//  Created by Ni Yan on 4/13/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "JSONKit.h"
#import "searchCriteriaProtocol.h"
#import "attractionDetailProtocol.h"

@interface AttractionsTableViewController : UITableViewController <attractionDetailProtocol>
@property (weak, nonatomic) id <SearchCriteriaProtocol> delegate;
@property(nonatomic, retain) NSMutableArray *results;
@property(nonatomic, retain) Attraction *tappedAttraction;

@end
