//
//  MeTableViewController.m
//  fun4
//
//  Created by Ni Yan on 6/15/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "MeTableViewController.h"
#import "PhotoPickerViewController.h"
#import "AppDelegate.h"
#import "Traveler.h"

@interface MeTableViewController ()

@end

@implementation MeTableViewController
{
    NSManagedObjectContext *managedContextObject;
    CGRect backToOriginal;
    UIView *popup;
    Traveler *me;

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
    [self loadMe];
    [super viewDidLoad];
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
        _name.text = [[arrayOfTravelers objectAtIndex:0] name];
        _phone.text = [[arrayOfTravelers objectAtIndex:0] phoneNumber];
        me = [arrayOfTravelers objectAtIndex:0];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

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
        [actionSheet showInView:self.view];
    }
    else if (indexPath.row == 1)
    {
        //edit name
        [self CreateSlideOut];
        [self slideNamePopup];

    }
    else if (indexPath.row == 2)
    {
        //edit phone
        [self CreateSlideOut];
        [self slidePhonePopup];
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

-(void) slideNamePopup
{
    
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame=CGRectMake(60, 190, 200, 40);
    doneButton.backgroundColor=[UIColor clearColor];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(NameDoneClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame=CGRectMake(60, 300, 200, 40);
    cancelButton.backgroundColor=[UIColor clearColor];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(CancelClicked:) forControlEvents:UIControlEventTouchUpInside];


    nameInput = [[UITextField alloc] initWithFrame:CGRectMake(20, 28, 280, 40)];
    nameInput.delegate=self;
    nameInput.autocorrectionType = UITextAutocorrectionTypeNo;
    [nameInput setBackgroundColor:[UIColor clearColor]];
    [nameInput setBorderStyle:UITextBorderStyleRoundedRect];
    
    [popup addSubview:nameInput];
    [popup addSubview:doneButton];
    [popup addSubview:cancelButton];
    
    CGRect frame=CGRectMake(0, 0, 320, 480);
    
    [UIView beginAnimations:nil context:nil];
    
    [popup setFrame:frame];
    
    [UIView commitAnimations];
}

-(void) slidePhonePopup
{
    
    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame=CGRectMake(60, 190, 200, 40);
    doneButton.backgroundColor=[UIColor clearColor];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(PhoneDoneClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame=CGRectMake(60, 300, 200, 40);
    cancelButton.backgroundColor=[UIColor clearColor];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(CancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    phoneInput = [[UITextField alloc] initWithFrame:CGRectMake(20, 28, 280, 40)];
    phoneInput.delegate=self;
    phoneInput.autocorrectionType = UITextAutocorrectionTypeNo;
    [phoneInput setBackgroundColor:[UIColor clearColor]];
    [phoneInput setBorderStyle:UITextBorderStyleRoundedRect];
    
    [popup addSubview:phoneInput];
    [popup addSubview:doneButton];
    [popup addSubview:cancelButton];
    
    CGRect frame=CGRectMake(0, 0, 320, 480);
    
    [UIView beginAnimations:nil context:nil];
    
    [popup setFrame:frame];
    
    [UIView commitAnimations];
}


-(void) removePopUp

{
    [UIView beginAnimations:nil context:nil];
    [popup setFrame:backToOriginal];
    [UIView commitAnimations];
    [nameInput resignFirstResponder];
    [phoneInput resignFirstResponder];
}

-(IBAction) CancelClicked : (id) sender
{
    [self removePopUp];
}

-(IBAction) NameDoneClicked : (id) sender
{
    [self saveMyName: nameInput.text];
    [self removePopUp];
}

-(IBAction) PhoneDoneClicked : (id) sender
{
    [self saveMyPhone: phoneInput.text];
    [self removePopUp];
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
    [self presentViewController:picker animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *) Picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _profilePhoto.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [[Picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    //save image to core data
    me.picture = [info objectForKey:UIImagePickerControllerOriginalImage];
}

- (void) saveMyName:(NSString *) myName{
    
    NSError *error = nil;

    
    [me setValue: myName forKey:@"name"];
        
    
    //save to parse
    PFObject *meAtServer = [PFObject objectWithClassName:@"Traveler"];
    meAtServer[@"name"] = me.name;
    
    [meAtServer saveEventually];
    
    
    _name.text = me.name;
    
    if ([managedContextObject save:&error])
    {
        NSLog(@"save successfully");
    }
    else
    {
        NSLog(@"fail to save");
    }
    
}

- (void) saveMyPhone:(NSString *) myPhone{
    
    
    
    NSError *error = nil;
    
    
    [me setValue: myPhone forKey:@"phoneNumber"];
    
    //save to parse
    PFObject *meAtServer = [PFObject objectWithClassName:@"Traveler"];
    meAtServer[@"phoneNumber"] = me.phoneNumber;
    
    [meAtServer saveEventually];
    
    
    _phone.text = me.phoneNumber;
    
    if ([managedContextObject save:&error])
    {
        NSLog(@"save successfully");
    }
    else
    {
        NSLog(@"fail to save");
    }

}
    


+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}


- (id)transformedValue:(id)value {
    NSData *data = UIImagePNGRepresentation(value);
    return data;
}


- (id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];

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
