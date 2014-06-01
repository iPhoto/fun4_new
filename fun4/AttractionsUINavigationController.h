//
//  AttractionsUINavigationController.h
//  fun4
//
//  Created by Ni Yan on 4/13/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchCriteriaProtocol.h"

@interface AttractionsUINavigationController : UINavigationController
@property (weak, nonatomic) id <SearchCriteriaProtocol> delegate;

@end
