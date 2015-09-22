//
//  LocationPickerViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/8/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "LocationPickerViewController.h"



@interface LocationPickerViewController ()

@end

@implementation LocationPickerViewController
@synthesize topView,mapView,delegate,homeAddress, addressString;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [topView setFrame:CGRectMake(0,0,375,55)];
    self.mapView.delegate=self;
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.pausesLocationUpdatesAutomatically=NO;
    [self getCurrentLocation];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
        if (_TravelNoticeDestinationLocation)
            [delegate sendDataToTransitNoticePage:addressString forAddress:_TravelNoticeDestinationLocation];
        else
        {
            if(addressString != nil)
              [delegate sendDataToA:addressString forAddress:homeAddress];
        }

}

-(void) getCurrentLocation
{
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    locationManager.delegate=self;
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissView:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations firstObject];
    self.mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:10 bearing:0 viewingAngle:0];
    self.mapView.myLocationEnabled=YES;
    self.mapView.settings.myLocationButton=YES;
    [locationManager stopUpdatingLocation];
    
}

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    [self.mapView clear];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            CLPlacemark *placemark = [placemarks lastObject];
            GMSMarker *marker = [[GMSMarker alloc] init];
            marker.map  = nil;
            NSArray *lines = placemark.addressDictionary[ @"FormattedAddressLines"];;
            if([lines count] >= 3)
              addressString=[NSString stringWithFormat:@"%@, %@, %@",[lines objectAtIndex:0], [lines objectAtIndex:1], [lines objectAtIndex:2]];
            else if([lines count] >= 2)
              addressString=[NSString stringWithFormat:@"%@, %@",[lines objectAtIndex:0], [lines objectAtIndex:1]];
            else
                addressString=[NSString stringWithFormat:@"%@",[lines objectAtIndex:0]];
            
            marker.position = coordinate;
            marker.title = addressString;
           // marker.snippet = @"Durham, NC";
            marker.icon = [GMSMarker markerImageWithColor:[UIColor greenColor]];
            marker.opacity = 0.9;
            marker.map = self.mapView;
            [self.mapView setSelectedMarker:marker];
        }
    }];

}
- (void)mapView:(GMSMapView *)mapView
didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
