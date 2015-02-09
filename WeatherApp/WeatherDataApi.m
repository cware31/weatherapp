//
//  WeatherDataApi.m
//  WeatherApp
//
//  Created by Chris Ware on 2/9/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import "WeatherDataApi.h"
#import "WeatherData.h"

#define API_KEY @"e9836a9bf2cbfe3b"

@implementation WeatherDataApi

- (void)fetchWeatherData: (NSString *) location
{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[WeatherData class]];
    [mapping addAttributeMappingsFromArray:@[@"current_observation"]];
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    BOOL isZipCode = [self isLocationZipCode:location];
    
    NSString *url;
    if (isZipCode) {
        url = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@.json", API_KEY, location];
    } else {
        NSArray *strings = [location componentsSeparatedByString:@","];
        NSString* state = [strings[1] stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSString* city = [strings[0] stringByReplacingOccurrencesOfString:@" " withString:@"_"];
        url = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@/%@.json", API_KEY, state, city];
    }
    
    NSString* escapedUrlString =
    [url stringByAddingPercentEscapesUsingEncoding:
     NSUTF8StringEncoding];
    NSLog(@"%@", escapedUrlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:escapedUrlString]];
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result) {
        NSLog(@"%@, %@", @"Results: ", result);
        WeatherData *weatherData = [result firstObject];
        NSLog(@"Mapped the weather data: %@", weatherData.current_observation);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"Failed with error: %@", [error localizedDescription]);
    }];
    
    [operation start];
}

-(BOOL) isLocationZipCode:(NSString *) location {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    NSNumber *number = [formatter numberFromString:location];
    if (number) {
        return YES;
    } else {
        return NO;
    }
}

@end
