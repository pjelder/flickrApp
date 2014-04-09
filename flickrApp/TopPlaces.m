//
//  TopPlaces.m
//  flickrApp
//
//  Created by Paul on 4/8/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import "TopPlaces.h"
#import "FlickrFetcher.h"

@interface TopPlaces ()
@property (strong, nonatomic) NSArray *places;
@property (strong, nonatomic) NSMutableDictionary *placeInfoLookup;
@property (strong, nonatomic) NSMutableDictionary *countries;  //Key of country, value is index of country in placeDatabase
@end

@implementation TopPlaces

- (NSMutableDictionary *)countries
{
    if (!_countries) _countries = [[NSMutableDictionary alloc] init];
    return _countries;
}

- (NSMutableArray *)placesDatabase
{
    if (!_placesDatabase) _placesDatabase = [[NSMutableArray alloc] init];
    return _placesDatabase;
}

- (NSMutableDictionary *)placeInfoLookup
{
    if (!_placeInfoLookup) _placeInfoLookup = [[NSMutableDictionary alloc] init];
    return _placeInfoLookup;
}


- (Place *)getPlaceAtIndexPath:(NSIndexPath *)path
{
    return self.placesDatabase[path.section][path.row];
}

- (NSInteger)numberOfSections
{
    return [self.placesDatabase count];
}

- (NSInteger)numberOfRecordsInSection:(NSInteger)section
{
    return [self.placesDatabase[section] count];
}

- (NSString *)countryInSection:(NSInteger)section
{
    Place *place = self.placesDatabase[section][0];
    return place.country;
}

- (void)downloadData
{
    NSData *flickrData = [NSData dataWithContentsOfURL:[FlickrFetcher URLforTopPlaces]];
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:flickrData
                                                   options:0 error:NULL];
    self.places = [results valueForKeyPath:FLICKR_RESULTS_PLACES];
    
    for (NSDictionary *place in self.places) {
        NSString *placeId = place[FLICKR_PLACE_ID];
        
        NSData *placeData = [NSData dataWithContentsOfURL:[FlickrFetcher URLforInformationAboutPlace:placeId]];
        NSDictionary *placeInfo = [NSJSONSerialization JSONObjectWithData:placeData
                                                                  options:0 error:NULL];
        [self.placeInfoLookup setValue:placeInfo forKey:placeId];
    }
    NSLog(@"%@", results.description);
    [self buildDatabase];
}

- (void)buildDatabase
{
    for (NSDictionary *place in self.places) {
        NSString *placeId = place[FLICKR_PLACE_ID];
        NSDictionary *placeInfo = [self.placeInfoLookup valueForKey:placeId];
        
        Place *newPlace = [[Place alloc] init];
        newPlace.placeId = placeId;  //Need to set this before calling that
        [newPlace setFieldsFromFlickrPlaceInfo:placeInfo];

        
        //NSString *placeName = [FlickrFetcher extractNameOfPlace:(id)placeId fromPlaceInformation:placeInfo];  //Full name
        
        NSNumber *databaseSectionIndex = [self.countries valueForKey:newPlace.country];
        if (!databaseSectionIndex) {
            databaseSectionIndex = [[NSNumber alloc] initWithUnsignedInt:[self.placesDatabase count]];
            [self.countries setValue:databaseSectionIndex forKey:newPlace.country];
            [self.placesDatabase addObject:[[NSMutableArray alloc] init]];
        }
        
        NSMutableArray *placesInCountry = self.placesDatabase[[databaseSectionIndex integerValue]];
        [placesInCountry addObject:newPlace];
    }
    NSLog(@"Built database.");
}

@end
