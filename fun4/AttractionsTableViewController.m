//
//  AttractionsTableViewController.m
//  fun4
//
//  Created by Ni Yan on 4/13/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "AttractionsTableViewController.h"
#import "AttractionDetailViewController.h"

@interface AttractionsTableViewController () 

@end

@implementation AttractionsTableViewController

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString* dest = [self.delegate destination];

    [self getAttractionsByDestination: dest];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65; //height of the cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    NSString *searchEngine = [NSString stringWithFormat: @"mapquest"];
//    
//    NSComparisonResult result;
//    
//    result = [searchEngine isEqualToString:[NSString stringWithFormat:@"google"]];
//    
//    if (result == 1) //google
//    {
   
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attractionCell"];
    
        if (cell == nil) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"attractionCell" forIndexPath:indexPath];
        }
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
    
        UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 245, 45)];
        textView.text = [[_results objectAtIndex:indexPath.row] valueForKey:@"name"];
        textView.numberOfLines = 3;
        textView.autoresizesSubviews = YES;
        
        
        NSString *attractionPhotoId = [[[[_results objectAtIndex:indexPath.row] valueForKey:@"photos"] objectAtIndex:0] valueForKey:@"photo_reference"];

        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=%@&sensor=true&key=AIzaSyCIOBPZBItp_P4pJmvNb_nevarJQRQT0CY", attractionPhotoId]]];
        
        
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
        imageView.backgroundColor=[UIColor clearColor];
        [imageView.layer setCornerRadius:8.0f];
        [imageView.layer setMasksToBounds:YES];
        [imageView setImage:[UIImage imageWithData: imageData]];
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:textView];
        
        return cell;
//    }
    
//    else
//    {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"attractionCell" forIndexPath:indexPath];
//        
//        UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, 245, 45)];
//        textView.text = [[_results objectAtIndex:indexPath.row] valueForKey:@"name"];
//        textView.numberOfLines = 2;
//        textView.autoresizesSubviews = YES;
//        
//
//        [cell.contentView addSubview:textView];
//        
//        return cell;
//
//    }
}

- (void) getAttractionsByDestination: (NSString*) dest
{
    double latitude = 0.0;
    double longitude = 0.0;
    NSError *error = nil;
    CLLocationCoordinate2D location;
    
    NSString *googleGeoUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", dest];
    
    googleGeoUrl = [googleGeoUrl stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:googleGeoUrl]];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
    
    NSArray *locationArray = [[[jsonDict valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"];
    
    locationArray = [locationArray objectAtIndex:0];
    
    NSString *latitudeString = [locationArray valueForKey:@"lat"];
    NSString *longitudeString = [locationArray valueForKey:@"lng"];
    
    NSString *statusString = [jsonDict valueForKey:@"status"];
    
    if ([statusString isEqualToString:@"OK"])
    {
        latitude = [latitudeString doubleValue];
        longitude = [longitudeString doubleValue];
    }
    
    else
    {
        NSLog(@"Couldn't find address");
    }
    
    location.longitude = longitude;
    location.latitude = latitude;
    
    [self getAttractionsByGeoCode:location];
}

- (void) getAttractionsByGeoCode: (CLLocationCoordinate2D) geo
{
    
    NSString *searchEngine = [NSString stringWithFormat: @"google"];
    
    NSComparisonResult result;

    result = [searchEngine isEqualToString:[NSString stringWithFormat:@"google"]];
    
    if (result == 1) //google
    {
    
        NSString *googleAttractionSearchUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=5000&rankby=prominence&key=AIzaSyCIOBPZBItp_P4pJmvNb_nevarJQRQT0CY&sensor=false", geo.latitude, geo.longitude];

        NSURL *encodedUrl = [NSURL URLWithString:[googleAttractionSearchUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];

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
                _results = [jsonDictionary objectForKey:@"results"];
                
            }
        }
        else
        {
            NSLog(@"connection failed");
        }
    }
    else { //mapquest
        
        //http://www.mapquestapi.com/search/v2/radius?key=Fmjtd%7Cluur2d6rn9%2C8l%3Do5-9abs54&callback=renderBasicSearchNarrative&maxMatches=10&origin=40.099998,-76.305603&radius=25&hostedData=mqap.ntpois|group_sic_code%20ILIKE%20?|799972


        NSString* mapquestSearchUrl = [[NSString stringWithFormat:@"http://www.mapquestapi.com/search/v2/radius?key=Fmjtd%%7Cluur2d6rn9%%2C8l%%3Do5-9abs54&callback=renderBasicSearchNarrative&maxMatches=10&origin=%f,%f&hostedData=mqap.ntpois|group_sic_code ILIKE ?|799972", geo.latitude, geo.longitude] stringByReplacingOccurrencesOfString:@"%%" withString:@"%"];//799972 -- tourist attractions
        
       
        NSMutableCharacterSet * URLQueryPartAllowedCharacterSet;
        
        URLQueryPartAllowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [URLQueryPartAllowedCharacterSet addCharactersInRange:NSMakeRange('%', 1)];
        
        NSURL *encodedUrl = [NSURL URLWithString: [mapquestSearchUrl stringByAddingPercentEncodingWithAllowedCharacters:URLQueryPartAllowedCharacterSet]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: encodedUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
        
        if (connection)
        {
            NSError * err = nil;
            NSURLResponse *responseData = nil;
            NSData *jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse: &responseData error:&err];
            
            NSString* dataStr = [[[NSString stringWithUTF8String:[jsonData bytes]] stringByReplacingOccurrencesOfString:@"renderBasicSearchNarrative(" withString:@""]
                stringByReplacingOccurrencesOfString:@");" withString:@""];
            
            jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDictionary = [jsonData objectFromJSONData];
            
            NSArray *mapQuestResults = [jsonDictionary objectForKey:@"searchResults"];

            _results = [[NSMutableArray alloc] init];
            NSInteger count = [mapQuestResults count];
            for (int i = 0; i < count; i++)
            {
            
                //now do the google search for details
                NSString* detailSearchUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?key=AIzaSyCIOBPZBItp_P4pJmvNb_nevarJQRQT0CY&query=%@", [[mapQuestResults objectAtIndex:i] valueForKey:@"name"]];
                
                NSURL *encodedUrl = [NSURL URLWithString:[detailSearchUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
                
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
                        NSArray *detailResults = [jsonDictionary objectForKey:@"results"];
                        [_results insertObject:[detailResults objectAtIndex:0] atIndex:i];
                         
                    }
                }
                else
                {
                    NSLog(@"connection failed");
                }
                
            }
        }
        else
        {
            NSLog(@"connection failed");
        }
    }
    return;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tappedAttraction = [Attraction alloc];
    _tappedAttraction.attractionId = [[_results objectAtIndex:indexPath.row] valueForKey:@"reference"];
    _tappedAttraction.name = [[_results objectAtIndex:indexPath.row] valueForKey:@"name"];
    _tappedAttraction.mainImageReference = [[[[_results objectAtIndex:indexPath.row] valueForKey:@"photos"] objectAtIndex:0] valueForKey:@"photo_reference"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"detailSegue"])
    {
        AttractionDetailViewController *nextController;
        nextController = segue.destinationViewController;
        nextController.delegate = self;
    }
    
}

- (Attraction *) attraction
{

    return _tappedAttraction;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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


