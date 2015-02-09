//
//  DetailViewController.m
//  WeatherApp
//
//  Created by Chris Ware on 2/8/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import "DetailViewController.h"
#import "WeatherData.h"
#import "WeatherDataApi.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, weak) NSObject *weatherData;
- (void)displayWeatherData;

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
    if (self.detailItem) {
        self.location = [self.detailItem description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    weatherDataApi = [[WeatherDataApi alloc] init];
    [weatherDataApi setDelegate:self];
    [weatherDataApi fetchWeatherData:self.location];
    [self configureUI];
    [self displayWeatherData];
}

- (void) configureUI {

}

- (void)displayWeatherData {
    
}



-(void)setCityWeatherInfo:weatherData {
    self.weatherData = weatherData;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
