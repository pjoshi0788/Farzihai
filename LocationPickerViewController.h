//
//  LocationPickerViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/8/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <AddressBookUI/ABAddressFormatting.h>
@protocol senddataProtocol <NSObject>

@optional
-(void)sendDataToA:(NSString *)address forAddress:(BOOL) homeAddress;
-(void)sendDataToTransitNoticePage:(NSString *)address forAddress:(BOOL) TransitNoticePage;

@end
@interface LocationPickerViewController : UIViewController<GMSMapViewDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property(nonatomic,assign)id delegate;
- (IBAction)dismissView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property(nonatomic,assign)BOOL homeAddress;
@property(nonatomic,assign)BOOL TravelNoticeDestinationLocation;
@property (nonatomic, retain) NSString *addressString;
@end
