//
//  MeTableViewController.m
//  fun4
//
//  Created by Ni Yan on 6/15/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "MeTableViewController.h"
#import "PhotoPickerViewController.h"
#import "Traveler.h"
#import "AppDelegate.h"

@interface MeTableViewController ()

@end

@implementation MeTableViewController
{
    NSManagedObjectContext *managedContextObject;
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
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    managedContextObject = appDelegate.managedObjectContext;
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

    return 2;
}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
//    
//    
//    return cell;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIActionSheet *actionSheet;
    
    if (indexPath.row == 0)
    {
        //pop up the photo picker
        actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Pick a profile photo"
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Take Picture", @"Choose Existing", nil];
    }
    else if (indexPath.row == 1)
    {
        //pop up the text editor
        UIActionSheet *editName = [[UIActionSheet alloc]
                                initWithTitle:@"Name"
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"Save", nil];
        
        editName.tag = 8888;
        //UITextField *nameText = [[UITextField alloc]initWithFrame:CGRectMake(0, 44, 0, 0)];
        //UIDatePicker *  datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 44, 0, 0)];
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(45, 30, 200, 40)];
        tf.textColor = [UIColor colorWithRed:0/256.0 green:84/256.0 blue:129/256.0 alpha:1.0];
        tf.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
        tf.backgroundColor=[UIColor whiteColor];
        [tf setKeyboardType:UIKeyboardTypeAlphabet];
        tf.keyboardAppearance= UIKeyboardAppearanceAlert;
        tf.delegate = self;
        [tf setTag:10250];
        
        [editName addSubview:tf];
        //[editName showInView:self.view.superview];
        [editName showInView:self.view];
        
        //Change the height value in your CGRect to change the size of the actinsheet
        [editName setBounds:CGRectMake(0, 0, 400, 800)];
        [self performSelector: @selector(acceptInput:) withObject: editName];
    }
    [actionSheet showInView:self.view];

}
-(void)acceptInput: (UIActionSheet*)actionSheet
{
    
    UITextField*    textField = (UITextField*)[actionSheet viewWithTag:8888];
    
    UIWindow*       appWindow = [UIApplication sharedApplication].keyWindow;
    
    CGRect          frame     = textField.frame;
    
    [appWindow insertSubview:textField aboveSubview:actionSheet];
    
    frame.origin.y += 60.0; // move text field to same position as on action sheet
    
    textField.frame = frame;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Take Picture"]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Existing"]) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Save"]) {
        UITextField* myField = (UITextField*)[actionSheet viewWithTag:10250];
        
        [self saveMyName:myField.text];
    }
    [self presentModalViewController:picker animated:YES];

}



- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    _profilePhoto.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [[Picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void) saveMyName:(NSString *) myName{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Traveler" inManagedObjectContext:managedContextObject];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *existingMe = [managedContextObject executeFetchRequest:fetchRequest error:nil];
    
    
    if ([existingMe count] > 0)
    {
        [existingMe setValue: myName forKey:@"name"];
        
    }
    else
    {
        //insert
        Traveler *newMe = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
        
        newMe.name = myName;
        
        
        //save to parse
        PFObject *me = [PFObject objectWithClassName:@"Traveler"];
        me[@"name"] = newMe.name;
        
        [me saveEventually];
    }
    
    NSArray * arrayOfTravelers;
    
    fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Traveler"];
    
    arrayOfTravelers = [managedContextObject executeFetchRequest:fetchRequest
                                                           error:&error];
    
    _name.text = [[arrayOfTravelers objectAtIndex:0] name];
    
    if ([managedContextObject save:&error])
    {
        NSLog(@"save successfully");
    }
    else
    {
        NSLog(@"fail to save");
    }
    
}


//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    
//    if ([segue.identifier isEqualToString:@"photoPicker"])
//    {
//        PhotoPickerViewController *nextController;
//        nextController = segue.destinationViewController;
//    }
//    
//}



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




@end
