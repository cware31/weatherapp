//
//  WeatherView.m
//  WeatherApp
//
//  Created by Chris Ware on 2/9/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#pragma mark - Imports

#import "WeatherView.h"


#pragma mark - Macros

#define LIGHT_FONT      @"HelveticaNeue-Light"
#define ULTRALIGHT_FONT @"HelveticaNeue-UltraLight"


#pragma mark - CZWeatherView Class Extension

@interface WeatherView ()


// Light-Colored ribbon to display temperatures and forecasts on
@property (strong, nonatomic) UIView                    *ribbon;

// Displays the time the weather data for this view was last updated
@property (strong, nonatomic) UILabel                   *updatedLabel;

// Displays the location whose weather data is being represented by this weather view
@property (strong, nonatomic) UILabel                   *locationLabel;

// Displayes the current temperature
@property (strong, nonatomic) UILabel                   *currentTemperatureLabel;

// Displays both the high and low temperatures for today
@property (strong, nonatomic) UILabel                   *feelsLikeLabel;

//  Displays the precipitation for today
@property (strong, nonatomic) UILabel                 *precipTodayLabel;

//  Displays the wind for today
@property (strong, nonatomic) UILabel                 *windLabel;

// Displays the day of the week for the first forecast snapshot
@property (strong, nonatomic) UILabel                   *forecastDayOneLabel;

// Displays the day of the week for the second forecast snapshot
@property (strong, nonatomic) UILabel                   *forecastDayTwoLabel;

// Displays the day of the week for the third forecast snapshot
@property (strong, nonatomic) UILabel                   *forecastDayThreeLabel;

// Displays the icon representing the predicted conditions for the first forecast snapshot
@property (strong, nonatomic) UILabel                   *forecastIconOneLabel;

// Displays the icon representing the predicted conditions for the second forecast snapshot
@property (strong, nonatomic) UILabel                   *forecastIconTwoLabel;

// Displays the icon representing the predicted conditions for the third forecast snapshot
@property (strong, nonatomic) UILabel                   *forecastIconThreeLabel;

// Indicates whether data is being downloaded for this weather view
@property (strong, nonatomic) UIActivityIndicatorView   *activityIndicator;

@end


#pragma mark - SOLWeatherView Implementation

@implementation WeatherView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]) {
        
        //  Initialize Container
        self.container = [[UIView alloc]initWithFrame:self.bounds];
        [self.container setBackgroundColor:[UIColor colorWithRed:20.0/255 green:59.0/255 blue:102.0/255 alpha:1.0]];
        [self addSubview:self.container];
        
        //  Initialize Ribbon
        self.ribbon = [[UIView alloc]initWithFrame:CGRectMake(0, 1.30 * self.center.y, self.bounds.size.width, 80)];
        [self.ribbon setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.25]];
        [self.container addSubview:self.ribbon];
        
        //  Initialize Activity Indicator
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.center = self.center;
        [self.container addSubview:self.activityIndicator];
        
        //  Initialize Labels
        [self initializeUpdatedLabel];
        [self initializeConditionDescriptionLabel];
        [self initializeLocationLabel];
        [self initializeCurrentTemperatureLabel];
        [self initializeFeelsLike];
        [self initPrecipToday];
        [self initWind];
    }
    return self;
}

#pragma mark Label Initialization Methods

- (void)initializeUpdatedLabel
{
    static const NSInteger fontSize = 16;
    self.updatedLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - (1.5 * fontSize), CGRectGetWidth(self.bounds), 1.5 * fontSize)];
    [self.updatedLabel setNumberOfLines:0];
    [self.updatedLabel setAdjustsFontSizeToFitWidth:YES];
    [self.updatedLabel setFont:[UIFont fontWithName:LIGHT_FONT size:fontSize]];
    [self.updatedLabel setTextColor:[UIColor whiteColor]];
    [self.updatedLabel setTextAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.updatedLabel];
}


