//
//  Traveler.h
//  fun4
//
//  Created by Ni Yan on 5/26/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Traveler : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSString * gender;

@end
