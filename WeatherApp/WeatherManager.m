//
//  WeatherManager.m
//  WeatherApp
//
//  Created by Chris Ware on 2/14/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherManager.h"

@implementation WeatherManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static WeatherManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

@end