- (void)initializeConditionDescriptionLabel
{
    const NSInteger fontSize = 48;
    self.conditionDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0.75 * CGRectGetWidth(self.bounds), 1.5 * fontSize)];
    [self.conditionDescriptionLabel setNumberOfLines:0];
    [self.conditionDescriptionLabel setAdjustsFontSizeToFitWidth:YES];
    [self.conditionDescriptionLabel setCenter:CGPointMake(self.container.center.x, self.center.y)];
    [self.conditionDescriptionLabel setFont:[UIFont fontWithName:ULTRALIGHT_FONT size:fontSize]];
    [self.conditionDescriptionLabel setBackgroundColor:[UIColor clearColor]];
    [self.conditionDescriptionLabel setTextColor:[UIColor whiteColor]];
    [self.conditionDescriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.conditionDescriptionLabel];
}

- (void)initializeLocationLabel
{
    const NSInteger fontSize = 18;
    self.locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.5 * fontSize)];
    [self.locationLabel setAdjustsFontSizeToFitWidth:YES];
    [self.locationLabel setCenter:CGPointMake(self.container.center.x, 1.18 * self.center.y)];
    [self.locationLabel setFont:[UIFont fontWithName:LIGHT_FONT size:fontSize]];
    [self.locationLabel setBackgroundColor:[UIColor clearColor]];
    [self.locationLabel setTextColor:[UIColor whiteColor]];
    [self.locationLabel setTextAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.locationLabel];
}

- (void)initializeCurrentTemperatureLabel
{
    const NSInteger fontSize = 52;
    self.currentTemperatureLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 1.305 * self.center.y, 0.4 * CGRectGetWidth(self.bounds), fontSize)];
    [self.currentTemperatureLabel setFont:[UIFont fontWithName:ULTRALIGHT_FONT size:fontSize]];
    [self.currentTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    [self.currentTemperatureLabel setTextColor:[UIColor whiteColor]];
    [self.currentTemperatureLabel setTextAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.currentTemperatureLabel];
}

- (void)initializeFeelsLike
{
    const NSInteger fontSize = 18;
    self.feelsLikeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.5 * fontSize)];
    [self.feelsLikeLabel setFrame:CGRectMake(0, 0, 0.375 * CGRectGetWidth(self.bounds), fontSize)];
    [self.feelsLikeLabel setCenter:CGPointMake(self.currentTemperatureLabel.center.x - 4,
                                                     self.currentTemperatureLabel.center.y + 0.5 * self.currentTemperatureLabel.bounds.size.height + 12)];
    [self.feelsLikeLabel setFont:[UIFont fontWithName:LIGHT_FONT size:fontSize]];
    [self.feelsLikeLabel setBackgroundColor:[UIColor clearColor]];
    [self.feelsLikeLabel setTextColor:[UIColor whiteColor]];
    [self.feelsLikeLabel setTextAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.feelsLikeLabel];
}

-(void)initPrecipToday
{
    const NSInteger fontSize = 18;
    self.precipTodayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.5 * fontSize)];
    [self.precipTodayLabel setFrame:CGRectMake(0, 0, 0.375 * CGRectGetWidth(self.bounds), fontSize)];
    [self.precipTodayLabel setCenter:CGPointMake(self.currentTemperatureLabel.center.x +25,
                                               self.currentTemperatureLabel.center.y * self.currentTemperatureLabel.bounds.size.height + 12)];
    [self.precipTodayLabel setFont:[UIFont fontWithName:LIGHT_FONT size:fontSize]];
    [self.precipTodayLabel setBackgroundColor:[UIColor clearColor]];
    [self.precipTodayLabel setTextColor:[UIColor whiteColor]];
    [self.precipTodayLabel setTextAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.precipTodayLabel];
}

-(void)initWind
{
    const NSInteger fontSize = 18;
    self.windLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 1.5 * fontSize)];
    [self.windLabel setFrame:CGRectMake(0, 0, 0.375 * CGRectGetWidth(self.bounds), fontSize)];
    [self.windLabel setCenter:CGPointMake(self.precipTodayLabel.center.x + 25,
                                               self.precipTodayLabel.center.y * self.precipTodayLabel.bounds.size.height + 12)];
    [self.windLabel setFont:[UIFont fontWithName:LIGHT_FONT size:fontSize]];
    [self.windLabel setBackgroundColor:[UIColor clearColor]];
    [self.windLabel setTextColor:[UIColor whiteColor]];
    [self.windLabel setTextAlignment:NSTextAlignmentCenter];
    [self.container addSubview:self.windLabel];
}

- (void)initializeConditionIcon:(UIImage*)image
{
    self.conditionImageView.center = self.center;
    [self addSubview:self.conditionImageView];
}

@end