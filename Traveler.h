//
//  Traveler.h
//  fun4
//
//  Created by Ni Yan on 7/14/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Traveler : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) id picture;
@property (nonatomic, retain) NSNumber * coTravelerGender;
@property (nonatomic, retain) NSString * idAtServer;

@end
