//
//  Place.h
//  flickrApp
//
//  Created by Paul on 4/8/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Place : NSObject

@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *placeId;
@property (strong, nonatomic) NSString *name;

- (void)setFieldsFromFlickrPlaceInfo:(NSDictionary *)placeInfo;

@end
