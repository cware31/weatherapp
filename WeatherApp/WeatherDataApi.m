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
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:_responseData
                                                         options:NSJSONReadingAllowFragments
                                                           error:nil];
    [_delegate setCityWeatherInfo:JSON];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
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
