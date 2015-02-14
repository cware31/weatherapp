//
//  MasterViewController.h
//  WeatherApp
//
//  Created by Chris Ware on 2/8/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MasterViewController : UITableViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}


@end

