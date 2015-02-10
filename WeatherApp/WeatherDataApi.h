//
//  WeatherDataApi.h
//  WeatherApp
//
//  Created by Chris Ware on 2/9/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherDetails.h"

@protocol WeatherDataApiDelegate <NSObject>

- (void) setCityWeatherInfo:(NSDictionary *) weatherData;

@end

@interface WeatherDataApi : NSObject <NSURLConnectionDelegate>
{
    NSData *_responseData;
}

- (void)fetchWeatherData:(NSString *) location;
@property (nonatomic, unsafe_unretained) id <WeatherDataApiDelegate> delegate;

@end
