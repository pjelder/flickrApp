//
//  Photo.h
//  flickrApp
//
//  Created by Paul on 4/11/14.
//  Copyright (c) 2014 Paul. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSURL *url;


@end
