//
//  MeGenderTableViewController.m
//  fun4
//
//  Created by Ni Yan on 7/16/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "MeGenderTableViewController.h"
#import "PreferenceTableViewController.h"
#import "AppDelegate.h"
#import "Traveler.h"

@interface MeGenderTableViewController ()

@end

@implementation MeGenderTableViewController
{
    NSArray *genderList;
    NSInteger genderSelection;
    NSManagedObjectContext *managedContextObject;
    Traveler *me;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedContextObject = appDelegate.managedObjectContext;
    [self loadMe];
    
    genderList = [[NSArray alloc] initWithObjects:@"Gal", @"Guy", @"Doesn't Matter", nil];
    genderSelection = me.gender.intValue;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return genderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [genderList objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone; // reset the cell accessory to none
    
    if (indexPath.row == genderSelection)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    genderSelection = indexPath.row;
    [tableView reloadData];
    [self saveMyGender:genderSelection];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadMe
{
    NSError *error = nil;
    NSFetchRequest *fetchRequest;
    NSArray * arrayOfTravelers;
    
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Traveler"];
    
    arrayOfTravelers = [managedContextObject executeFetchRequest:fetchRequest
                                                           error:&error];
    if ([arrayOfTravelers count] > 0)
    {
        me = [arrayOfTravelers objectAtIndex:0];
        
    }
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
}


- (void) saveMyGender:(NSInteger) gender
{
    [self loadMe];
    if (me == nil)
    {
        //insert me in core data
        me = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
        
        me.gender = [NSNumber numberWithInt:gender];
        
    }
    else
    {
        //update me in core data
        [me setValue: [NSNumber numberWithInt:gender] forKey:@"gender"];
        
    }
    
    [self saveMeToCoreData];
    
    [self saveMeToServer];
}

- (void) saveMeToCoreData
{
    NSError *error = nil;
    if ([managedContextObject save:&error])
    {
        NSLog(@"save successfully");
    }
    else
    {
        NSLog(@"fail to save");
    }
}

- (void) saveMeToServer
{
    __block PFObject *meAtServer = [PFObject objectWithClassName:@"Traveler"];
    if (me.phoneNumber == nil)
    {
        meAtServer[@"gender"] = me.gender;
        [meAtServer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Saved to server.");
            } else {
                NSLog(@"%@", error);
            }
        }];
    }
    else
    {
        
        PFQuery *query = [PFQuery queryWithClassName:@"Traveler"];
        [query whereKey:@"phoneNumber" equalTo:me.phoneNumber];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                if ([objects count] > 0)
                {
                    meAtServer = [objects objectAtIndex:0];
                    
                }
                meAtServer[@"gender"] = me.gender;
                [meAtServer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"Saved to server.");
                    } else {
                        NSLog(@"%@", error);
                    }
                }];
            }
            else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
    
}

@end
