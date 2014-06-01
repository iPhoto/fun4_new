//
//  AttractionDetailViewController.m
//  fun4
//
//  Created by Ni Yan on 4/24/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "AttractionDetailViewController.h"
#import "Attraction.h"

@interface AttractionDetailViewController ()

@end

@implementation AttractionDetailViewController

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
    Attraction * attraction = [self.delegate attraction];
    self.attractionName.text = attraction.name;
    
    //get and display main photo
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=AIzaSyCIOBPZBItp_P4pJmvNb_nevarJQRQT0CY", attraction.mainImageReference]]];
    
    
    _mainImage.backgroundColor=[UIColor clearColor];
    [_mainImage.layer setCornerRadius:8.0f];
    [_mainImage.layer setMasksToBounds:YES];
    [_mainImage setImage:[UIImage imageWithData: imageData]];

    //get attraction details
    NSString *googleAttractionDetailUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/details/json?key=AIzaSyCIOBPZBItp_P4pJmvNb_nevarJQRQT0CY&reference=%@&sensor=false", attraction.attractionId];
    
    NSURL *encodedUrl = [NSURL URLWithString:[googleAttractionDetailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: encodedUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
    if (connection)
    {
        NSError * err = nil;
        NSURLResponse *responseData = nil;
        NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse: &responseData error:&err];
        
        NSDictionary *jsonDictionary = [jsonData objectFromJSONData];
        
        NSString *status = (NSString *)[jsonDictionary valueForKey: @"status"];
        NSString *ok = @"OK";
        
        if ([status isEqualToString: ok])
        {
            _detail = [jsonDictionary objectForKey:@"result"];
            
        }
    }
    else
    {
        NSLog(@"connection failed");
    }
    
    //get small photos
    NSArray *photoReferences = [[_detail valueForKey:@"photos"] valueForKey:@"photo_reference"];
    
    for (int i = 0; i < [photoReferences count]; i++)
    {

        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=AIzaSyCIOBPZBItp_P4pJmvNb_nevarJQRQT0CY", [photoReferences objectAtIndex:i]]]];
        
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(2.5 + i * 40, 200, 40, 40)];
        imageView.backgroundColor=[UIColor clearColor];
        [imageView.layer setCornerRadius:8.0f];
        [imageView.layer setMasksToBounds:YES];
        [imageView setImage:[UIImage imageWithData: imageData]];
        
        [self.view addSubview:imageView];
    }

    //get address and phone number
    self.attractionAddress.text = [_detail valueForKey:@"formatted_address"];
    self.attractionPhoneNumber.text = [_detail valueForKey:@"formatted_phone_number"];
    
    //get reviews
    NSArray *reviews = [[_detail valueForKey:@"reviews"] valueForKey:@"text"];
    
    for (int i = 0; i < [reviews count]; i++)
    {
        
        UITextView *textView=[[UITextView alloc] initWithFrame:CGRectMake(2.5, 260 + i * 40, 300, 200)];
        textView.text = [reviews objectAtIndex: i];
        
        [self.view addSubview:textView];
    }


    [super viewDidLoad];
    
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

@end
