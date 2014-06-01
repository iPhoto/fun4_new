//
//  MeViewController.m
//  fun4
//
//  Created by Ni Yan on 5/26/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "MeViewController.h"
#import "AppDelegate.h"
#import "Traveler.h"

@interface MeViewController ()

@end

@implementation MeViewController

{
    NSManagedObjectContext *managedContextObject;
}

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
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    managedContextObject = appDelegate.managedObjectContext;
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest;
    NSArray * arrayOfTravelers;
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Traveler"];
    
    arrayOfTravelers = [managedContextObject executeFetchRequest:fetchRequest
                                                           error:&error];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
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

- (IBAction)saveMe:(id)sender {
    Traveler *traveler = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
    
    traveler.name = _myName.text;
    traveler.phoneNumber = _myPhone.text;
    
    NSError *error = nil;
    NSFetchRequest *fetchRequest;
    NSArray * arrayOfTravelers;
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Traveler"];
    
    arrayOfTravelers = [managedContextObject executeFetchRequest:fetchRequest
                                                           error:&error];
    
    _myInfoLabel.text = [[arrayOfTravelers objectAtIndex:0] name];
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }


    
}
@end
