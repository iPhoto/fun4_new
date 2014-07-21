//
//  PreferenceViewController.m
//  fun4
//
//  Created by Ni Yan on 6/9/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "PreferenceViewController.h"
#import "Traveler.h"

@interface PreferenceViewController ()

@end

@implementation PreferenceViewController

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
    // Do any additional setup after loading the view.
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

- (IBAction)search:(id)sender {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"phoneNumber = '617 645 4603'"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Traveler" predicate:predicate];
    NSArray* travelerArray = [query findObjects];
    
    _resultLabel.text = [NSString stringWithFormat:@"Found %lu travelers %@", (unsigned long)[travelerArray count], [travelerArray objectAtIndex:0][@"name"]];
}
@end
