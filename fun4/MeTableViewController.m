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
#import "UIImage+Scale.h"

@interface MeTableViewController ()

@end

@implementation MeTableViewController
{
    NSManagedObjectContext *managedContextObject;
    CGRect backToOriginal;
    UIView *popup;
    Traveler *me;
    UIImageView *_profilePhoto;

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

- (void) viewWillAppear:(BOOL)animated {
    [self loadMe];
    [self resizePictureFrame];
    [self addBorderToPhoto];
    [self.tableView reloadData];
    [super viewWillAppear:animated];
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
        [_profilePhoto setImage: me.picture];
    }
    [self resizePictureFrame];
    
    [self addBorderToPhoto];

    
}

- (void)resizePictureFrame
{
     
    UIImage *myPicture = me.picture;
    
    if (myPicture == nil)
    {
        if (me == nil)
        {
            myPicture = [UIImage imageNamed:@"nogender.png"];
        }
        else if ([me.gender intValue] == 0)
        {
            myPicture = [UIImage imageNamed:@"boy.png"];
        }
        else if ([me.gender intValue] == 1)
        {
            myPicture = [UIImage imageNamed:@"girl.png"];
        }
        
    }
    
    float ratio = myPicture.size.height/myPicture.size.width;
    
    _profilePhoto.image = nil;
    _profilePhoto.frame = CGRectMake(10, 10, 0, 0);
    
    _profilePhoto = [[UIImageView alloc]initWithImage:myPicture];
    
    _profilePhoto.frame = CGRectMake(10, 10, 170, 170 * ratio);

    // Scale the image
    //UIImage *scaledPicture = [myPicture scaleToSize:CGSizeMake(60.0f, 60.0f)];
    
    _profilePhoto.contentMode = UIViewContentModeScaleAspectFit;
    

}

-(void)addBorderToPhoto
{
    UIColor *borderColor = [UIColor colorWithRed:0.24 green:0.47 blue:0.85 alpha:1.0];
    [_profilePhoto.layer setBorderColor:borderColor.CGColor];
    [_profilePhoto.layer setBorderWidth:3.0];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        [cell addSubview:_profilePhoto];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return _profilePhoto.frame.size.height + 20;
    }
    else
    {
        return 53;
    }
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
    [popup setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"treeWatermark.png"]]];

    [self.view addSubview:popup];
    
}

-(void) slideNamePopup
{
    
    
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame=CGRectMake(20, 90, 80, 40);
    cancelButton.backgroundColor=[UIColor clearColor];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(CancelClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame=CGRectMake(260, 90, 40, 40);
    doneButton.backgroundColor=[UIColor clearColor];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Save" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(NameSaveClicked:) forControlEvents:UIControlEventTouchUpInside];


    nameInput = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 280, 40)];

    nameInput.delegate=self;
    nameInput.autocorrectionType = UITextAutocorrectionTypeNo;
    [nameInput setBackgroundColor:[UIColor clearColor]];
    [nameInput setBorderStyle:UITextBorderStyleLine];

    
    [popup addSubview:nameInput];
    [popup addSubview:doneButton];
    [popup addSubview:cancelButton];
    
    CGRect frame=CGRectMake(0, 0, 320, 480);
    
    [UIView beginAnimations:nil context:nil];
    
    [popup setFrame:frame];
    
    [UIView commitAnimations];
    
    [nameInput becomeFirstResponder];
}

-(void) slidePhonePopup
{
    
    UIButton *cancelButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame=CGRectMake(20, 90, 80, 40);
    cancelButton.backgroundColor=[UIColor clearColor];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(CancelClicked:) forControlEvents:UIControlEventTouchUpInside];

    UIButton *doneButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    doneButton.frame=CGRectMake(260, 90, 40, 40);
    doneButton.backgroundColor=[UIColor clearColor];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitle:@"Save" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(PhoneSaveClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    phoneInput = [[UITextField alloc] initWithFrame:CGRectMake(20, 40, 280, 40)];
    
    phoneInput.delegate=self;
    phoneInput.autocorrectionType = UITextAutocorrectionTypeNo;
    [phoneInput setBackgroundColor:[UIColor clearColor]];
    [phoneInput setBorderStyle:UITextBorderStyleLine];
    
    [popup addSubview:phoneInput];
    [popup addSubview:doneButton];
    [popup addSubview:cancelButton];
    
    CGRect frame=CGRectMake(0, 0, 320, 480);
    
    [UIView beginAnimations:nil context:nil];
    
    [popup setFrame:frame];
    
    [UIView commitAnimations];
    [phoneInput setKeyboardType:UIKeyboardTypePhonePad];
    [phoneInput becomeFirstResponder];
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

-(IBAction) NameSaveClicked : (id) sender
{
    [self saveMyName: nameInput.text];
    [self removePopUp];
}

-(IBAction) PhoneSaveClicked : (id) sender
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
