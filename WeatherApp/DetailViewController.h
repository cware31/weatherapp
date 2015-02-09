//
//  DetailViewController.h
//  WeatherApp
//
//  Created by Chris Ware on 2/8/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherDataApi.h"


@interface DetailViewController : UIViewController <WeatherDataApiDelegate>
{
    WeatherDataApi *weatherDataApi;
}
@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

