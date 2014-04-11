//
//  PhotosTableViewController.h
//  flickrApp
//
//  Created by Paul on 4/11/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosTableViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *photos; //of Photo objects
@property (strong, nonatomic) NSString *placeId;  //to load

@end
