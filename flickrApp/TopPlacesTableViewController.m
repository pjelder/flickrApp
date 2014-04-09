//
//  TopPlacesTableViewController.m
//  flickrApp
//
//  Created by Paul on 4/1/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPlaces.h"
#import "Place.h"

@interface TopPlacesTableViewController ()
//@property (strong, nonatomic) NSDictionary *results;
@property (strong, nonatomic) TopPlaces *topPlaces;
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

- (TopPlaces *)topPlaces
{
    if (!_topPlaces) _topPlaces = [[TopPlaces alloc] init];
    return _topPlaces;
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
    [self.topPlaces downloadData];
    //self.topPlaces = [[TopPlaces alloc] init];
    [self.tableView reloadData];
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
    //return [self.database count];
    return [self.topPlaces numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSString *placeId = self.places[section][FLICKR_PLACE_ID];
    //return [self.database[section] count];
    return [self.topPlaces numberOfRecordsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top Places Country Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Place *place = [self.topPlaces getPlaceAtIndexPath:indexPath];
    //NSString *placeId = self.database[indexPath.section][indexPath.row];
    cell.textLabel.text = place.name;
    //[self.placeNames valueForKey:placeId];
    cell.detailTextLabel.text = place.region;

    //[self.regions valueForKey:placeId];
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.topPlaces countryInSection:section];
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
