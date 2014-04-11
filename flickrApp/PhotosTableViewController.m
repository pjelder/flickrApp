//
//  PhotosTableViewController.m
//  flickrApp
//
//  Created by Paul on 4/11/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "Photo.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"

@interface PhotosTableViewController ()

@end

@implementation PhotosTableViewController

- (NSMutableArray *)photos
{
    if (!_photos) _photos = [[NSMutableArray alloc] init];
    return _photos;
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
    [self refresh];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    NSData *flickrData = [NSData dataWithContentsOfURL:
                          [FlickrFetcher URLforPhotosInPlace:self.placeId
                                                  maxResults:50]];
    
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:flickrData
                                                            options:0 error:NULL];
    
    NSArray *photoResults = [results valueForKeyPath:FLICKR_RESULTS_PHOTOS];
    for (NSDictionary *photoInfo in photoResults) {
        Photo *photo = [[Photo alloc] init];
        NSURL *photoURL = [FlickrFetcher URLforPhoto:photoInfo format:FlickrPhotoFormatOriginal];
        photo.url = photoURL;
        
        photo.title = [photoInfo valueForKeyPath:FLICKR_PHOTO_TITLE];
        photo.description = [photoInfo valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
        [self.photos addObject:photo];
    }
    
    [self.tableView reloadData];
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
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Photo *photo = self.photos[indexPath.row];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.description;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ImageViewController *ivc = (ImageViewController *) segue.destinationViewController;
        Photo *photo = self.photos[indexPath.row];
        ivc.imageURL = photo.url;
        ivc.title = photo.title;
    }
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
