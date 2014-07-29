//
//  GenderTableViewController.m
//  fun4
//
//  Created by Ni Yan on 7/13/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "GenderTableViewController.h"
#import "coTravelerGenderProtocol.h"
#import "PreferenceTableViewController.h"
#import "AppDelegate.h"
#import "Traveler.h"

@interface GenderTableViewController ()
    @property (nonatomic) int coTravelerGender;
    @property (nonatomic, weak) id<coTravelerGenderProtocol> delegate;
@end

@implementation GenderTableViewController
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
    
    //genderList = [[NSArray alloc] initWithObjects:@"Gal(s)", @"Guy(s)", @"Doesn't Matter", nil];
    genderSelection = me.coTravelerGender.intValue;
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.textLabel.text = [genderList objectAtIndex:indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryNone; // reset the cell accessory to none
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.row == genderSelection)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    genderSelection = indexPath.row;
    [tableView reloadData];
    [self saveCoTravelerGender:genderSelection];
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


- (void) saveCoTravelerGender:(NSInteger) gender
{
    [self loadMe];
    if (me == nil)
    {
        //insert me in core data
        me = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
        
        me.coTravelerGender = [NSNumber numberWithInt:gender];
        
    }
    else
    {
        //update me in core data
        [me setValue: [NSNumber numberWithInt:gender] forKey:@"coTravelerGender"];

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
        meAtServer[@"coTravelerGender"] = me.coTravelerGender;
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
                meAtServer[@"coTravelerGender"] = me.coTravelerGender;
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
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
