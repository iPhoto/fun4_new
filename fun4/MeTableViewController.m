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
    [self displayMe];
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
        me = [arrayOfTravelers objectAtIndex:0];

    }
    
    if (error != nil) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

}

-(void)displayMe
{
    if (me != nil)
    {
        _name.text = me.name;
        _phone.text = me.phoneNumber;
        _profilePhoto.image = me.picture;
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
    return 4;
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
    UIImage *initialImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    NSData *data = UIImagePNGRepresentation(initialImage);
    
    UIImage *tempImage = [UIImage imageWithData:data];
    UIImage *fixedOrientationImage = [UIImage imageWithCGImage:tempImage.CGImage
                                                         scale:initialImage.scale
                                                   orientation:initialImage.imageOrientation];
    initialImage = fixedOrientationImage;
    
    _profilePhoto.image = initialImage;
    
    
    [[Picker presentingViewController] dismissViewControllerAnimated:YES completion:nil];

    [self loadMe];

    //save image to core data
    if (me == nil)
    {
        //insert me in core data
        me = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
        
        me.picture = _profilePhoto.image;
    }
    else
    {
        //update me in core data
        me.picture = _profilePhoto.image;
        
    }
    [self saveMeToCoreData];
    [self saveMyPictureToServer];

}

- (void) saveMyName:(NSString *) myName {
    
    [self loadMe];
    if (me == nil)
    {
        //insert me in core data
        me = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
        
        me.name = myName;
        
    }
    else
    {
        //update me in core data
        [me setValue: myName forKey:@"name"];
    }
    
    [self saveMeToCoreData];
    
    _name.text = me.name;
  
    //save to parse
    [self saveMeToServer];
    
    
}

- (void) saveMyPhone:(NSString *) myPhone{
    
    
    [self loadMe];
    if (me == nil)
    {
        //insert me in core data
        me = [NSEntityDescription insertNewObjectForEntityForName:@"Traveler" inManagedObjectContext:managedContextObject];
        
        me.phoneNumber = myPhone;
    }
    else
    {
        //update me in core data
        [me setValue: myPhone forKey:@"phoneNumber"];
    }
    
    [self saveMeToCoreData];
    
    _phone.text = me.phoneNumber;

    //save to parse
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
        meAtServer[@"name"] = (me.name == nil ? [NSString stringWithFormat:@""] : me.name);
        meAtServer[@"phoneNumber"] = (me.phoneNumber == nil ? [NSString stringWithFormat:@""] : me.phoneNumber);
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
                meAtServer[@"name"] = (me.name == nil ? [NSString stringWithFormat:@""] : me.name);
                meAtServer[@"phoneNumber"] = (me.phoneNumber == nil ? [NSString stringWithFormat:@""] : me.phoneNumber);
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

- (void) saveMyPictureToServer
{
    NSData* data = UIImageJPEGRepresentation(_profilePhoto.image, 1);
    PFFile *imageFile = [PFFile fileWithName:@"me.jpg" data:data];

    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            PFObject *meAtServer = [PFObject objectWithClassName:@"Traveler"];
            [meAtServer setObject:imageFile forKey:@"picture"];
            
            
            [meAtServer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    NSLog(@"Picture saved.");                }
                else{
                    // Log details of the failure
                    NSLog(@"Picture saving error: %@ %@", error, [error userInfo]);
                }
            }];
        }
    }];
}


+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}


- (id)transformedValue:(id)value {
    NSData *data = UIImageJPEGRepresentation(value, 1.0f);
    return data;
}


- (id)reverseTransformedValue:(id)value {
    return [UIImage imageWithData:value];

}

//- (IBAction)deleteCoreData:(id)sender {
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Traveler" inManagedObjectContext:managedContextObject];
//    
//    // Optionally add an NSPredicate if you only want to delete some of the objects.
//    
//    [fetchRequest setEntity:entity];
//    
//    NSArray *myObjectsToDelete = [managedContextObject executeFetchRequest:fetchRequest error:nil];
//    
//    for (Traveler *objectToDelete in myObjectsToDelete) {
//        [managedContextObject deleteObject:objectToDelete];
//    }
//    
//    
//}
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
