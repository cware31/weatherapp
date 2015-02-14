//
//  WeatherManager.h
//  WeatherApp
//
//  Created by Chris Ware on 2/14/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#ifndef WeatherApp_WeatherManager_h
#define WeatherApp_WeatherManager_h

#import <Foundation/Foundation.h>
#import "WeatherDetails.h"

@interface WeatherManager : NSObject {
    WeatherDetails *weatherDetails;
}

+(id) sharedManager;

@end

#endif
