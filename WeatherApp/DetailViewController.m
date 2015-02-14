//
//  DetailViewController.m
//  WeatherApp
//
//  Created by Chris Ware on 2/8/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import "DetailViewController.h"
#import "WeatherDataApi.h"
#import "WeatherDetails.h"
#import <UIKit/UIKit.h>
#import "WeatherManager.h"

@interface DetailViewController ()

@property (nonatomic, strong) NSString *location;
@property (strong, nonatomic) IBOutlet UIView *weatherView;
@property (nonatomic, weak) WeatherDetails *weatherData;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *feelsLikeLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *windDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *precipLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.location = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weatherDataApi = [[WeatherDataApi alloc] init];
    [weatherDataApi setDelegate:self];
    [weatherDataApi fetchWeatherData:self.location];
    
//    self.view.backgroundColor = [UIColor colorWithRed:0.439 green:0.868 blue:0.999 alpha:1.000];
//    self = [[WeatherView alloc]initWithFrame:self.view.bounds];
//    [self.view addSubview:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)setCityWeatherInfo:weatherData {
    NSLog(@"setCityWeatherInfo: %@", weatherData);
    self.weatherData = weatherData;
    [self loadWeatherDataIntoUI];
}

- (void)loadWeatherDataIntoUI
{
    NSDictionary *currentObservation = self.weatherData[@"current_observation"];
    NSDictionary *displayLocation = currentObservation[@"display_location"];
    // City,State
    self.locationLabel.text = displayLocation[@"full"];
    
    // Temperature
    self.currentTemperatureLabel.text = [NSString stringWithFormat:@"%@%.0f°", @"Temp: ",
                                                     [currentObservation[@"temp_f"] doubleValue]];
    // Conditions
    self.conditionsLabel.text = [currentObservation[@"weather"] capitalizedString];
    NSString *feelsLike = [NSString stringWithFormat:@"%@%.0f°",@"Feels like ",
                           [currentObservation[@"feelslike_f"] doubleValue]];
    self.feelsLikeLabel.text = feelsLike;
    
    //wind
    self.windLabel.text = [NSString stringWithFormat:@"%@%.0f %@", @"Wind: ",
                           [currentObservation[@"wind_mph"] doubleValue], @"mph"];
    
    //precipitation
    self.precipLabel.text = [NSString stringWithFormat:@"%@%@ in.", @"Precip: ",
                                              currentObservation[@"precip_today_in"]];
    
    //wind direction
    self.windDirectionLabel.text = [NSString stringWithFormat:@"%@%@", @"Wind From ",
                                        currentObservation[@"wind_dir"]];
    
    //humidity
    self.humidityLabel.text = [NSString stringWithFormat:@"%@%@", @"Humidity: ",
                           currentObservation[@"relative_humidity"]];
    
    
    //set image
    NSString *imageUrlString = [NSString stringWithFormat:@"http://icons.wxug.com/i/c/a/%@.gif", currentObservation[@"icon"]];
    NSURL *imageURL = [NSURL URLWithString:imageUrlString];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.iconImageView.image = image;
    
    // Last time updated
    NSString *updated = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                       dateStyle:NSDateFormatterMediumStyle
                                                       timeStyle:NSDateFormatterShortStyle];
    self.lastUpdatedLabel.text = [NSString stringWithFormat:@"Updated %@", updated];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
