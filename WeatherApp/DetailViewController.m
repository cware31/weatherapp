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
#import "WeatherView.h"

@interface DetailViewController ()

// YES if the view has appeared
@property (nonatomic) BOOL hasAppeared;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, weak) WeatherDetails *weatherData;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (nonatomic) WeatherView *weatherView;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.439 green:0.868 blue:0.999 alpha:1.000];
    self.weatherView = [[WeatherView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.weatherView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!self.hasAppeared) {
        //[self updateWeather];
        self.hasAppeared = YES;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)setCityWeatherInfo:weatherData {
    NSLog(@"setCityWeatherInfo: %@", weatherData);
    self.weatherData = weatherData;
    [self updateWeather];
}

- (void)updateWeather
{
    [self.weatherView.activityIndicator startAnimating];
    NSDictionary *currentObservation = self.weatherData[@"current_observation"];
    NSDictionary *displayLocation = currentObservation[@"display_location"];
    // City,State
    self.weatherView.locationLabel.text = displayLocation[@"full"];
    
    // Temperature
    self.weatherView.currentTemperatureLabel.text = [NSString stringWithFormat:@"%.0f°",
                                                     [currentObservation[@"temp_f"] doubleValue]];
    // Conditions
    self.weatherView.conditionDescriptionLabel.text = [currentObservation[@"weather"] capitalizedString];
    NSString *feelsLike = [NSString stringWithFormat:@"%@%.0f°",@"Feels like ",
                           [currentObservation[@"feelslike_f"] doubleValue]];
    self.weatherView.feelsLikeLabel.text = feelsLike;
    // TODO: fix icon
    NSURL *imageURL = [NSURL URLWithString:currentObservation[@"icon_url"]];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    self.weatherView.conditionIcon = image;
    
    // Last time updated
    NSString *updated = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                       dateStyle:NSDateFormatterMediumStyle
                                                       timeStyle:NSDateFormatterShortStyle];
    self.weatherView.updatedLabel.text = [NSString stringWithFormat:@"Updated %@", updated];
    [self.weatherView.activityIndicator stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
