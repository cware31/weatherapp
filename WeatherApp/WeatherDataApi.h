//
//  WeatherDataApi.h
//  WeatherApp
//
//  Created by Chris Ware on 2/9/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherData.h"
#import <RestKit/RestKit.h>

@protocol WeatherDataApiDelegate <NSObject>

- (void) setCityWeatherInfo:(WeatherData *) weatherData;

@end

@interface WeatherDataApi : NSObject

- (void)fetchWeatherData:(NSString *) location;
@property (nonatomic, unsafe_unretained) id <WeatherDataApiDelegate> delegate;
@end
