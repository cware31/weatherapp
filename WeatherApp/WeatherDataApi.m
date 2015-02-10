//
//  WeatherDataApi.m
//  WeatherApp
//
//  Created by Chris Ware on 2/9/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import "WeatherDataApi.h"

#define API_KEY @"e9836a9bf2cbfe3b"

@implementation WeatherDataApi

- (void)fetchWeatherData: (NSString *) location
{
    NSURLRequest *request = [self getUrlRequest:location];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if (error)
        {
            NSLog(@"Error,%@", [error localizedDescription]);
        }
        else
        {
            NSLog(@"using block for asyn call");
            NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
            _responseData = data;
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:_responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error:nil];
            [_delegate setCityWeatherInfo:JSON];

        }
    }];
    
}

-(NSURLRequest*)getUrlRequest: (NSString *)location {
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
    return request;
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
