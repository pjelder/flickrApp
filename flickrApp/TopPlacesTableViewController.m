//
//  TopPlacesTableViewController.m
//  flickrApp
//
//  Created by Paul on 4/1/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"

@interface TopPlacesTableViewController ()
@property (strong, nonatomic) NSDictionary *results;
@property (strong, nonatomic) NSMutableArray *database;  //Array of NSArray of placeIds
@property (strong, nonatomic) NSArray *places;  //of type NSDictionary place
@property (strong, nonatomic) NSMutableDictionary *countries;  //Key of country, value is NSArray of placeIds
@property (strong, nonatomic) NSMutableDictionary *regions;  //Key of placeId, value is region
@property (strong, nonatomic) NSMutableDictionary *placeNames; //Key is placeID, value is "country"
@end

@implementation TopPlacesTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)refresh {
    [self.refreshControl beginRefreshing];
    dispatch_queue_t otherQ = dispatch_queue_create("Q", NULL);
    dispatch_async(otherQ, ^{
        // do something in another thread
        [self downloadData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
        });
    });
}


- (void)downloadData
{
    NSData *flickrData = [NSData dataWithContentsOfURL:[FlickrFetcher URLforTopPlaces]];
    self.results = [NSJSONSerialization JSONObjectWithData:flickrData
                                                   options:0 error:NULL];
    self.places = [self.results valueForKeyPath:FLICKR_RESULTS_PLACES];
    for (NSDictionary *place in self.places) {
        NSString *placeId = place[FLICKR_PLACE_ID];
        
        NSData *placeData = [NSData dataWithContentsOfURL:[FlickrFetcher URLforInformationAboutPlace:placeId]];
        NSDictionary *placeInfo = [NSJSONSerialization JSONObjectWithData:placeData
                                                                  options:0 error:NULL];
        
        //NSString *placeName = [FlickrFetcher extractNameOfPlace:(id)placeId fromPlaceInformation:placeInfo];  //Full name
        NSString *regionName = [FlickrFetcher extractRegionNameFromPlaceInformation:placeInfo];   //Region
        NSString *countryName = [FlickrFetcher extractCountryNameFromPlaceInformation:placeInfo];  //Country
        
        NSMutableArray *placesForCountry = [self.countries valueForKey:countryName];
        if (!placesForCountry) {
            placesForCountry = [[NSMutableArray alloc] init];
            [self.countries setValue:placesForCountry forKey:countryName];
        }
        [placesForCountry addObject:placeId];
        
        [self.placeNames setValue:countryName forKey:placeId];
        [self.regions setValue:regionName forKey:placeId];
    }
    
    //convert locations NSDictionary to database
    for (NSArray *places in [self.countries allValues]) {
        [self.database addObject:places];
    }
    NSLog(@"%@", self.results.description);
    [self.tableView reloadData];
}

- (NSMutableDictionary *)countries
{
    if (!_countries) _countries = [[NSMutableDictionary alloc] init];
    return _countries;
}

- (NSMutableDictionary *)regions
{
    if (!_regions) _regions = [[NSMutableDictionary alloc] init];
    return _regions;
}

- (NSMutableArray *)database
{
    if (!_database) _database = [[NSMutableArray alloc] init];
    return _database;
}

- (NSMutableDictionary *)placeNames
{
    if (!_placeNames) _placeNames = [[NSMutableDictionary alloc] init];
    return _placeNames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.database count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSString *placeId = self.places[section][FLICKR_PLACE_ID];
    return [self.database[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Country Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *placeId = self.database[indexPath.section][indexPath.row];
    cell.textLabel.text = [self.placeNames valueForKey:placeId];
    cell.detailTextLabel.text = [self.regions valueForKey:placeId];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
