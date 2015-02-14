//
//  MasterViewController.m
//  WeatherApp
//
//  Created by Chris Ware on 2/8/15.
//  Copyright (c) 2015 Chris Ware. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "WeatherManager.h"

@interface MasterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *zipCodeTextField;
@property NSMutableArray *zipCodeArray;
@property CLGeocoder *geoCoder;
-(void)preloadCities;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self preloadCities];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [self startStandardUpdates];
}

-(void)preloadCities {
    self.zipCodeArray = [NSMutableArray arrayWithObjects:@"Austin, TX 78759", @"Newport Beach, CA 92660", @"Boston, MA 02201" , nil];
}

- (void)startStandardUpdates
{
    NSLog(@"startStandardUpdates");
    // Create the location manager if this object does not
    // already have one.
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    
    if (nil == self.geoCoder)
        self.geoCoder = [[CLGeocoder alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 2500; // meters
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        NSLog(@"NSLocationAlwaysUsageDescription");
        [locationManager requestWhenInUseAuthorization];
    }
    [locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"delegate callback for location");
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        [self getZipCodeFromCurrentLocation:location];
        
    }
}

- (void) getZipCodeFromCurrentLocation:(CLLocation*)location {
    [self.geoCoder reverseGeocodeLocation: locationManager.location completionHandler: ^(NSArray *placemarks, NSError *error) {
        //        [self.locationManager stopUpdatingLocation];
        
        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        // Long address
        // NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
        // Short address
        NSString *locatedAt = [placemark postalCode];
        NSLog(@"%@", locatedAt);
        if (locatedAt != nil) {
            [self addZipCodeToList:locatedAt];
        }
    }];
}

- (void) addZipCodeToList:(NSString*)zipCode {
    [self.zipCodeArray insertObject:zipCode atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self performSegueWithIdentifier: @"showDetail" sender: self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.zipCodeArray) {
        self.zipCodeArray = [[NSMutableArray alloc] init];
    }
    [self.zipCodeArray insertObject:self.zipCodeTextField.text atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self performSegueWithIdentifier: @"showDetail" sender: self];
}

-(void) updateObjectWithCityState:(NSString*) cityState {
    //self.zipCodeArray
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *locString = self.zipCodeArray[indexPath.row];
        [[segue destinationViewController] setDetailItem:locString];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.zipCodeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *locString = self.zipCodeArray[indexPath.row];
    cell.textLabel.text = locString;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.zipCodeArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
