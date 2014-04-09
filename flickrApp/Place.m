//
//  Place.m
//  flickrApp
//
//  Created by Paul on 4/8/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import "Place.h"
#import "FlickrFetcher.h"

@implementation Place

- (void)setFieldsFromFlickrPlaceInfo:(NSDictionary *)placeInfo
{

    NSString *regionName = [FlickrFetcher extractRegionNameFromPlaceInformation:placeInfo];   //Region
    NSString *countryName = [FlickrFetcher extractCountryNameFromPlaceInformation:placeInfo];  //Country
    self.region = regionName;
    self.country = countryName;
    
    //This name is still the full name.  Need to figure out how to strip out
    //Region and country data looks good.
    NSString *placeName = [FlickrFetcher extractNameOfPlace:self.placeId fromPlaceInformation:placeInfo];
    self.name = placeName;
    
}


@end
