//
//  WeatherView.h
//  WeatherApp
//
//  Created by Chris Ware on 2/9/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView <UIGestureRecognizerDelegate>

#pragma mark Properties

//  Displays the time the weather data for this view was last updated
@property (strong, nonatomic, readonly) UILabel                 *updatedLabel;

//  Displays the icon for current conditions
@property (strong, nonatomic) UIImage                 *conditionIcon;

//  Displays the description of current conditions
@property (strong, nonatomic) UILabel                 *conditionDescriptionLabel;

//  Displays the location whose weather data is being represented by this weather view
@property (strong, nonatomic, readonly) UILabel                 *locationLabel;

//  Displayes the current temperature
@property (strong, nonatomic, readonly) UILabel                 *currentTemperatureLabel;

//  Displays both the high and low temperatures for today
@property (strong, nonatomic, readonly) UILabel                 *feelsLikeLabel;

//  Displays the day of the week for the first forecast snapshot
@property (strong, nonatomic, readonly) UILabel                 *forecastDayOneLabel;

//  Displays the day of the week for the second forecast snapshot
@property (strong, nonatomic, readonly) UILabel                 *forecastDayTwoLabel;

//  Displays the day of the week for the third forecast snapshot
@property (strong, nonatomic, readonly) UILabel                 *forecastDayThreeLabel;

//  Displays the icon representing the predicted conditions for the first forecast snapshot
@property (strong, nonatomic, readonly) UILabel                 *forecastIconOneLabel;

//  Displays the icon representing the predicted conditions for the second forecast snapshot
@property (strong, nonatomic, readonly) UILabel                 *forecastIconTwoLabel;

//  Displays the icon representing the predicted conditions for the third forecast snapshot
@property (strong, nonatomic, readonly) UILabel                 *forecastIconThreeLabel;

//  Indicates whether data is being downloaded for this weather view
@property (strong, nonatomic, readonly) UIActivityIndicatorView *activityIndicator;

@end
