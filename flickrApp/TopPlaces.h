//
//  TopPlaces.h
//  flickrApp
//
//  Created by Paul on 4/8/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface TopPlaces : NSObject

@property (strong, nonatomic) NSMutableArray *placesDatabase;   //Array of NSArray of Place objects

- (Place *)getPlaceAtIndexPath:(NSIndexPath *)path;
- (void)downloadData;
- (NSInteger)numberOfSections;
- (NSInteger)numberOfRecordsInSection:(NSInteger)section;
- (NSString *)countryInSection:(NSInteger)section;

@end
