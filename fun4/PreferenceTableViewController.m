//
//  PreferenceTableViewController.m
//  fun4
//
//  Created by Ni Yan on 7/12/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "PreferenceTableViewController.h"
#import "GenderTableViewController.h"
#import "AppDelegate.h"
#import "Traveler.h"

@interface PreferenceTableViewController ()
{
}
@end


@implementation PreferenceTableViewController
{
    NSManagedObjectContext *managedContextObject;
    CGRect backToOriginal;
    UIView *popup;
    Traveler *me;
    //NSArray *preferenceList;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    managedContextObject = appDelegate.managedObjectContext;
    
//    preferenceList = [[NSArray alloc] initWithObjects:@"Co-traveler Gender", @"Transportation", @"Lodging", @"Food", nil];
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
    return 4;
}

//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    
//    cell.textLabel.text = [preferenceList objectAtIndex:indexPath.row];
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    
//    return cell;
//    
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (indexPath.row == 0)
    {

    }
    else if (indexPath.row == 1)
    {
        
    }
    else if (indexPath.row == 2)
    {
    }
}

-(void) CreateSlideOut
{
    
    CGRect frame=CGRectMake(0, CGRectGetMaxY(self.view.bounds), 320, 300);
    backToOriginal=frame;
    popup=[[UIView alloc]initWithFrame:frame];
    popup.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:popup];
    
}

-(void) removePopUp

{
    [UIView beginAnimations:nil context:nil];
    [popup setFrame:backToOriginal];
    [UIView commitAnimations];
}

-(IBAction) CancelClicked : (id) sender
{
    [self removePopUp];
}

- (void)dealloc {
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
