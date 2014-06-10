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
    if ([arrayOfTravelers count] > 0)
    {
        _myName.text = [[arrayOfTravelers objectAtIndex:0] name];
        _myPhone.text = [[arrayOfTravelers objectAtIndex:0] phoneNumber];
    }
    
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
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Traveler" inManagedObjectContext:managedContextObject];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *existingMe = [managedContextObject executeFetchRequest:fetchRequest error:nil];
    

    if ([existingMe count] > 0)
    {
        [existingMe setValue:_myName.text forKey:@"name"];
        [existingMe setValue:_myPhone.text forKey:@"phoneNumber"];
 
    }
    else
    {
        //insert
        Traveler *newMe = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
    
        newMe.name = _myName.text;
        newMe.phoneNumber = _myPhone.text;
 
    
        //save to parse
        PFObject *me = [PFObject objectWithClassName:@"Traveler"];
        me[@"name"] = newMe.name;
        me[@"phoneNumber"] = newMe.phoneNumber;

        [me saveEventually];
    }

    NSArray * arrayOfTravelers;
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Traveler"];
    
    arrayOfTravelers = [managedContextObject executeFetchRequest:fetchRequest
                                                           error:&error];
    
    _myInfoLabel.text = [[arrayOfTravelers objectAtIndex:0] name];
    
    if ([managedContextObject save:&error])
    {
        NSLog(@"save successfully");
    }
    else
    {
        NSLog(@"fail to save");
    }
   


    
}

- (IBAction)deleteCoreData:(id)sender {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Traveler" inManagedObjectContext:managedContextObject];
    
    // Optionally add an NSPredicate if you only want to delete some of the objects.
    
    [fetchRequest setEntity:entity];
    
    NSArray *myObjectsToDelete = [managedContextObject executeFetchRequest:fetchRequest error:nil];
    
    for (Traveler *objectToDelete in myObjectsToDelete) {
        [managedContextObject deleteObject:objectToDelete];
    }
    

}


@end
