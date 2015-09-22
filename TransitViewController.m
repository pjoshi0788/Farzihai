
//
//  TransitViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/5/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "TransitViewController.h"
#import "AppDelegate.h"
#import "constant.h"
#import "JsonParsing.h"
#import <EventKit/EventKit.h>
#import "NearByTableViewCell.h"
#import "TransitTableViewCell.h"
#import "Route.h"
#import "Steps.h"
#import "StepTableViewCell.h"
#import "TravelNoticeViewController.h"
#import "ParkingViewController.h"
#import "RentCarViewController.h"
#import "FBCheckinController.h"
#import "QkrViewController.h"
#import "Reachability.h"
#import "PricelessCitiesViewController.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#define TRAIN_TRANSIT 10
#define CAR_TRANSIT 11
#define  WALK_TRANSIT 12
#define CYCLE_TRANSIT 13
#define UBER_CAB 24
#define NO_NETWORK_ALERT 36
@interface TransitViewController ()
{
    GMSMarker *markerAnim;
    NSArray *markerLocation;
    NSDictionary *jsonDiction;
    double searchLatitude ,searchLongtitude,addressMap;
    NSMutableDictionary *addressDictionary,*dataHold;
    NSString *addValue,*latvalue,*longvalue,*locName;
    NSMutableArray *textsteps,*Transittextsteps,*durationSteps;
    UITableView *tableViewOrderAndPay ;
    UITableView *customTbaleView;
    UITableView *defaultTableTransit;
    
    UILabel *lblATMName,*lblAddressLine1,*lblAddressLine2,*lblATMCity,*lblATMZipCode,*lblDistanceMilesNumber,*lblDistanceMilesText, *lblDistanceMiles,*lblRestName;
    
    UILabel *lblFrom,*lblMiles,*lblNearest,*lblRentACar;
    UIImageView *animatedParkImg;
    
    NSMutableArray *routeArray ;
    NSMutableArray *arrOAPAddressVicinity;
    NSMutableArray *arrOAPName,*arrstrGeo,*arrStrLocation;
    int stepTblRows;
    
    UIView *UberView;
    UITableView *UberTableView;
    NSArray *UberMinutes;
    NSString *short_Name;
    
    NSString *isHelpCenterViewPresented;
    NSMutableArray *arrParking;
    
    UIImage *capturedScreen;
    UISwipeGestureRecognizer *recognizerUp ;
    UISwipeGestureRecognizer *recognizerDown;
    
    BOOL btnOrderAndPayisTapped;
    
    BOOL travelNoticeAutomatic;
    BOOL faceBookAutomatic;
    BOOL bookCabAutomatic;
    BOOL clientMeetAutomatic;
    BOOL orderBreakFastAutomatic;
    BOOL fooFighterAutomatic;
    
    BOOL pageLoaded;
    
    NSTimer *timer;
}

@property(strong,nonatomic) GMSPolyline *polyline;
@property (strong, nonatomic) JsonParsing *parseClass;
@property (strong, nonatomic) NSDictionary *storeData,*storeDataATM,*storeDataOAP,*storeDemoData,*storeParkingData;
@property (weak, nonatomic) IBOutlet UIView *transitBtnHighlightView;
@property (weak, nonatomic) IBOutlet UIView *nearbyHighlightView;
@property (weak, nonatomic) IBOutlet UIView *orderPayHighlightView;
@property (weak, nonatomic) IBOutlet UIView *modeOfTransportView;

- (IBAction)showRouteBtnClicked:(id)sender;
@end

@implementation TransitViewController
@synthesize sideBarViewController,mapView,lblNearBy,lblRedBorderTransit,lblOrderAndPay,storeData,storeDataATM,storeDataOAP,storeDemoData,storeParkingData;
@synthesize strDest,strOrigin,transitTbl,lblTransitModeBar;
@synthesize  arrline1,arrline2,arrCity,arrZipCode,userinfo_dic;
@synthesize  arrFinalLine1,arrFinalLine2,arrFinalCity,arrFinalZipCode,arrFinalATMName,arrFinalMilesNumber,addressString;
@synthesize data,btnHelpCenterRef,viewHelpCenter;

@synthesize btnNearByRef,btnOAPRef,btnTransitRef;


- (void)viewDidLoad {
    viewHelpCenter.hidden = TRUE;
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate NetworkStatus];
    
    appDelegate.window.rootViewController = self;
    
    if(appDelegate.nwStatus ==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        alert.tag = NO_NETWORK_ALERT;
        [alert show];
    }
    else
    {
        [super viewDidLoad];
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        
        //        [self ishelpCenterView];
        
        self.orderPayHighlightView.hidden=YES;
        self.transitBtnHighlightView.hidden=YES;
        self.nearbyHighlightView.hidden=YES;
        
        data=[[NSMutableDictionary alloc]init];
        
        self.btnCarTransitref.tag=CAR_TRANSIT;
        self.btnTrainTransitRef.tag=TRAIN_TRANSIT;
        self.btnBicycleTransitRef.tag=CYCLE_TRANSIT;
        self.btnWalkTransitRef.tag=WALK_TRANSIT;
        
        // Do any additional setup after loading the view.
        
        
        // self.scrollViewTransit.frame = CGRectMake(0, 51, 414, 232);
        
        self.scrollViewTransit.contentSize = CGSizeMake(1125,600);
        self.scrollViewTransit.pagingEnabled = YES;
        self.scrollViewTransit.delegate=self;
        //***** order and pay **** //
        
        CGFloat xOAP =760;
        CGFloat yOAP = 0;
        CGFloat widthOAP = self.view.frame.size.width;
        CGFloat heightOAP = self.view.frame.size.height - 40;
        
        NSLog(@"HEIGHT_OAP %f",heightOAP);
        CGRect tableFrameOAP = CGRectMake(xOAP, yOAP, widthOAP, heightOAP-450);
        
        
        tableViewOrderAndPay=[[UITableView alloc]initWithFrame:tableFrameOAP style:UITableViewStylePlain];
        tableViewOrderAndPay.rowHeight = 80;
        tableViewOrderAndPay.sectionFooterHeight = 22;
        tableViewOrderAndPay.sectionHeaderHeight = 22;
        //    customTbaleView.scrollEnabled = YES;
        tableViewOrderAndPay.showsVerticalScrollIndicator = YES;
        tableViewOrderAndPay.userInteractionEnabled = YES;
        //    customTbaleView.bounces = YES;
        tableViewOrderAndPay.backgroundColor=[UIColor blackColor];
        
        tableViewOrderAndPay.delegate = self;
        tableViewOrderAndPay.dataSource = self;
        
        //***************** DTT*****************//
        
        CGFloat xDTT =0;
        CGFloat yDTT = 0;
        CGFloat widthDTT = 375;
        CGFloat heightDTT = 160;
        
        NSLog(@"HEIGHT_OAP %f",heightOAP);
        CGRect tableFrameDTT = CGRectMake(xDTT, yDTT, widthDTT, heightDTT);
        
        
        defaultTableTransit=[[UITableView alloc]initWithFrame:tableFrameDTT style:UITableViewStylePlain];
        defaultTableTransit.rowHeight = 63;
        defaultTableTransit.sectionFooterHeight = 22;
        defaultTableTransit.sectionHeaderHeight = 22;
        //    customTbaleView.scrollEnabled = YES;
        defaultTableTransit.showsVerticalScrollIndicator = YES;
        defaultTableTransit.userInteractionEnabled = YES;
        //    customTbaleView.bounces = YES;
        defaultTableTransit.backgroundColor=[UIColor whiteColor];
        
        defaultTableTransit.delegate = self;
        defaultTableTransit.dataSource = self;
        
        
    
        _sliderView.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        //**********************DTT**************//
        
        
        UberMinutes = [[NSArray alloc] initWithObjects:@"3 min",@"5 min",@"2 min", nil];
        
        
        
        if([appDelegate.origin1 isEqualToString:@""])
        {
            appDelegate.currLat=0;
            appDelegate.currLong=0;
        }
        //**** custom table ****//
        CGFloat x =380;
        CGFloat y = 0;
        CGFloat width = self.view.frame.size.width;
        CGFloat height = 160;
        CGRect tableFrame = CGRectMake(x, y, width, height);
        
        
        
        customTbaleView= [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
        customTbaleView.rowHeight = 60;
        customTbaleView.sectionFooterHeight = 22;
        customTbaleView.sectionHeaderHeight = 22;
        //    customTbaleView.scrollEnabled = YES;
        customTbaleView.showsVerticalScrollIndicator = YES;
        customTbaleView.userInteractionEnabled = YES;
        //    customTbaleView.bounces = YES;
        customTbaleView.backgroundColor=[UIColor blackColor];
        
        customTbaleView.delegate = self;
        customTbaleView.dataSource = self;
        //********** custom table *********//
        
        
        
        [self.tableViewNearBy registerClass:[UITableViewCell class] forCellReuseIdentifier:@"newFriendCell"];
        [self.view addSubview:self.tableViewNearBy];
        
        arrDataTransit=[[NSMutableArray alloc]init];
        arrDataTransitDuration=[[NSMutableArray alloc]init];
        
        self.navigationItem.revealSidebarDelegate=self;
        
        self.mapView.delegate=self;
        
        self.transitTbl.delegate=self;
        self.transitTbl.dataSource=self;
        self.defaultTableTransit.delegate=self;
        self.defaultTableTransit.dataSource=self;
        
        storeData=[[NSDictionary alloc]init];
        self.parseClass = [[JsonParsing alloc]init];
        
        // [self tblCustomTable];
        self.mapView.delegate =self;
        locationManager = [[CLLocationManager alloc]init];
        locationManager.delegate = self;
        if (IS_OS_8_OR_LATER) {
            NSUInteger code = [CLLocationManager authorizationStatus];
            if (code == kCLAuthorizationStatusNotDetermined && [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                    [locationManager  requestWhenInUseAuthorization];
                } else {
                    NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
                }
            }
        }
        activity.center = CGPointMake(self.view.center.x, self.view.center.y-50);
        [activity setColor:[UIColor blueColor]];
        [self.view addSubview:activity];
        [activity startAnimating];
        
        if(appDelegate.destination1 == nil)
            [locationManager startUpdatingLocation];
        locationManager.pausesLocationUpdatesAutomatically=NO;
        
        
        
        atmArray = [[NSMutableArray alloc] init];
        restoArray = [[NSMutableArray alloc] init];
        parkingArray=[[NSMutableArray alloc]init];
        selectedPolyline = [[GMSPolyline alloc] init];
        
        
        
        //    self.storeParkingData=[self.parseClass jsonParsingOfParkingData];
        //    [self arrayOfParking];
        //    [self plotParkingMarkers];
        //    [self defaultMarkerParking];
        
        
        
        lblTransitModeBar.hidden=YES;
        // appDelegate.transitMode = kTrainTransit;
        appDelegate.rootViewSet = FALSE;
        
        if(!appDelegate.origin1 && !appDelegate.destination1)
        {
            self.btnTrainTransitRef.enabled=NO;
            self.btnCarTransitref.enabled=NO;
            self.btnBicycleTransitRef.enabled=NO;
            self.btnWalkTransitRef.enabled=NO;
        }
        self.txtFieldOrigin.delegate=self;
        
        if(!appDelegate.origin1)
        self.txtFieldOrigin.text=@"Current Location";
        self.txtFieldDestination.delegate=self;
        [self.view addSubview:self.txtFieldDestination];
        [self.view addSubview:self.txtFieldOrigin];
        
        
        tableViewOrigin = [[UITableView alloc]initWithFrame:CGRectMake(22, 84, 330, 250)];
        tableViewOrigin.backgroundColor=[UIColor clearColor ];
        tableViewOrigin.delegate = self;
        tableViewOrigin.dataSource = self;
        tableViewOrigin.hidden = YES;
        [self.view addSubview:tableViewOrigin];
        
        tableViewDest = [[UITableView alloc]initWithFrame:CGRectMake(22, 124, 330, 250)];
        tableViewDest.backgroundColor=[UIColor clearColor];
        tableViewDest.delegate = self;
        tableViewDest.dataSource = self;
        tableViewDest.hidden = YES;
        [self.view addSubview:tableViewDest];
        
        
        routeArray = [[NSMutableArray alloc] init];
        
        stepTableView = [[UITableView alloc] init];
        
        [stepTableView registerNib:[UINib nibWithNibName:@"StepTableViewCell" bundle:nil ] forCellReuseIdentifier:@"stepCellId"];
        /*
         UILocalNotification *localNotif = [[UILocalNotification alloc] init];
         if (localNotif == nil)
         return;
         localNotif.fireDate = [[NSDate date] dateByAddingTimeInterval:60];
         localNotif.timeZone = [NSTimeZone defaultTimeZone];
         
         localNotif.alertBody = @"Mastercard";
         
         localNotif.alertAction = @"View Details";
         //localNotif.alertTitle = @"Test Title";
         localNotif.soundName = UILocalNotificationDefaultSoundName;
         localNotif.applicationIconBadgeNumber = 1;
         [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
         */
        
        recognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideViewUp:)];
        recognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self.sliderView addGestureRecognizer:recognizerUp];
        
        
        recognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(slideViewDown:)];
        recognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
        [self.sliderView addGestureRecognizer:recognizerDown];
        
        
        if(appDelegate.destination1 != nil)
            
            [activity stopAnimating];
        
        
        self.mapView.myLocationEnabled=YES;
        self.mapView.settings.myLocationButton=YES;
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:appDelegate.currLat
                                                                longitude:appDelegate.currLong
                                                                     zoom:16];
        
        self.mapView.camera=camera;
        
        [self arrayOfParking];
        [defaultTableTransit reloadData];
        [self plotParkingMarkers];
        [self defaultMarkerParking];
        [self DTT];
        
        
        
        
        // [self.view addSubview: viewHelpCenter];
        
        
        
        NSDictionary *UserInfo = [appDelegate UserinfoplistContent:YES];
        NSString *isHelpCenterViewPresentedCheck = [UserInfo objectForKey:@"isHelpCenterViewPresented"];
        if([isHelpCenterViewPresentedCheck isEqualToString:@"NO"] || isHelpCenterViewPresentedCheck == NULL) {
            viewHelpCenter.hidden = FALSE;
            [self.view addSubview:viewHelpCenter];
            [self savingHelpCenterInPlist];
        }
    }
    
    btnOrderAndPayisTapped = NO;
    
    pageLoaded = FALSE;
    
    isSlideViewUp = FALSE;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    transitMenuView = nil;
}

-(void)savingHelpCenterInPlist
{
    isHelpCenterViewPresented=@"YES";
    [data setObject:isHelpCenterViewPresented forKey:@"isHelpCenterViewPresented"];
}

-(void)arrayOfParking
{
    self.storeParkingData=[self.parseClass jsonParsingOfParkingData];
    arrParking=[[NSMutableArray alloc]init];
    arrParking=[storeParkingData valueForKey:@"results"];
    
    
    for(int i=0; i<[arrParking count]; i++)
    {
        
        Parking *parkingObj=[[Parking alloc]init];
        parkingObj.parkingName=[[arrParking objectAtIndex:i] valueForKey:@"name"];
        parkingObj.parkingAddress=[[arrParking objectAtIndex:i] valueForKey:@"vicinity"];
        
        parkingObj.parkingLat=[[[[arrParking objectAtIndex:i]valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lat"];
        parkingObj.parkingLong=[[[[arrParking objectAtIndex:i]valueForKey:@"geometry"]valueForKey:@"location"]valueForKey:@"lng"];
        
        [parkingArray addObject:parkingObj];
    }
}

-(void)arrayOfATM
{
    NSDictionary *atms=storeDataATM[@"Atms"];
    NSMutableArray *atm=atms[@"Atm"];
    
    for (int i=0;i<[atm count];i++) {
        
        Atm *atmObj = [[Atm alloc] init];
        
        atmObj.name = [[[[[atm objectAtIndex:i] valueForKey:@"Location"] objectAtIndex:0] valueForKey:@"Name"] objectAtIndex:0];
        atmObj.addressLine1 = [[[[[[[atm objectAtIndex:i] valueForKey:@"Location"] objectAtIndex:0] valueForKey:@"Address"] objectAtIndex:0] valueForKey:@"Line1"] objectAtIndex:0];
        atmObj.addressLine2 = [[[[[[[atm objectAtIndex:i] valueForKey:@"Location"] objectAtIndex:0]valueForKey:@"Address"] objectAtIndex:0] valueForKey:@"Line2"] objectAtIndex:0];
        atmObj.city = [[[[[[[atm objectAtIndex:i] valueForKey:@"Location"] objectAtIndex:0] valueForKey:@"Address"] objectAtIndex:0] valueForKey:@"City"] objectAtIndex:0];
        atmObj.postalCode = [[[[[[[atm objectAtIndex:i] valueForKey:@"Location"] objectAtIndex:0] valueForKey:@"Address"] objectAtIndex:0] valueForKey:@"PostalCode"] objectAtIndex:0];
        atmObj.distance = [[[[[atm objectAtIndex:i ] valueForKey:@"Location"] objectAtIndex:0] valueForKey:@"Distance"] objectAtIndex:0];
        atmObj.lat = [[[[[[[atm objectAtIndex:i] valueForKey:@"Location"] objectAtIndex:0] valueForKey:@"Point"] objectAtIndex:0] valueForKey:@"Latitude"] objectAtIndex:0];
        atmObj.lon = [[[[[[[atm objectAtIndex:i] valueForKey:@"Location"] objectAtIndex:0] valueForKey:@"Point"] objectAtIndex:0] valueForKey:@"Longitude"] objectAtIndex:0];
        
        //        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        NSLog(@"distance: %@",atmObj.distance);
        //        atmObj.distance = [atmObj.distance floatValue];
        
        [atmArray addObject:atmObj];
    }
    
    
    
}
-(void)DTT
{
    
    
    [self.scrollViewTransit addSubview:defaultTableTransit];
    
    
    // [self plotRestoMarkers];
}
-(void)nearbyTab
{
    [self.scrollViewTransit setContentSize:CGSizeMake(1125, 600)];
    
    
    [self.scrollViewTransit addSubview:customTbaleView];
    
    // [self plotAtmMarkers];
}

-(void)orderAndPay
{
    
    
    [self.scrollViewTransit addSubview:tableViewOrderAndPay];
    
    // [self plotRestoMarkers];
}
-(void)defaultMarkerParking
{
    
    AppDelegate *appDelegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
//    float lat1=LAT_1;
//    float lat2=LAT_2;
//    float lat3=LAT_3;
//    
//    float long1=LONG_1;
//    float long2=LONG_2;
//    float long3=LONG_3;


    NSNumber *sumLat1,*sumLat2,*sumLat3,*sumLong1,*sumLong2,*sumLong3;
    
    [mapView clear];
    [self  plotParkingMarkers];
   if(appDelegate.currLat !=0 && appDelegate.currLong !=0 ) {
       
        sumLat1 = [NSNumber numberWithFloat:(appDelegate.currLat + 0.0000100)];
        sumLat2  = [NSNumber numberWithFloat:(appDelegate.currLat + 0.0000900)];
        sumLat3  = [NSNumber numberWithFloat:(appDelegate.currLat + 0.0001000)];
        
        
        sumLong1= [NSNumber numberWithFloat:(appDelegate.currLong+ 0.0000100)];
        sumLong2 = [NSNumber numberWithFloat:(appDelegate.currLong + 0.0000900)];
        sumLong3 = [NSNumber numberWithFloat:(appDelegate.currLong + 0.0001000)];
    }
  
    
    
    NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:sumLat1,@"latitude",sumLong1,@"longitude",@"rent-a-car-s.png",@"image",@"Enterprise Rent-a-Car",@"title", nil],
                             [[NSDictionary alloc]initWithObjectsAndKeys:sumLat2,@"latitude",sumLong2,@"longitude",@"rent-a-car-s.png",@"image",@"Budget Car Rental",@"title", nil],
                             [[NSDictionary alloc]initWithObjectsAndKeys:sumLat3,@"latitude",sumLong3,@"longitude",@"rent-a-car-s.png",@"image",@"Avis Car Rental",@"title", nil],nil];
    
    
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    CLLocationCoordinate2D location;
    
    
    
    
    for (NSDictionary *dictionary in array)
    {
        
        
        
        location.latitude = [dictionary[@"latitude"] doubleValue];
        location.longitude = [dictionary[@"longitude"] doubleValue];
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:dictionary[@"image"]];
        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        bounds = [bounds includingCoordinate:marker.position];
        marker.title = dictionary[@"title"];
        marker.map = self.mapView;
    }
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                            longitude:location.longitude
                                                                 zoom:14];
    
    self.mapView.camera=camera;
    self.mapView.mapType = kGMSTypeNormal;
    self.mapView.delegate=self;
    
    
}
-(void)locationManager:(CLLocationManager *)manager
    didUpdateLocations:(NSArray *)locations
{
    
    
    CLLocation *newLocation = locations[[locations count] -1];
    
    CLLocation *currentLocation = newLocation;
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.currLat = currentLocation.coordinate.latitude;
    appDelegate.currLong = currentLocation.coordinate.longitude;
    if (currentLocation != nil) {
        self.mapView.camera = [GMSCameraPosition cameraWithTarget:currentLocation.coordinate zoom:14 bearing:0 viewingAngle:0];
        self.mapView.myLocationEnabled=YES;
        self.mapView.settings.myLocationButton=YES;
        
        
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:appDelegate.currLat longitude:appDelegate.currLong];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
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
                
            }
        }];
        
        
        [locationManager stopUpdatingLocation];
        [activity stopAnimating];
        
        
    }
    if(appDelegate.currLat !=0 && appDelegate.currLong !=0 )
    {
        
        [self arrayOfParking];
        
        // [defaultTableTransit reloadData];
        
        [defaultTableTransit reloadData];
        
        [self plotParkingMarkers];
        [self defaultMarkerParking];
        [self DTT];
        
        if ([self.parseClass jsonParsingATMData] ) {
            self.storeDataATM=[self.parseClass jsonParsingATMData];
            [self nearbyTab];
            [self arrayOfATM];
        }
        
        
        if ([self.parseClass jsonParsingOAPData] ) {
            self.storeDataOAP=[self.parseClass jsonParsingOAPData];
            [self arrOAP];
            [self orderAndPay];
        }
        
        
        
    }
    
    //    if(appDelegate.currLat !=0 && appDelegate.currLong !=0 )
    //    {
    //
    //        self.storeDataATM=[self.parseClass jsonParsingATMData];
    //        [self nearbyTab];
    //        [self arrayOfATM];
    //
    //
    //       self.storeDataOAP=[self.parseClass jsonParsingOAPData];
    //        [self arrOAP];
    //        [self orderAndPay];
    //
    //    }
}


-(void) plotParkingMarkers
{
    for (int i=0; i<[parkingArray count]; i++){
        
        Parking *parkingObj = [parkingArray objectAtIndex:i];
        
        NSString *latStr = [parkingObj parkingLat];
        NSString *lonStr = [parkingObj parkingLong];
        double lt=[latStr doubleValue];
        double ln=[lonStr doubleValue];
        // NSString *name = [[locations objectAtIndex:i] objectAtIndex:2];
        
        // Instantiate and set the GMSMarker properties
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.appearAnimation=YES;
        marker.position = CLLocationCoordinate2DMake(lt,ln);
        
        marker.title = [parkingObj parkingName];
        //  marker.snippet = [[locations objectAtIndex:i] objectAtIndex:3];
        marker.map = self.mapView;
        [marker setIcon:[UIImage imageNamed:@"default_marker.png"]];
        //  [self.markersArray addObject:marker];
        
    }
    
    float latParking = [[[parkingArray firstObject] parkingLat] floatValue];
    float longParking = [[[parkingArray firstObject] parkingLong] floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latParking
                                                            longitude:longParking
                                                                 zoom:16];
    
    self.mapView.camera=camera;
    
    
    
    self.mapView.delegate=self;
}

-(void) plotRestoMarkers
{
    for (int i=0; i<[restoArray count]; i++){
        
        Restaurant *restObj = [restoArray objectAtIndex:i];
        
        NSString *lat = [restObj lat];
        NSString *lon = [restObj lon];
        double lt=[lat doubleValue];
        double ln=[lon doubleValue];
        
        
        // Instantiate and set the GMSMarker properties
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.appearAnimation=YES;
        marker.position = CLLocationCoordinate2DMake(lt,ln);
        marker.title = [restObj name];
        //  marker.snippet = [[locations objectAtIndex:i] objectAtIndex:3];
        marker.map = self.mapView;
        [marker setIcon:[UIImage imageNamed:@"map-locator.png"]];
        marker.icon = [GMSMarker markerImageWithColor:[UIColor blueColor]];
        //  [self.markersArray addObject:marker];
        
    }
    
    float lat = [[[restoArray firstObject] lat] floatValue];
    float lon = [[[restoArray firstObject] lon] floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:16];
    
    self.mapView.camera=camera;
    
    
    
    self.mapView.delegate=self;
}

-(void) plotAtmMarkers
{
    
    for (int i=0; i<[atmArray count]; i++){
        
        Atm *atmObj = [atmArray objectAtIndex:i];
        
        NSString *lat = [atmObj lat];
        NSString *lon = [atmObj lon];
        double lt=[lat doubleValue];
        double ln=[lon doubleValue];
        // NSString *name = [[locations objectAtIndex:i] objectAtIndex:2];
        
        // Instantiate and set the GMSMarker properties
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.appearAnimation=YES;
        marker.position = CLLocationCoordinate2DMake(lt,ln);
        marker.title = [atmObj name];
        //  marker.snippet = [[locations objectAtIndex:i] objectAtIndex:3];
        marker.map = self.mapView;
        [marker setIcon:[UIImage imageNamed:@"atm-1.png"]];
        //  [self.markersArray addObject:marker];
        
    }
    
    float lat = [[[atmArray firstObject] lat] floatValue];
    float lon = [[[atmArray firstObject] lon] floatValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                            longitude:lon
                                                                 zoom:14];
    
    self.mapView.camera=camera;
    self.mapView.delegate=self;
    
    
}

-(void) slideViewUp:(id)sender
{
    
    if(self.sliderView.frame.origin.y-402 >= 50)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.sliderView.frame = CGRectMake(0,self.sliderView.frame.origin.y-402,375,660);
        
        
        
        CGRect tableFramOap = [tableViewOrderAndPay frame];
        tableFramOap.size.height = 550;
        
        [tableViewOrderAndPay setFrame:tableFramOap];
        
        
        CGRect tableFramAtm = [customTbaleView frame];
        tableFramAtm.size.height = 550;
        
        [customTbaleView setFrame:tableFramAtm];
        
        CGRect stepFrame = [stepTableView frame];
        stepFrame.size.height = 550;
        
        if(stepView!=nil)
        {
            //   stepView = [[UIView alloc] init];
            [stepView setFrame:CGRectMake(stepView.frame.origin.x, stepView.frame.origin.y, stepView.frame.size.width, 550)];
            [stepTableView setFrame:stepFrame];
        }
        CGRect defaulttableFrame = [defaultTableTransit frame];
        defaulttableFrame.size.height = 550;
        
        [defaultTableTransit setFrame:defaulttableFrame];
        
        CGRect transitTableFrame = [transitTbl frame];
        transitTableFrame.size.height = 550;
        [transitTbl setFrame:transitTableFrame];
        
        _txtFieldOrigin.hidden=YES;
        _txtFieldDestination.hidden=YES;
        
        isSlideViewUp = true;
        [UIView commitAnimations];
        
        
    }
    
}
-(void) slideViewDown:(id)sender
{
    
    NSLog(@"Slide view origin Y = %f", self.sliderView.frame.origin.y);
    if(self.sliderView.frame.origin.y+402 < 460)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.5];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        self.sliderView.frame = CGRectMake(0,self.sliderView.frame.origin.y+402,375,660);
        // [stepTableView setFrame:CGRectMake(0, 0, self.sliderView.frame.size.width, self.sliderView.frame.size.height)];
        // mapView.frame = CGRectMake(0,20,320,460);
        _txtFieldOrigin.hidden=NO;
        _txtFieldDestination.hidden=NO;
        
        CGRect tableFramOap = [tableViewOrderAndPay frame];
        tableFramOap.size.height = 150;
        
        [tableViewOrderAndPay setFrame:tableFramOap];
        
        CGRect tableFramAtm = [customTbaleView frame];
        tableFramAtm.size.height = 150;
        
        [customTbaleView setFrame:tableFramAtm];
        
        CGRect defaulttableFrame = [defaultTableTransit frame];
        defaulttableFrame.size.height = 150;
        
        [defaultTableTransit setFrame:defaulttableFrame];
        
        if(stepView != nil)
            [stepView setFrame:CGRectMake(stepView.frame.origin.x, stepView.frame.origin.y, stepView.frame.size.width, 160)];
        
        CGRect stepFrame = [stepTableView frame];
        stepFrame.size.height = stepView.frame.size.height;
        [stepTableView setFrame:stepFrame];
        
        CGRect transitFrame = [transitTbl frame];
        transitFrame.size.height=150;
        [transitTbl setFrame:transitFrame];
        isSlideViewUp = FALSE;
        [UIView commitAnimations];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)showMenu:(id)sender {
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (!isSlideViewUp)
    {
        
        if (!btnOrderAndPayisTapped)
        {
            
            if(networkStatus != NotReachable)
            {
                
                if(transitMenuView == nil)
                {
                    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                    if(appDelegate.setnotice == NO)
                        transitMenuView = [[MenuView alloc] initWithFrame:CGRectMake(180, 20, 170, 260)];
                    else
                        transitMenuView = [[MenuView alloc] initWithFrame:CGRectMake(180, 20, 170, 290)];
                    
                    [transitMenuView setBackgroundColor:[UIColor colorWithRed:43.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:1.0]];
                    [self.view addSubview:transitMenuView];
                    
                }else if(transitMenuView.isHidden == FALSE){
                    [transitMenuView removeFromSuperview];
                    transitMenuView = nil;
                }
            }else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                alert.delegate=self;
                
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Click on the Transit Tab to access Menu" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.delegate=self;
            
            [alert show];
        }
    }
}

-(void) shareJourney
{
    fooFighterAutomatic = TRUE;
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userinfo_dic=[appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,190,315,170)];

    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 315, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Priceless Surprises Available";
    
    NSString *message=[NSString stringWithFormat:@"%@, Enjoy the Foo Fighters VIP Concert Experience", name];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 15, 300, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 135, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 135, 120, 30)];
    [okBtn setTitle:@"View Details" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(SharePricelessOfferView) forControlEvents:UIControlEventTouchUpInside];
    
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
    if (fooFighterAutomatic) {
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                                 target:self
                                               selector:@selector(SharePricelessOfferView)
                                               userInfo:nil
                                                repeats:NO];
    }
}

-(void) pricelessOfferView
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userinfo_dic=[appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,190,300,190)];
    
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Priceless Offer";
    
    NSString *message=[NSString stringWithFormat:@"%@,Enjoy the Foo Fighters VIP Concert Experience", name];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 15, 280, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 5;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 120, 30)];
    [okBtn setTitle:@"Share it" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(SharePricelessOfferView) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
}

-(void) SharePricelessOfferView
{
    // [transitMenuView ShowOnlyMap];
    [customAlertview removeFromSuperview];
    transitMenuView =  nil;
    _myView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, 459)];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [_myView bounds];
    
    
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    //    [_myView.layer renderInContext:context];
    capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *objectsToShare = [[NSArray alloc] initWithObjects:capturedScreen, nil];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    shareController.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypePostToWeibo,UIActivityTypePostToFlickr, UIActivityTypePostToVimeo,UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList];
    
    shareController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    //    PricelessCitiesViewController *pricelessCitiesVC = [[PricelessCitiesViewController alloc] init];
    
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController isKindOfClass:[TransitViewController class]])
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ParkingViewController *pricelessCitiesVC = [storyboard instantiateViewControllerWithIdentifier:@"pricelessCitiesViewController"];
        
        [self presentViewController:pricelessCitiesVC animated:YES completion:nil];
    }
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.setnotice = NO;
    appDelegate.noticeRepeat = TRUE;
}

-(void) parkViewNotice
{
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userinfo_dic=[appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,190,300,190)];
    
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Car Parking";
    
    NSString *message=[NSString stringWithFormat:@"%@, Would You like to park your car?", name];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 15, 280, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 120, 30)];
    [okBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(ParkNoticeView) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
}

-(void) ParkNoticeView
{
    [customAlertview removeFromSuperview];
    transitMenuView = nil;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ParkingViewController *parkVc = [storyboard instantiateViewControllerWithIdentifier:@"parkingViewController"];
    // [self.navigationController pushViewController:fbNoticeVC animated:YES];
    // [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
    if(self.presentedViewController)
        [self.presentedViewController presentViewController:parkVc animated:YES completion:nil];
    else
        [self presentViewController:parkVc animated:YES completion:nil];
    
}
-(void)TravelNotice
{
    travelNoticeAutomatic = TRUE;
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (appDelegate.noticeRepeat == TRUE) {
        travelNoticeAutomatic = TRUE;
        pageLoaded = FALSE;
    }
    
    userinfo_dic=[appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,190,300,190)];
    
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Travel Notice";
    
    NSString *message=[NSString stringWithFormat:@"%@, You have selected travel options during Subscriber Set up. Would you like to set a Travel Notice for Credit card(s) you will be using?", name];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 15, 280, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 120, 30)];
    [okBtn setTitle:@"Set Notice" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(TransitNoticeView) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
    faceBookAutomatic = TRUE;
    
    if (travelNoticeAutomatic && !pageLoaded) {
     timer =  [NSTimer scheduledTimerWithTimeInterval:4.0
                                         target:self
                                       selector:@selector(TransitNoticeView)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void) carRentalNotice
{
    bookCabAutomatic = TRUE;
    pageLoaded = FALSE;
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userinfo_dic=[appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,190,300,190)];
    
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Car Rental Charge";
    
    NSString *message=[NSString stringWithFormat:@"%@,Would you like to rent a car for your trip ?", name];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 10, 280, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, 110, 30)];
    [cancelBtn setTitle:@"Book Cab" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(BookCabNotice) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 120, 30)];
    [okBtn setTitle:@"Rent A Car" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(carRentalNoticeView) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
    if (bookCabAutomatic && !pageLoaded) {
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                         target:self
                                       selector:@selector(BookCabNotice)
                                       userInfo:nil
                                        repeats:NO];
    }
}


-(void)FaceBookNotice
{
    faceBookAutomatic = TRUE;
    pageLoaded = NO;
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    userinfo_dic=[appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,190,300,190)];
    
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Travel destination reached";
    
    NSString *message=[NSString stringWithFormat:@"%@, You have reached New York City. Checkin with Facebook?", name];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 10, 280, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 150, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 120, 30)];
    [okBtn setTitle:@"Checkin" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(FacebookNoticeView) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
    bookCabAutomatic = TRUE;
    
    if (faceBookAutomatic && !pageLoaded) {
       timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                         target:self
                                       selector:@selector(FacebookNoticeView)
                                       userInfo:nil
                                        repeats:NO];
    }
}
-(void)BookCabNotice
{
    bookCabAutomatic = TRUE;
    pageLoaded = FALSE;
    [timer invalidate];
    
    [customAlertview removeFromSuperview];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.rentcar_cab = NO;
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,220,300,150)];
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Book Cab";
    
    NSString *message=[NSString stringWithFormat:@"Would you like to book a cab ? "];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 10, 280, 120);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 110, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 110, 120, 30)];
    [okBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(CabRequest) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
    clientMeetAutomatic = TRUE;
    
    if (bookCabAutomatic && !pageLoaded) {
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                         target:self
                                       selector:@selector(CabRequest)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void)CabRequest
{
    pageLoaded = TRUE;
    [timer invalidate];
    
    [customAlertview removeFromSuperview];
    transitMenuView = nil;
    mapView.frame = CGRectMake(0, 0, 375, 500);
    _sliderHdrView.hidden = true;
    transitTbl.hidden = TRUE;
    //    tableViewOrderAndPay.hidden=TRUE;
    //    customTbaleView.hidden=TRUE;
    //    _scrollViewTransit.hidden = true;
    //_scrollViewTransit.frame = CGRectMake(0, 505, 375, 160);
    _sliderView.frame = CGRectMake(0, 505, 375, 160);//step2 //SET FRAME FOR SLIDERVIEW
    recognizerUp.enabled=NO;
    recognizerDown.enabled=NO;
    
    
    UberView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 160)];
    [_sliderView addSubview:UberView];// step1-->ADDED THIS INTO SLIDER VIEW INSTEAD OF _scrollViewTransit
    defaultTableTransit.hidden=TRUE;
    UberView.backgroundColor=[UIColor whiteColor];
    
    ////////////////
    
    
    UIButton *BookCabButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [BookCabButton addTarget:self action:@selector(BookCab) forControlEvents:UIControlEventTouchDown];
    [BookCabButton setTitle:@"REQUEST" forState:UIControlStateNormal];
    BookCabButton.frame = CGRectMake(0, _sliderView.bounds.origin.y + 100, 375, 70);
    BookCabButton.titleLabel.textColor = [UIColor whiteColor];
    BookCabButton.backgroundColor = [UIColor orangeColor];
    
    UIImageView *UberImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
    UberImage.image = [UIImage imageNamed:@"uber_icon.png"];
    
    UILabel *UberLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 40)];
    UberLabel.text = @"MARK'S TAXI    $8-10";
    UberLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
    
    UILabel *PickUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 40)];
    PickUpLabel.text = @"Pickup in 3 min";
    PickUpLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
    
    UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    //[cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelCab) forControlEvents:UIControlEventTouchUpInside];
    
    [cancelBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    
    
    cancelBtn.frame=CGRectMake(350, 10, 20, 20);
    
    [UberView addSubview:PickUpLabel];
    [UberView addSubview:UberLabel];
    [UberView addSubview:UberImage];
    [UberView addSubview:BookCabButton];
    [UberView addSubview:cancelBtn];
    
}
-(void)cancelCab
{
    [UberView removeFromSuperview];
    _sliderHdrView.hidden = FALSE;
    _scrollViewTransit.hidden = FALSE;
    if (self.txtFieldDestination.text.length == 0) {
        defaultTableTransit.hidden = FALSE;
    }else{
        transitTbl.hidden = FALSE;
    }
    //    tableViewOrderAndPay.hidden=FALSE;
    //    customTbaleView.hidden=FALSE;
    
    _sliderView.frame = CGRectMake(0, 459, 375, 660);
    recognizerUp.enabled=YES;
    recognizerDown.enabled=YES;
    mapView.frame = CGRectMake(0, 0, 375, 459);
    
}
-(void)cabBooked
{
    [customAlertview removeFromSuperview];
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,220,300,160)];
//    headViewCustomAlertView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 300)];
    
    [customAlertview addSubview:headViewCustomAlertView];
    headViewCustomAlertView.backgroundColor=[UIColor orangeColor];
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 45);
    //    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
   title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor colorWithRed:35/255.0 green:182/255.0 blue:255/255.0 alpha:1.0];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Confirm";
    
    UIView *lineview = [[UIView alloc] initWithFrame:CGRectMake(0,45,300,2)];
    [lineview setBackgroundColor:[UIColor colorWithRed:35/255.0 green:182/255.0 blue:255/255.0 alpha:1.0]];
    
    NSString *message=[NSString stringWithFormat:@"Your cab is booked. You will receive the details soon."];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 60, 280, 50);
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIView *lineview1 = [[UIView alloc] initWithFrame:CGRectMake(0,115,300,1)];
    //    [lineview1 setBackgroundColor:[UIColor colorWithRed:35/255.0 green:182/255.0 blue:255/255.0 alpha:1.0]];
    [lineview1 setBackgroundColor:[UIColor lightGrayColor]];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 120, 120, 30)];
    [okBtn setTitle:@"Ok" forState:UIControlStateNormal];
    //    [okBtn setTitleColor:[UIColor colorWithRed:35/255.0 green:182/255.0 blue:255/255.0 alpha:1.0] forState: UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 14.0];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(cancelCabRequest) forControlEvents:UIControlEventTouchUpInside];
    
//    [customAlertview addSubview:lineview];
//    [customAlertview addSubview:lineview1];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:okBtn];
}

-(void) MeetingNotice
{
    clientMeetAutomatic = TRUE;
    pageLoaded = FALSE;
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,220,300,180)];

    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Meeting";
    
    NSString *message=[NSString stringWithFormat:@"You have a client meeting in next 15 minutes!"];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 15, 280, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text =message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 130, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 130, 120, 30)];
    [okBtn setTitle:@"Show Routes" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(showGpx) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
    orderBreakFastAutomatic = TRUE;
    
    if (clientMeetAutomatic && !pageLoaded) {
       timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                         target:self
                                       selector:@selector(showGpx)
                                       userInfo:nil
                                        repeats:NO];
    }
    
}

-(void)Ordernow
{
    orderBreakFastAutomatic = TRUE;
    pageLoaded = FALSE;
    
    customAlertview = [[UIView alloc] initWithFrame:CGRectMake(45,220,300,160)];
    
    [customAlertview setBackgroundColor:[UIColor whiteColor]];
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    [keyWindow addSubview:customAlertview];
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(0, 0, 300, 40);
    title.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont fontWithName:@"HelveticaNeue" size: 18.0];
    title.textAlignment = NSTextAlignmentLeft;
    title.text =@" Order Now";
    
    NSString *message=[NSString stringWithFormat:@"You have reached your destination. would you like to order breakfast?"];
    UILabel *content = [[UILabel alloc] init];
    content.frame = CGRectMake(10, 5, 280, 150);
    content.backgroundColor = [UIColor clearColor];
    content.textColor = [UIColor blackColor];
    content.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    content.textAlignment = NSTextAlignmentLeft;
    content.numberOfLines = 4;
    content.text = message;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 120, 80, 30)];
    [cancelBtn setTitle:@"Dismiss" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(dismissAlertView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 120, 120, 30)];
    [okBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:10/255.0 green:134/255.0 blue:250/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(displayQkrView) forControlEvents:UIControlEventTouchUpInside];
    [customAlertview addSubview:title];
    [customAlertview addSubview:content];
    [customAlertview addSubview:cancelBtn];
    [customAlertview addSubview:okBtn];
    
    fooFighterAutomatic = TRUE;
    
    if (orderBreakFastAutomatic && !pageLoaded) {
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0
                                         target:self
                                       selector:@selector(displayQkrView)
                                       userInfo:nil
                                        repeats:NO];
    }
}

-(void) displayQkrView
{
    pageLoaded = TRUE;

    [customAlertview removeFromSuperview];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    QkrViewController *qkrViewCtrl = [storyboard instantiateViewControllerWithIdentifier:@"qkrViewController"];
    qkrViewCtrl.isDemoModeOn = TRUE;
    [self presentViewController:qkrViewCtrl animated:YES completion:nil];
}

-(void) carRentalNoticeView
{
    pageLoaded = TRUE;
    [timer invalidate];
    
    [customAlertview removeFromSuperview];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.rentcar_cab = YES;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RentCarViewController *rentCarVc = [storyboard instantiateViewControllerWithIdentifier:@"rentCarViewController"];
    // [self.navigationController pushViewController:fbNoticeVC animated:YES];
    [self presentViewController:rentCarVc animated:YES completion:nil];
}
-(void)dismissAlertView
{
    travelNoticeAutomatic = FALSE;
    faceBookAutomatic = FALSE;
    bookCabAutomatic = FALSE;
    clientMeetAutomatic = FALSE;
    orderBreakFastAutomatic = FALSE;
    fooFighterAutomatic = FALSE;
    
    pageLoaded = FALSE;
    
    [timer invalidate];
    
    [customAlertview removeFromSuperview];
    transitMenuView = nil;
    [self cancelCabRequest];
}
-(void) FacebookNoticeView {
    
    pageLoaded = TRUE;
    
    [customAlertview removeFromSuperview];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FBCheckinController *fbNoticeVC = [storyboard instantiateViewControllerWithIdentifier:@"fbCheckinController"];
    // [self.navigationController pushViewController:fbNoticeVC animated:YES];
    [self presentViewController:fbNoticeVC animated:YES completion:nil];
    
}
-(void) TransitNoticeView {
    
    pageLoaded = TRUE;
    [timer invalidate];
    
    [customAlertview removeFromSuperview];
    
    TravelNoticeViewController * transitNoticeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"transitNoticeVC"];
    
    [self presentViewController:transitNoticeVC animated:YES completion:nil];
    
}

-(void) gpxdemo
{
    
    [customAlertview removeFromSuperview];
    transitMenuView = nil;
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    userinfo_dic=[appDelegate UserinfoplistContent:NO];
    
    
    //  NSString *destFromSubscriber=[userinfo_dic objectForKey:@"workAddress"];
    //  NSString *originFromSubscriber=[userinfo_dic objectForKey:@"homeAddress"];
    
    
    //    appDelegate.origin1=originFromSubscriber;
    //
    //    appDelegate.destination1=destFromSubscriber;
    
    if ((self.txtFieldOrigin.text.length != 0)&& (self.txtFieldDestination.text.length != 0)) {
        appDelegate.transitMode=kCarTransit;
        
        [self routePlottingDemoBtnClick];
        
        [self routePlotting:1];
        
        [self updateCurrentLocationAnim];
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please choose origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}
-(void)routePlottingDemo
{
    NSError *error=nil;
    
    [self.mapView clear];
    if (!error) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            
            
            NSString *strEncodedPathDemo=self.storeData[@"routes"][0][@"overview_polyline"][@"points"];
            GMSPath *pathDemo=[GMSPath pathFromEncodedPath:strEncodedPathDemo];
            GMSPolyline *polylineDemo = [[GMSPolyline alloc] init];
            polylineDemo=[GMSPolyline polylineWithPath:pathDemo];
            polylineDemo.strokeWidth=10;
            polylineDemo.strokeColor=[UIColor redColor];
            polylineDemo.map=self.mapView;
            
        }];
        
        
    }
    
}
-(void)routePlottingDemoBtnClick
{
    CLLocationCoordinate2D location;
    
    
    if([[self.storeData valueForKey:@"routes"] count])
    {
        for (NSDictionary *dictionary in [self arrayLatLong])
        {
            location.latitude = [dictionary[@"lat"] floatValue];
            location.longitude = [dictionary[@"lng"] floatValue];
        }
        
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                                longitude:location.longitude
                                                                     zoom:12];
        
        self.mapView.camera=camera;
        self.mapView.mapType = kGMSTypeNormal;
        self.mapView.delegate=self;
        
        //     Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        marker.map = self.mapView;
        
    }
    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == NO_NETWORK_ALERT)
    {
        exit(0);
    }
    else if(alertView.tag == TRAVEL_NOTICE_ALERT)
    {
        if (buttonIndex == 1)
        {
            [alertView removeFromSuperview];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TravelNoticeViewController *transitNoticeVC = [storyboard instantiateViewControllerWithIdentifier:@"transitNoticeVC"];
            
            [self presentViewController:transitNoticeVC animated:YES completion:nil];
        }
    }
    
    if(alertView.tag == FACEBOOK_NOTICE_ALERT)
    {
        if (buttonIndex == 1)
        {
            [alertView removeFromSuperview];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            FBCheckinController *facebookNoticeVC = [storyboard instantiateViewControllerWithIdentifier:@"fbCheckinController"];
            
            [self presentViewController:facebookNoticeVC animated:YES completion:nil];
        }
    }
    
}


- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:transitMenuView];
    
    
    if (location.x < transitMenuView.frame.origin.x || location.x <0 || location.y > transitMenuView.frame.size.height || location.x > transitMenuView.frame.size.width) {
        // your code here...
        
        //rechgMenuView =nil;
        [transitMenuView removeFromSuperview];
        transitMenuView=nil;
    }
    
    
}


-(void) getCurrentLocation
{
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    appDelegate.currLat=0;
    appDelegate.currLong=0;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 10;
    locationManager.delegate=self;
    
    if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
}


#pragma mark - GMSMapView delegate

- (void)mapView:(GMSMapView *)mapView
didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    if(transitMenuView)
    {
        [transitMenuView removeFromSuperview];
        transitMenuView=nil;
    }
    
    if(self.revealedState == JTRevealedStateLeft)
    {
        [self toggleRevealState:JTRevealedStateLeft];
    }
    
    if(eventView)
    {
        [eventView removeFromSuperview];
    }
    if ([_txtFieldOrigin isFirstResponder]) {
        [_txtFieldOrigin resignFirstResponder];
    }
    if ([_txtFieldDestination isFirstResponder]) {
        [_txtFieldDestination resignFirstResponder];
    }
}

#pragma mark JTRevealSidebarDelegate
// This is an example to configure your sidebar view without a UIViewController
- (UIView *)viewForLeftSidebar {
    CGRect viewFrame = self.applicationViewFrame;
    
    UITableViewController *controller = self.sideBarViewController;
    if ( ! controller) {
        self.sideBarViewController = [[SidebarViewController alloc] init];
        self.sideBarViewController.sidebarDelegate = self;
        controller = self.sideBarViewController;
        
    }
    
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    //controller.view.frame = CGRectMake(0, 30, 270, 500);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
    return controller.view;
}

#pragma mark SidebarViewControllerDelegate
- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    
    
    [self toggleRevealState:JTRevealedStateLeft];
    
}

//******************** Table delegates *******************//

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *selectedCell = [tableViewOrigin cellForRowAtIndexPath:indexPath];
    
    if (tableView==tableViewOrigin) {
        self.txtFieldOrigin.text=selectedCell.textLabel.text;
        [self.txtFieldDestination becomeFirstResponder];
        tableViewOrigin.hidden = YES;
    }
    else if (tableView== tableViewDest)
    {
        self.txtFieldDestination.text = selectedCell.textLabel.text;
        tableViewDest.hidden = YES;
        
    }
    
    if(tableView==transitTbl)
    {
//        isSlideViewUp = FALSE;

        if(!stepView)
        {
            if(isSlideViewUp)
                stepView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, self.sliderView.frame.size.width, 550)];
            else
                stepView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, self.sliderView.frame.size.width, self.sliderView.frame.size.height-512)];
            
        }
        //  [stepView setBackgroundColor:[UIColor yellowColor]];
        
        //[transitTbl setHidden:YES];
        [defaultTableTransit setHidden:YES];
        selectedIp = indexPath;
        [self.sliderView addSubview:stepView];
        [self setUpStepView];
    }
    if(tableView==defaultTableTransit)
    {
//        isSlideViewUp = FALSE;

        if (indexPath.row>=1 && indexPath.row<=3) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            RentCarViewController *rentVC = [storyboard instantiateViewControllerWithIdentifier:@"rentCarViewController"];
            
            [self presentViewController:rentVC animated:YES completion:nil];
        }
        if (indexPath.row>=4) {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            ParkingViewController *parkingVC = [storyboard instantiateViewControllerWithIdentifier:@"parkingViewController"];
            
            
            parkingVC.ParkingPlaceTitleText = [[parkingArray objectAtIndex:(indexPath.row -4)] parkingName];
            parkingVC.ParkingPlaceAddressText = [[parkingArray objectAtIndex:(indexPath.row-4)]parkingAddress];
            
            
            
            
            //            parkingVC.ParkingPlaceAddressText = [storeParkingData objectForKey:@"vicinity"];
            
            [self presentViewController:parkingVC animated:YES completion:nil];
            
        }
        if (indexPath.row == 0) {
            mapView.frame = CGRectMake(0, 0, 375, 500);
            _sliderHdrView.hidden = true;
            _scrollViewTransit.hidden = true;
            _sliderView.frame = CGRectMake(0, 505, 375, 160);
            
            
            _txtFieldOrigin.hidden=NO;
            _txtFieldDestination.hidden=NO;
            
            
            
            UberView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 160)];
            [_sliderView addSubview:UberView];
            UberView.backgroundColor=[UIColor whiteColor];

            UIButton *BookCabButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [BookCabButton addTarget:self action:@selector(BookCab) forControlEvents:UIControlEventTouchDown];
            [BookCabButton setTitle:@"REQUEST" forState:UIControlStateNormal];
            BookCabButton.titleLabel.textColor = [UIColor whiteColor];
            BookCabButton.frame = CGRectMake(0, _sliderView.bounds.origin.y+100, 375, 70);
            BookCabButton.backgroundColor = [UIColor orangeColor];
            
            UIImageView *UberImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 40, 40)];
            UberImage.image = [UIImage imageNamed:@"uber_icon.png"];
            
            UILabel *UberLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 200, 40)];
            UberLabel.text = @"MARK'S TAXI    $8-10";
            UberLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:16];
            
            UILabel *PickUpLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, 200, 40)];
            PickUpLabel.text = @"Pickup in 3 min";
            PickUpLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:14];
            
            UIButton *cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            //[cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(cancelCab) forControlEvents:UIControlEventTouchUpInside];
            
            [cancelBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
            
            
            cancelBtn.frame=CGRectMake(350, 10, 20, 20);
            
            recognizerDown.enabled=NO;
            recognizerUp.enabled = NO;
            [UberView addSubview:PickUpLabel];
            [UberView addSubview:UberLabel];
            [UberView addSubview:UberImage];
            [UberView addSubview:BookCabButton];
            [UberView addSubview:cancelBtn];
            
        }
    }
    if(tableView==stepTableView)
    {
        
        [self checkForSubSteps:indexPath];
        
    }
    
    if(tableView==customTbaleView)
    {
//        isSlideViewUp = FALSE;

        float lat = [[[atmArray objectAtIndex:indexPath.row] lat] floatValue];
        float lon = [[[atmArray objectAtIndex:indexPath.row] lon] floatValue];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lon
                                                                     zoom:20];
        
        self.mapView.camera=camera;
        
        
        
        self.mapView.delegate=self;
    }
    
    if(tableView==tableViewOrderAndPay)
    {
//        isSlideViewUp = FALSE;

        float lat = [[[restoArray objectAtIndex:indexPath.row] lat] floatValue];
        float lon = [[[restoArray objectAtIndex:indexPath.row] lon] floatValue];
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:lat
                                                                longitude:lon
                                                                     zoom:20];
        
        self.mapView.camera=camera;
        
        
        
        self.mapView.delegate=self;
    }
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    {
        appDelegate.origin1=self.txtFieldOrigin.text;
        appDelegate.destination1=self.txtFieldDestination.text;
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (tableView == UberTableView) {
        
        [self cabBooked];
    }
    
}

-(void) BookCab {
    
    UberView.hidden = true;
    
    UIImageView *Cabimage1 = [[UIImageView alloc] initWithFrame:CGRectMake(160, 150, 50, 50)];
    Cabimage1.image = [UIImage imageNamed:@"cab.png"];
    Cabimage1.tag = UBER_CAB;
    Cabimage1.contentMode = UIViewContentModeScaleAspectFit;
    [mapView addSubview:Cabimage1];
    
    UIImageView *Cabimage2 = [[UIImageView alloc] initWithFrame:CGRectMake(80, 250, 50, 50)];
    Cabimage2.image = [UIImage imageNamed:@"cab1.png"];
    Cabimage2.tag = UBER_CAB;
    Cabimage2.contentMode = UIViewContentModeScaleAspectFit;
    [mapView addSubview:Cabimage2];
    
    UIImageView *Cabimage3 = [[UIImageView alloc] initWithFrame:CGRectMake(210, 220, 50, 50)];
    Cabimage3.image = [UIImage imageNamed:@"cab2.png"];
    Cabimage3.contentMode = UIViewContentModeScaleAspectFit;
    Cabimage3.tag = UBER_CAB;
    [mapView addSubview:Cabimage3];
    
    
    UberTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _sliderView.bounds.size.width, 180) style:UITableViewStylePlain];
    UberTableView.tag = 1001;
    
    [_sliderView addSubview:UberTableView];
    
    [UberTableView setDelegate:self];
    [UberTableView setDataSource:self];
}

-(void) cancelCabRequest
{
    [customAlertview removeFromSuperview];
    transitMenuView = nil;
    transitTbl.hidden = FALSE;
    [UberView removeFromSuperview];
    [UberTableView removeFromSuperview];
    _sliderHdrView.hidden = FALSE;
    _scrollViewTransit.hidden = FALSE;
    _sliderView.frame = CGRectMake(0, 459, 375, 660);
    defaultTableTransit.hidden=FALSE;//STEP3// MAKING DEFAUULT TABLE VISIBLE WHEN OK OF NOTIFICATION IS BEEN CLICKED.
    
    for(UIButton *btn in [_sliderView subviews])
    {
        if([btn isKindOfClass:[UIButton class]])
        {
            if([btn.titleLabel.text isEqualToString:@"Cancel"])
                [btn removeFromSuperview];
            
        }
    }
    
    for(UIImageView *img in [mapView subviews])
    {
        if(img.tag == UBER_CAB)
            [img removeFromSuperview];
    }
    
    recognizerDown.enabled=YES;
    recognizerUp.enabled=YES;
    mapView.frame = CGRectMake(0, 0, 375, 459);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==transitTbl) {
        return [routeArray count];
    }
    if (tableView==defaultTableTransit) {
        return [parkingArray count];
    }
    if(tableView==customTbaleView)
    {
        return [atmArray count];
    }
    if (tableView==tableViewOrderAndPay) {
        return [restoArray count];
    }
    if(tableView==stepTableView)
    {
        Route *rt = [routeArray objectAtIndex:selectedIp.row];
        
        return stepTblRows;
        
    }
    if (tableView == UberTableView) {
        return [UberMinutes count];
    }
    return [tableData count];
}

-(void) checkForSubSteps:(NSIndexPath*)ip
{
    if([[currStepArr objectAtIndex:ip.row] step_arr])
    {
        unsigned long stepCount = [[[currStepArr objectAtIndex:ip.row] step_arr] count];
        BOOL isAlreadyInserted=NO;
        for(int i=0;i<stepCount;i++)
        {
            Steps *st =[[[currStepArr objectAtIndex:ip.row] step_arr] objectAtIndex:i];
            
            
            //Logic to check if the row is already inserted
            NSInteger index = [currStepArr indexOfObjectIdenticalTo:st];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted)
            {
                stepTblRows = stepTblRows-1;
                [currStepArr removeObjectAtIndex:index];
                NSIndexPath *newIp = [NSIndexPath indexPathForRow:index inSection:ip.section];
                [stepTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:newIp] withRowAnimation:UITableViewRowAnimationTop];
                
            }
            else
            {
                [currStepArr insertObject:st atIndex:ip.row+i+1];
                stepTblRows = stepTblRows+1;
                NSIndexPath *newIp = [NSIndexPath indexPathForRow:ip.row+1 inSection:ip.section];
                
                [stepTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIp] withRowAnimation:UITableViewRowAnimationTop];
                
            }
        }
        
    }
}



#pragma mark - Steps and Direction Function
-(void)arrayOfSteps
{
    NSArray *routes=storeData[@"routes"];
    NSArray *legs=routes[0][@"legs"];
    NSArray *steps=legs[0][@"steps"];
    
    
    NSString *html;
    NSMutableArray *arrSteps=[[NSMutableArray alloc] init];
    NSMutableArray *latlong=[[NSMutableArray alloc]init];
    
    NSMutableArray *durationMode=[[NSMutableArray alloc]init];
    NSMutableArray *durationText=[[NSMutableArray alloc]init];
    NSString *finalString;
    
    for(int i=0; i< [steps count]; i++){
        html=steps[i][@"html_instructions"];
        
        NSString *stringFormatter = [html stringByReplacingOccurrencesOfString:@"[<b>]+[</b>]"
                                                                    withString:@""
                                                                       options:NSRegularExpressionSearch
                                                                         range:NSMakeRange(0, html.length)];
        
        finalString = [stringFormatter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [latlong addObject:steps[i][@"end_location"]];
        
        [durationMode addObject:steps[i][@"duration"]];
        
        [arrSteps addObject:finalString];
    }
    
    for(int i=0; i< [durationMode count]; i++){
        NSString *duration=durationMode[i][@"text"];
        
        [durationText addObject:duration];
    }
    arrDataTransit=arrSteps;
    
    arrDataTransitDuration=durationText;
    [transitTbl reloadData];
    
    
}
//**************************************** Steps on the table cells *********************************************************************//
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


# pragma mark cell for row at index

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==stepTableView)
        return 100;
    if (tableView==tableViewOrderAndPay) {
        return 60;
    }
    if (tableView==customTbaleView) {
        return 70;
    }
    if (tableView == UberTableView) {
        return 70;
    }
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    static NSString *CellIdentifierTransit = @"transitCell";
    static NSString *cellDefaultTransit=@"defaultTableTransit";
    static NSString *cellCustomTransit=@"defaultCustomTransit";
    static NSString *stepCellId=@"stepCellId";
    static NSString *cellCustomOrderAndPay=@"cellCustomOrderAndPay";
    
    if (tableView == UberTableView) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        
        cell.imageView.image = [UIImage imageNamed:@"uber_icon.png"];
        cell.textLabel.text = @"MARK'S TAXI  $8-10";
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:16];
        
        cell.detailTextLabel.text = @"Ride Request";
        cell.detailTextLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:12];
        
        UILabel *ArrivesIn = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width, 0, 100, 30)];
        ArrivesIn.text = @"Arrives in";
        ArrivesIn.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:12];
        ArrivesIn.textColor = [UIColor darkGrayColor];
        [cell addSubview:ArrivesIn];
        
        UILabel *MinuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width, 25, 100, 30)];
        MinuteLabel.text = [UberMinutes objectAtIndex:indexPath.row];
        MinuteLabel.font = [UIFont fontWithName:@"Helvetica Neue Bold" size:12];
        MinuteLabel.textColor = [UIColor blackColor];
        [cell addSubview:MinuteLabel];
        
        
    }
    
    if (tableView==transitTbl) {
    
        TransitTableViewCell *transitCell = (TransitTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierTransit];
        tableView.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        transitCell.userInteractionEnabled=TRUE;
        
        if (transitCell == nil) {
            transitCell = [[TransitTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifierTransit];
            
            
        }
        transitCell.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        
        Route *rt = [[Route alloc] init];
        rt = [routeArray objectAtIndex:indexPath.row] ;
        NSString *str = [NSString stringWithFormat:@"%@",[rt routeDuration] ];
        [transitCell.durationLbl setText:str];
        
        if ([rt dep_time] && [rt arrival_time]) {
            transitCell.startEndTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", [rt dep_time],[rt arrival_time]];
        }
        else
        {
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No routes found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            //            [alert show];
            
            transitCell.startEndTimeLabel.text =@"No routes found";
            
            // transitCell.userInteractionEnabled=FALSE;
        }
        
        //        transitCell.startEndTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", [rt dep_time],[rt arrival_time]];
        
        if(![appDelegate.transitMode isEqualToString:@"train"])
        {
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            NSString *currTime = [NSString stringWithFormat:@"%@",
                                  [df stringFromDate:[NSDate date]]];
            
            int duration =0;
            for (Steps *st in rt.step_arr)
            {
                duration = duration + [self getStepDuration:st];
            }
            
            NSString *endTime =[NSString stringWithFormat:@"%@",
                                [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:(duration*60)]]];
            transitCell.startEndTimeLabel.text = [NSString stringWithFormat:@"%@ - %@", currTime,endTime];
        }
        
        NSString *routInfo = [NSString stringWithFormat:@"%@",[self  convertHTML:[[[rt step_arr] objectAtIndex:0] instruction]]];
        
        [transitCell.routeInfoLbl setText:routInfo];
        [transitCell.numOfSteps setText:[NSString stringWithFormat:@"%lu",(unsigned long)[[rt step_arr] count]]];
        //[transitCell.numOfSteps setFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];
        return transitCell;
        
    }
    if (tableView==defaultTableTransit) {
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellDefaultTransit];
        cell.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellDefaultTransit];
            
        }
        tableView.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        cell.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        
        NSArray *arrImgCar=[[NSArray alloc]init];
        
        NSMutableArray *rentCarFinal=[[NSMutableArray alloc]init];
        
        
        arrImgCar = [NSArray arrayWithObjects:@"Taxi-Cabs_Orange.png",@"rent-a-car-s.png",@"rent-a-car-s.png",@"rent-a-car-s.png",@"parking.png",nil];
        
        NSMutableArray *arrRentACar=[[NSMutableArray alloc]initWithObjects:@"Taxi",@"Enterprise Rent-a-Car",@"Budget Car Rental",@"Avis Car Rental", nil];
        
        NSMutableArray *arrNearest=[[NSMutableArray alloc]initWithObjects:@"Arrives",@"Nearest",@"Nearest",@"Nearest",@"Arrives", nil];
        
        NSMutableArray *arrMiles=[[NSMutableArray alloc]initWithObjects:@"in 2 mins",@".03 miles",@".04 miles",@".06 miles",@"in 2 mins", nil];
        NSMutableArray *arrFrom=[[NSMutableArray alloc]initWithObjects:@"from $59 to $125",@"",@"1550 6th Avenue",@"from $59 to $125",@"Taxi Service",@"1550 6th Avenue", nil];
        
        
        
        for(int i=0;i<[arrRentACar count];i++)
        {
            Parking *parkingObjRentCar = [[Parking alloc]init];
            
            parkingObjRentCar.parkingName=[arrRentACar objectAtIndex:i];
            parkingObjRentCar.parkingAddress=[arrFrom objectAtIndex:i];
            
            
            [rentCarFinal addObject:parkingObjRentCar];
            
        }
        
        
        NSMutableArray *tempArray = [NSMutableArray arrayWithArray:rentCarFinal];
        [tempArray addObjectsFromArray:parkingArray];
        [self tableCellUI_DTT];
        
        if (indexPath.row>3) {
            animatedParkImg.image =[UIImage imageNamed:@"parking.png"];
            [lblNearest setText:@"Away 10"];
            [lblMiles setText:@"mins"];
        }
        else
        {
            animatedParkImg.image = [UIImage imageNamed:[arrImgCar objectAtIndex:indexPath.row]];
            [lblNearest setText:[arrNearest objectAtIndex:[indexPath row]]];
            [lblMiles setText:[arrMiles objectAtIndex:[indexPath row]]];
        }
        
        
        
        
        
        [lblRentACar setText:[[tempArray objectAtIndex:indexPath.row] parkingName]];
        [lblFrom setText:[[tempArray objectAtIndex:indexPath.row] parkingAddress]];
        
        
        
        if ((([cell.contentView viewWithTag:1]) && ([cell.contentView viewWithTag:2]) && ([cell.contentView viewWithTag:3]) && ([cell.contentView viewWithTag:4]) && ([cell.contentView viewWithTag:5])))
        {
            [[cell.contentView viewWithTag:1]removeFromSuperview];
            [[cell.contentView viewWithTag:2]removeFromSuperview];
            [[cell.contentView viewWithTag:3]removeFromSuperview];
            [[cell.contentView viewWithTag:4]removeFromSuperview];
            [[cell.contentView viewWithTag:5]removeFromSuperview];
        }
        [cell.contentView addSubview:lblRentACar];
        [cell.contentView addSubview:lblFrom];
        [cell.contentView addSubview:lblNearest];
        [cell.contentView addSubview:lblMiles];
        [cell.contentView addSubview:animatedParkImg];
        
    }
    
    if ((tableView==tableViewDest) || (tableView==tableViewOrigin)) {
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        
        [lblAddressLine1 setText:[arrFinalLine1 objectAtIndex:[indexPath row]]];
        cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont  fontWithName:@"Helvetica Neue" size:14]];
    }
    
    if (tableView ==customTbaleView) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellCustomTransit];
        }
        tableView.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        //**************** UI FUNCTION FOR TABLE CELL CALL ********************//
        [self tableCellUINearBy];
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        [formatter setMaximumFractionDigits:2];
        [formatter setRoundingMode: NSNumberFormatterRoundUp];
        
        [lblAddressLine1 setText:[[atmArray objectAtIndex:indexPath.row] addressLine1]];
        [lblATMCity setText:[[atmArray objectAtIndex:indexPath.row] city]];
        [lblATMZipCode setText:[[atmArray objectAtIndex:indexPath.row] postalCode]]; //just for checking
//        [lblATMZipCode setText:@"560076"];
        [lblATMName setText:[[atmArray objectAtIndex:indexPath.row] name]];
        
        //        [lblDistanceMilesNumber setText:[[atmArray objectAtIndex:indexPath.row] distance]];
        float distanceValue = [[[atmArray objectAtIndex:indexPath.row] distance] floatValue];
        [lblDistanceMilesNumber setText:[NSString stringWithFormat:@"%.02f",distanceValue]];
        
        UIImageView *animatedATM = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        
        animatedATM.image = [UIImage imageNamed:@"atm_arounds.png"];
        
        if ((([cell.contentView viewWithTag:1]) && ([cell.contentView viewWithTag:2]) && ([cell.contentView viewWithTag:3]) && ([cell.contentView viewWithTag:4]) && ([cell.contentView viewWithTag:5])&& ([cell.contentView viewWithTag:6])&& ([cell.contentView viewWithTag:7])))
        {
            [[cell.contentView viewWithTag:1]removeFromSuperview];
            [[cell.contentView viewWithTag:2]removeFromSuperview];
            [[cell.contentView viewWithTag:3]removeFromSuperview];
            [[cell.contentView viewWithTag:4]removeFromSuperview];
            [[cell.contentView viewWithTag:5]removeFromSuperview];
            [[cell.contentView viewWithTag:6]removeFromSuperview];
            [[cell.contentView viewWithTag:7]removeFromSuperview];
        }
        cell.accessoryType = nil;
        cell.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        
        
        [cell.contentView addSubview:lblAddressLine1];
        [cell.contentView addSubview:lblAddressLine2];
        [cell.contentView addSubview:lblATMCity];
        [cell.contentView addSubview:lblATMZipCode];
        [cell.contentView addSubview:lblATMName];
        [cell.contentView addSubview:animatedATM];
        [cell.contentView addSubview:lblDistanceMilesNumber];
        [cell.contentView addSubview:lblDistanceMilesText];
        
    }
    if (tableView ==tableViewOrderAndPay) {
        
        cell = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellCustomOrderAndPay];
        }
        tableView.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        //**************** UI FUNCTION FOR TABLE CELL CALL ********************//
        [self tableCellUI_ORDER_And_Pay];
        
        Restaurant *rest = [restoArray objectAtIndex:indexPath.row];
        
        [lblAddressLine1 setText:rest.address];
        
        
        [lblRestName setText:rest.name];
        
        
        
        UIImageView *imgChopSticksOAP = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
        
        //imgChopSticksOAP.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:rest.iconUrl]]];
        //        NSError *error=nil;
        //imgChopSticksOAP.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:rest.iconUrl] options:NSDataReadingMappedAlways error:&error]];
        
        //imgChopSticksOAP.image = [UIImage imageNamed:@"qkr-icon.png"];
        //qkrViewCOntroller
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        dispatch_async(queue, ^{
            NSData *imgdata = [NSData dataWithContentsOfURL:[NSURL URLWithString:rest.iconUrl]];
            UIImage *image = [UIImage imageWithData:imgdata];
            dispatch_async(dispatch_get_main_queue(), ^{
                imgChopSticksOAP.image = image;
            });
        });
        
        
        UIButton *btn_QKR_OAP = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn_QKR_OAP addTarget:self
                        action:@selector(qkrViewController)
              forControlEvents:UIControlEventTouchUpInside];
        
        btn_QKR_OAP.frame = CGRectMake(325, 14, 50, 23);
        
        //[btn_QKR_OAP setBackgroundColor:[UIColor clearColor]];
        
        // [btn_QKR_OAP setImage:[UIImage imageNamed:@"qkr-icon.png"] forState:UIControlStateNormal];
        [cell.contentView addSubview:btn_QKR_OAP];
        
        UIImageView *img_QKR_OAP = [[UIImageView alloc] initWithFrame:CGRectMake(320, 14, 40, 19)];
        
        img_QKR_OAP.image = [UIImage imageNamed:@"qkr-icon.png"];
        
        [btn_QKR_OAP addSubview:img_QKR_OAP];
        if ((([cell.contentView viewWithTag:1]) && ([cell.contentView viewWithTag:2])))
        {
            [[cell.contentView viewWithTag:1]removeFromSuperview];
            [[cell.contentView viewWithTag:2]removeFromSuperview];
            
        }
        
        cell.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        [cell.contentView addSubview:lblAddressLine1];
        [cell.contentView addSubview:lblRestName];
        [cell.contentView addSubview:imgChopSticksOAP];
        [cell.contentView addSubview:img_QKR_OAP];
        
        
    }
    
    
    if(tableView==stepTableView)
    {
        
        StepTableViewCell *stepCell = (StepTableViewCell*)[tableView dequeueReusableCellWithIdentifier:stepCellId];
        
        
        if (stepCell == nil) {
            stepCell = [[StepTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stepCellId];
            
            
        }
        tableView.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        stepCell.backgroundColor=[UIColor colorWithRed:8.0/255.0 green:44.0/255.0 blue:59.0/255.0 alpha:1.0];
        
        Steps *stepObj = [currStepArr objectAtIndex:indexPath.row];
        
        [stepCell.stepDistance setText:[NSString stringWithFormat:@"No. Stops:%@",stepObj.transtDtls.numStop]];
        [stepCell.stepInstruction setText:[self convertHTML:stepObj.instruction]];
        stepCell.departTime.text = stepObj.transtDtls.depTime;
        if (stepObj.transtDtls.short_name != NULL) {
            stepCell.stepLineName.text = [NSString stringWithFormat:@"%@ %@", stepObj.transtDtls.short_name,stepObj.transtDtls.lineAgencyName];
        }else {
            stepCell.stepLineName.text = [NSString stringWithFormat:@"%@",stepObj.transtDtls.lineAgencyName];
        }
        
        stepCell.stepArrivalStop.text = [NSString stringWithFormat:@"Arrival Stop:%@",stepObj.transtDtls.arrStopName];
        stepCell.stepDepStop.text = [NSString stringWithFormat:@"Departure Stop:%@",stepObj.transtDtls.depStopName];
        
        
        if(stepObj.tm == walking)
        {
            stepCell.transitType.image = [UIImage imageNamed:@"walk-small.png"];
            stepCell.stepRouteImage.image = [UIImage imageNamed:@"dotted-path.png"];
            [stepCell.stepDistance setText:@""];
            stepCell.stepLineName.text=@"Walk...";
            stepCell.stepArrivalStop.text = @"";
            stepCell.stepDepStop.text = @"";
        }
        else
        {
            stepCell.stepRouteImage.image = [UIImage imageNamed:@"line-path.png"];
        }
        
        if([appDelegate.transitMode isEqualToString:@"driving"])
        {
            stepCell.transitType.image = [UIImage imageNamed:@"car-black.png"];
            stepCell.stepLineName.text=@"";
            stepCell.stepRouteImage.image = [UIImage imageNamed:@"line-path.png"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            NSString *currTime = [NSString stringWithFormat:@"%@",
                                  [df stringFromDate:[NSDate date]]];
            
            if(indexPath.row==0)
            {
                stepCell.departTime.text = currTime;
            }
            else
            {
                int dur=0;
                for(int i=0;i<indexPath.row;i++)
                {
                    dur = dur + [self getStepDuration:[currStepArr objectAtIndex:i]];
                }
                
                
                NSString *currTime = [NSString stringWithFormat:@"%@",
                                      [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:(60*dur)]]];
                stepCell.departTime.text = currTime;
            }
            
            
        }
        else if([appDelegate.transitMode isEqualToString:@"walking"])
        {
            stepCell.transitType.image = [UIImage imageNamed:@"walk-small.png"];
            stepCell.stepLineName.text=@"";
            
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            NSString *currTime = [NSString stringWithFormat:@"%@",
                                  [df stringFromDate:[NSDate date]]];
            
            if(indexPath.row==0)
            {
                stepCell.departTime.text = currTime;
            }
            else
            {
                int dur=0;
                for(int i=0;i<indexPath.row;i++)
                {
                    dur = dur + [self getStepDuration:[currStepArr objectAtIndex:i]];
                }
                
                
                NSString *currTime = [NSString stringWithFormat:@"%@",
                                      [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:(60*dur)]]];
                stepCell.departTime.text = currTime;
            }
            
            
        }
        
        else if([appDelegate.transitMode isEqualToString:@"bicycling"])
        {
            stepCell.transitType.image = [UIImage imageNamed:@"bike.png"];
            stepCell.stepLineName.text=@"";
            stepCell.stepRouteImage.image = [UIImage imageNamed:@"line-path.png"];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"hh:mm a"];
            NSString *currTime = [NSString stringWithFormat:@"%@",
                                  [df stringFromDate:[NSDate date]]];
            
            if(indexPath.row==0)
            {
                stepCell.departTime.text = currTime;
            }
            else
            {
                int dur=0;
                for(int i=0;i<indexPath.row;i++)
                {
                    dur = dur + [self getStepDuration:[currStepArr objectAtIndex:i]];
                }
                
                
                NSString *currTime = [NSString stringWithFormat:@"%@",
                                      [df stringFromDate:[[NSDate date] dateByAddingTimeInterval:(60*dur)]]];
                stepCell.departTime.text = currTime;
            }
            
            
        }
        
        
//        NSString *firstLetter = [stepObj.transtDtls.short_name substringToIndex:1];
//        NSArray *strVal= [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"D",@"E",@"F",@"G",@"J",@"L",@"M",@"N",@"Q",@"R",@"S",@"T",@"Z",nil];
//        
//        NSArray *strImageNamed=[NSArray arrayWithObjects:@"1.png",@"2.png",@"3.png",@"4.png",@"5.png",@"6.png",@"7.png",@"8.png",@"9.png",@"a.png",@"b.png",@"d.png",@"e.png",@"f.png",@"g.png",@"j.png",@"l.png",@"m.png",@"n.png",@"q.png",@"r.png",@"s.png",@"t.png",@"z.png",nil];
//        
//        if([firstLetter isEqualToString:[strVal objectAtIndex:[indexPath row]]])
//        {
//            stepCell.transitType.image = [UIImage imageNamed:[strImageNamed objectAtIndex:indexPath.row]];
//        }
//
        
        NSString *tempString = [[stepObj.instruction componentsSeparatedByString:@" "] objectAtIndex:0];
        
        if (stepObj.transtDtls.short_name != NULL) {
            if([tempString isEqualToString:@"Bus"]) {
                stepCell.transitType.image = [UIImage imageNamed:@"mta_bus2.png"];
            }else {
                
                NSString *firstLetter = [stepObj.transtDtls.short_name substringToIndex:1];
                
                
                if([firstLetter isEqualToString:@"1"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"1.png"];
                }
                else if([firstLetter isEqualToString:@"2"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"2.png"];
                }
                else if([firstLetter isEqualToString:@"3"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"3.png"];
                }
                else if([firstLetter isEqualToString:@"4"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"4.png"];
                }
                else if([firstLetter isEqualToString:@"5"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"5.png"];
                }
                else if([firstLetter isEqualToString:@"6"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"6.png"];
                }
                else if([firstLetter isEqualToString:@"7"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"7.png"];
                }
                else if([firstLetter isEqualToString:@"8"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"8.png"];
                }
                else if([firstLetter isEqualToString:@"9"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"q.png"];
                }
                else if([firstLetter isEqualToString:@"A"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"a.png"];
                }
                else if([firstLetter isEqualToString:@"B"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"b.png"];
                }
                else if([firstLetter isEqualToString:@"D"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"d.png"];
                }
                else if([firstLetter isEqualToString:@"E"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"e.png"];
                }
                else if([firstLetter isEqualToString:@"F"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"f.png"];
                }
                else if([firstLetter isEqualToString:@"G"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"g.png"];
                } else if([firstLetter isEqualToString:@"J"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"j.png"];
                }
                else if([firstLetter isEqualToString:@"L"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"l.png"];
                }
                else if([firstLetter isEqualToString:@"M"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"m.png"];
                } else if([firstLetter isEqualToString:@"N"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"n.png"];
                }
                else if([firstLetter isEqualToString:@"Q"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"q.png"];
                }
                else if([firstLetter isEqualToString:@"R"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"r.png"];
                }
                else if([firstLetter isEqualToString:@"S"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"s.png"];
                }
                else if([firstLetter isEqualToString:@"T"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"t.png"];
                }
                else if([firstLetter isEqualToString:@"Z"])
                {
                    stepCell.transitType.image = [UIImage imageNamed:@"z.png"];
                }
            }  // stepCell.textLabel.text = @"NORMAL";
        }
        else if([tempString isEqualToString:@"Train"]) {
            stepCell.transitType.image = [UIImage imageNamed:@"train_off.png"];
        }
        
        return stepCell;
    }
    return cell;
    
}


-(void)qkrViewController
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    QkrViewController *qkrVC = [storyboard instantiateViewControllerWithIdentifier:@"qkrViewController"];
    
    
    [self presentViewController:qkrVC animated:YES completion:nil];
    
    
}

-(void)tableCellUI_DTT
{
    lblRentACar = [[UILabel alloc] initWithFrame:CGRectMake(45, 5, 250, 21)];
    
    
    [lblRentACar setTextColor:[UIColor whiteColor]];
    // [lblATMName setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblRentACar setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
    [lblRentACar setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblRentACar.tag=1;
    
    lblNearest = [[UILabel alloc] initWithFrame:CGRectMake(295, 11, 80, 21)];
    [lblNearest setTextColor:[UIColor whiteColor]];
    // [lblAddressLine1 setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblNearest setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblNearest setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblNearest.tag=2;
    
    
    lblMiles = [[UILabel alloc] initWithFrame:CGRectMake(295, 30, 60, 21)];
    [lblMiles setTextColor:[UIColor whiteColor]];
    //[lblAddressLine2 setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblMiles setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblMiles setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblMiles.tag=3;
    
    lblFrom = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 247, 21)];
    [lblFrom setTextColor:[UIColor whiteColor]];
    //[lblATMCity setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblFrom setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblFrom setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblFrom.tag=4;
    
    animatedParkImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    animatedParkImg.tag=5;
    
    
    
    
}
-(void)tableCellUI_ORDER_And_Pay
{
    lblRestName = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 250, 15)];
    
    
    [lblRestName setTextColor:[UIColor whiteColor]];
    // [lblATMName setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblRestName setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
    [lblRestName setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblRestName.tag=1;
    
    lblAddressLine1 = [[UILabel alloc] initWithFrame:CGRectMake(45, 25, 270, 35)];
    [lblAddressLine1 setTextColor:[UIColor whiteColor]];
    // [lblAddressLine1 setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblAddressLine1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblAddressLine1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblAddressLine1.tag=2;
    [lblAddressLine1 setNumberOfLines:2];
    
    
}
-(void)reloadTransitPage
{
    [transitMenuView removeFromSuperview];
    transitMenuView = nil;
    
    
    [self.scrollViewTransit setContentOffset:CGPointMake(0, 0) animated:YES];
    self.transitBtnHighlightView.hidden = YES;
    self.nearbyHighlightView.hidden = YES;
    self.orderPayHighlightView.hidden = YES;
    
    if([self.txtFieldDestination.text isEqualToString:@""] && [self.txtFieldOrigin.text isEqualToString:@""])
    {
        [self.mapView clear];
        [self plotParkingMarkers];
        [self defaultMarkerParking];
    }
    
    else
    {
        [self.mapView clear];
        
        AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if([appdelegate.transitMode isEqualToString:kTrainTransit])
        {
            [self.btnTrainTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        else if([appdelegate.transitMode isEqualToString:kCarTransit])
            [self.btnCarTransitref sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        else if([appdelegate.transitMode isEqualToString:kWalking])
            [self.btnWalkTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        else if([appdelegate.transitMode isEqualToString:kBicycleTransit])
            [self.btnBicycleTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        
    }
}

-(int) getStepDuration:(Steps*) st
{
    NSString *durationStr = st.duration;
    int duration = [[durationStr substringToIndex:2] intValue];
    return duration;
}

-(void)tableCellUINearBy
{
    lblATMName = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 250, 15)];
    
    
    [lblATMName setTextColor:[UIColor whiteColor]];
    // [lblATMName setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblATMName setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]];
    [lblATMName setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblATMName.tag=1;
    
    lblAddressLine1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 180, 15)];
    [lblAddressLine1 setTextColor:[UIColor whiteColor]];
    // [lblAddressLine1 setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblAddressLine1 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblAddressLine1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblAddressLine1.tag=2;
    
    
    lblAddressLine2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 38, 50, 12)];
    [lblAddressLine2 setTextColor:[UIColor whiteColor]];
    //[lblAddressLine2 setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblAddressLine2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblAddressLine2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblAddressLine2.tag=3;
    
    lblATMCity = [[UILabel alloc] initWithFrame:CGRectMake(50, 38, 80, 10)];
    [lblATMCity setTextColor:[UIColor whiteColor]];
    //[lblATMCity setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblATMCity setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblATMCity setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblATMCity.tag=4;
    
    lblATMZipCode = [[UILabel alloc] initWithFrame:CGRectMake(50, 52, 50, 10)]; //changed postal code frame : earlier size - x= 110, now 50
    [lblATMZipCode setTextColor:[UIColor whiteColor]];
    // [lblATMZipCode setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblATMZipCode setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblATMZipCode setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblATMZipCode.tag=5;
    
    
    lblDistanceMilesNumber = [[UILabel alloc] initWithFrame:CGRectMake(300, 20, 60, 15)];
    [lblDistanceMilesNumber setTextColor:[UIColor whiteColor]];
    // [lblAddressLine1 setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblDistanceMilesNumber setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblDistanceMilesNumber setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblDistanceMilesNumber.tag=6;
    
    lblDistanceMilesText = [[UILabel alloc] initWithFrame:CGRectMake(330, 20, 30, 15)];
    [lblDistanceMilesText setText:@"Miles"];
    [lblDistanceMilesText setTextColor:[UIColor whiteColor]];
    // [lblAddressLine1 setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
    [lblDistanceMilesText setFont:[UIFont fontWithName:@"HelveticaNeue" size:12.0f]];
    [lblDistanceMilesText setTranslatesAutoresizingMaskIntoConstraints:NO];
    lblDistanceMilesText.tag=7;
    
}


-(void) setUpStepView
{
    // stepTableView = [[UITableView alloc] initWithFrame:stepView.frame];
    
    if(stepTableView)
        [stepTableView removeFromSuperview];
    
    stepTableView = [[UITableView alloc] init];
    [stepTableView registerNib:[UINib nibWithNibName:@"StepTableViewCell" bundle:nil ] forCellReuseIdentifier:@"stepCellId"];
    
    stepTblRows = [[[routeArray objectAtIndex:selectedIp.row] step_arr] count];
    
    float width =stepView.frame.size.width;
    float height =stepView.frame.size.height;
    [stepTableView setFrame:CGRectMake(0, 0,width ,height )];
    
    
    stepTableView.delegate=self;
    stepTableView.dataSource=self;
    [stepView addSubview:stepTableView];
    [currStepArr removeAllObjects];
    currStepArr = nil;
    currStepArr = [[NSMutableArray alloc] initWithArray:[[routeArray objectAtIndex:selectedIp.row] step_arr]];
    
    //[stepTableView reloadData];
}




//********************  End of Table delegates *******************//


-(void) tableRoladData{
    
    UITableView * selfTable = tableViewOrigin;
    
    [selfTable reloadData];
    
}
-(void) tableDestReloadData{
    
    UITableView * selfTableDest = tableViewDest;
    
    [selfTableDest reloadData];
}

-(void) tableDestReloadDataBottom{
    
    UITableView * selfTableDest = transitTbl;
    
    [selfTableDest reloadData];
}

# pragma  mark Global Search IMPLEMENTATION


-(NSMutableArray *)arrGlobalSearch:(NSString *)arrGlobal
{
    
    
    NSString *geocode=@"geocode";
    
    NSString *key=@"AIzaSyCBBzuSsJcuA0f2oOO-qCB-OVHHoQJrnNw";
    
    
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@input=%@&types=%@&key=%@", kDirectionsURL, arrGlobal, geocode,key];
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSError *error=nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    dataHold = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers  error:nil];
    if(error)
    {
        NSLog(@"ERROR MESSAGE = %@", error.description);
    }
    
    
    jsonDiction =[(NSDictionary *)result objectForKey:@"predictions"];
    
    
    NSArray *results=dataHold[@"predictions"];
    
    textsteps=[[NSMutableArray alloc] init];
    
    for(int i=0; i< [results count]; i++){
        NSString *name=results[i][@"description"];
        
        [textsteps addObject:name];
    }
    
    
    return textsteps;
}


//******************** UITextField Delegates *******************//



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == self.txtFieldOrigin)
    {
        //textField.text=@"";
    }
    
    return TRUE;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
//    if((self.txtFieldDestination.text.length!=0) && (self.txtFieldOrigin.text.length!=0))
//   {
        self.btnTrainTransitRef.enabled=YES;
//        
//    }
    self.btnCarTransitref.enabled=YES;
    self.btnBicycleTransitRef.enabled=YES;
    self.btnWalkTransitRef.enabled=YES;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *searchText;
    
    searchText=[textField.text stringByAppendingString:string];
    
    if (textField == self.txtFieldOrigin) {
        tableViewOrigin.hidden = NO;
        tableViewDest.hidden = YES;
    } else {
        tableViewOrigin.hidden = YES;
        tableViewDest.hidden = NO;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        tableData=(NSMutableArray*)[[self arrGlobalSearch:searchText] filteredArrayUsingPredicate:predicate];
        
        //        NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithArray: [tableData
        //                                                                             sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        
        
        
        if([self.txtFieldDestination.text isEqualToString:@""])
            
        {
            
            [self arrayOfParking];
            
            self.defaultTableTransit.hidden=FALSE;
            self.transitTbl.hidden=TRUE;
             stepTableView.hidden=TRUE;
            [self plotParkingMarkers];
            [self defaultMarkerParking];
        }
        else
        {
            
            self.transitTbl.hidden=FALSE;
        }
        
        
        
        // transitTbl.hidden=FALSE;
        
        [self tableRoladData];
        [self tableDestReloadData];
        [self tableDestReloadDataBottom];
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
    
    
    return true;
    
}
//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [textField resignFirstResponder];
//    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    
//    if (textField == self.txtFieldDestination) {
//        self.modeOfTransportView.hidden = NO;
//        self.defaultTableTransit.hidden=NO;
//        // [self.btnTrainTransitRef setImage:[UIImage imageNamed:@"train_on.png"] forState:UIControlStateSelected];
//        [self btnTrainTransit:nil];
//        if ([self.txtFieldOrigin.text length]==0 || [self.txtFieldOrigin.text isEqualToString:@"Current Location"])
//        {
//            
//            
//            if(addressString != nil)
//                appDelegate.origin1=addressString;
//            if(self.txtFieldDestination.text.length != 0)
//            {
//                appDelegate.destination1=self.txtFieldDestination.text;
//            }
//            
//        }
//        else
//        {
//            appDelegate.origin1=self.txtFieldOrigin.text;
//            appDelegate.destination1=self.txtFieldDestination.text;
//            
//        }
//        //        if((self.txtFieldDestination.text.length!=0) || (self.txtFieldOrigin.text.length!=0))
//        //        {
//        //
//        //            transitTbl.hidden = FALSE;
//        //            [self.transitTbl reloadData];
//        //
//        //            [self.btnTrainTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
//        //        }
//        //        else
//        if(self.txtFieldDestination.text.length==0)
//            
//        {
//            
//            [self arrayOfParking];
//            self.defaultTableTransit.hidden=FALSE;
//            [self.defaultTableTransit reloadData];
//            //            self.transitTbl.hidden=TRUE;
//            //            stepTableView.hidden=TRUE;
//            //
//            //[self.scrollViewTransit sendSubviewToBack:transitTbl];
//            [self plotParkingMarkers];
//            [self defaultMarkerParking];
//        }
//        //        else
//        //        {
//        //            [transitTbl reloadData];
//        //            //            self.transitTbl.hidden=FALSE;
//        //        }
//        //
//        //        [self hideOriginDestFields];
//        
//    }
//    self.scrollViewTransit.contentOffset = CGPointMake(0, 0);
//    self.btnTransitRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
//    self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
//    self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
//    btnOrderAndPayisTapped = FALSE;
//    
//    return YES;
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    
    if (textField == self.txtFieldDestination) {
        self.modeOfTransportView.hidden = NO;
        
        // [self.btnTrainTransitRef setImage:[UIImage imageNamed:@"train_on.png"] forState:UIControlStateSelected];
        [self btnTrainTransit:nil];
        if ([self.txtFieldOrigin.text length]==0 || [self.txtFieldOrigin.text isEqualToString:@"Current Location"])
        {
            
            
            if(addressString != nil)
                appDelegate.origin1=addressString;
            if(self.txtFieldDestination.text != nil)
                appDelegate.destination1=self.txtFieldDestination.text;
        }
        else
        {
            appDelegate.origin1=self.txtFieldOrigin.text;
            appDelegate.destination1=self.txtFieldDestination.text;
            
        }
        if((self.txtFieldDestination.text.length!=0) && (self.txtFieldOrigin.text.length!=0))
        {
            [self.transitTbl reloadData];
            [self.btnTrainTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if([self.txtFieldDestination.text isEqualToString:@""])
            
        {
            
            [self arrayOfParking];
            
            self.defaultTableTransit.hidden=FALSE;
            self.transitTbl.hidden=TRUE;
            [self plotParkingMarkers];
            [self defaultMarkerParking];
        }
        else
        {
            [transitTbl reloadData];
            //            self.transitTbl.hidden=FALSE;
        }
        
        [self hideOriginDestFields];
        
        self.scrollViewTransit.contentOffset = CGPointMake(0, 0);
        self.btnTransitRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
        self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
        self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
        btnOrderAndPayisTapped = FALSE;
        
    }
    return YES;
}
- (IBAction)toggleView:(id)sender {
    
    if ([_txtFieldOrigin isFirstResponder]) {
        [_txtFieldOrigin resignFirstResponder];
    }
    if ([_txtFieldDestination isFirstResponder]) {
        [_txtFieldDestination resignFirstResponder];
    }
    [self toggleRevealState:JTRevealedStateLeft];
}


- (IBAction)btnTransitOptn:(id)sender {
    
    
    UIButton *btn=(UIButton *)sender;
    
    if (btn.tag == TRANSIT_TAB) {
        
        btnOrderAndPayisTapped = NO;
        
        [self.scrollViewTransit setContentOffset:CGPointMake(0, 0) animated:YES];
        self.transitBtnHighlightView.hidden = YES;
        self.nearbyHighlightView.hidden = YES;
        self.orderPayHighlightView.hidden = YES;
//        
//        [lblRedBorderTransit setBackgroundColor:[UIColor clearColor]];
//        [lblNearBy setBackgroundColor:[UIColor redColor]];
//        [lblOrderAndPay setBackgroundColor:[UIColor clearColor]];
    
        self.btnTransitRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
        self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
        self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
        
        if([self.txtFieldDestination.text isEqualToString:@""] )
        {
            [self.mapView clear];
            [self plotParkingMarkers];
            [self defaultMarkerParking];
        }
        
        else
        {
            [self.mapView clear];
            
            AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            
            if([appdelegate.transitMode isEqualToString:kTrainTransit])
            {
                [self.btnTrainTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            else if([appdelegate.transitMode isEqualToString:kCarTransit])
                [self.btnCarTransitref sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            else if([appdelegate.transitMode isEqualToString:kWalking])
                [self.btnWalkTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            else if([appdelegate.transitMode isEqualToString:kBicycleTransit])
                [self.btnBicycleTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
            
            
        }
        
        
    } else if(btn.tag ==NEARBY_TAB )
    {
        btnOrderAndPayisTapped = YES;
        
        self.btnTransitRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
        self.btnNearByRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
        self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange

        if(stepTableView)
        {
            [stepTableView removeFromSuperview];
            [stepView removeFromSuperview];
            stepTableView = nil;
            stepTableView=nil;
        }
        [self.scrollViewTransit setContentOffset:CGPointMake(380, 0) animated:YES];
        self.transitBtnHighlightView.hidden = YES;
        self.nearbyHighlightView.hidden = YES;
        self.orderPayHighlightView.hidden = YES;
        [self.mapView clear];
        if([atmArray count]==0)
        {
            self.storeDataATM=[self.parseClass jsonParsingATMData];
            [self nearbyTab];
            [self arrayOfATM];
        }
        [self plotAtmMarkers];
        
    }
    else if (btn.tag == ORDER_AND_PAY_TAB)
    {
        btnOrderAndPayisTapped = YES;
        self.btnTransitRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
        self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
        self.btnOAPRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
        
        if(stepTableView)
        {
            [stepTableView removeFromSuperview];
            [stepView removeFromSuperview];
            stepTableView = nil;
            stepTableView=nil;
        }
        [self.scrollViewTransit setContentOffset:CGPointMake(760, 0) animated:YES];
        self.transitBtnHighlightView.hidden = YES;
        self.nearbyHighlightView.hidden = YES;
        self.orderPayHighlightView.hidden = YES;
        [self.mapView clear];
        
        if([restoArray count]==0)
        {
            self.storeDataOAP=[self.parseClass jsonParsingOAPData];
            [self arrOAP];
            [self orderAndPay];
        }
        [self plotRestoMarkers];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView==self.scrollViewTransit)
    {
        CGFloat width = scrollView.frame.size.width;
        NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
        
        //        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        
        switch (page)
        {/*
          
          case 0:
          [lblRedBorderTransit setBackgroundColor:[UIColor redColor]];
          [lblNearBy setBackgroundColor:[UIColor clearColor]];
          [lblOrderAndPay setBackgroundColor:[UIColor clearColor]];
          if([self.txtFieldDestination.text isEqualToString:@""])
          {
          [self.mapView clear];
          [self plotParkingMarkers];
          [self defaultMarkerParking];
          }
          
          //        if((self.txtFieldDestination.text )&& (self.txtFieldOrigin.text)!=nil)
          else
          {
          [self.mapView clear];
          
          AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
          
          if([appdelegate.transitMode isEqualToString:kTrainTransit])
          {
          [self.btnTrainTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
          }
          else if([appdelegate.transitMode isEqualToString:kCarTransit])
          [self.btnCarTransitref sendActionsForControlEvents:UIControlEventTouchUpInside];
          
          else if([appdelegate.transitMode isEqualToString:kWalking])
          [self.btnWalkTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
          
          else if([appdelegate.transitMode isEqualToString:kBicycleTransit])
          [self.btnBicycleTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
          
          
          }
          break;*/
                
            case 0:
                if(![self.txtFieldDestination.text isEqualToString:@""])
                    [self.mapView clear];
                else
                {
                    [self.mapView clear];
                    [self arrayOfParking];
                    [defaultTableTransit reloadData];
                    [self plotParkingMarkers];
                    [self defaultMarkerParking];
                }
                break;
                
            case 1:
                [lblRedBorderTransit setBackgroundColor:[UIColor clearColor]];
                [lblNearBy setBackgroundColor:[UIColor redColor]];
                [lblOrderAndPay setBackgroundColor:[UIColor clearColor]];
                [self.mapView clear];
                [self plotAtmMarkers];
                break;
            case 2:
                [self.lblRedBorderTransit setBackgroundColor:[UIColor clearColor]];
                [lblNearBy setBackgroundColor:[UIColor clearColor]];
                [lblOrderAndPay setBackgroundColor:[UIColor redColor]];
                [self.mapView clear];
                [self plotRestoMarkers];
                
                break;
                
            default:
                [self.lblRedBorderTransit setBackgroundColor:[UIColor redColor]];
                [lblNearBy setBackgroundColor:[UIColor clearColor]];
                [lblOrderAndPay setBackgroundColor:[UIColor clearColor]];
                
                break;
        }
    }
}
-(NSMutableArray *)arrayLatLong
{
    NSArray *routes=storeData[@"routes"];
    NSArray *legs=routes[0][@"legs"];
    NSArray *steps=legs[0][@"steps"];
    NSString *html;
    NSMutableArray *arrSteps=[[NSMutableArray alloc] init];
    NSMutableArray *latlong=[[NSMutableArray alloc]init];
    NSString *finalString;
    
    for(int i=0; i< [steps count]; i++){
        html=steps[i][@"html_instructions"];
        
        NSString *stringFormatter = [html stringByReplacingOccurrencesOfString:@"[<b>]+[</b>]"
                                                                    withString:@""
                                                                       options:NSRegularExpressionSearch
                                                                         range:NSMakeRange(0, html.length)];
        
        finalString = [stringFormatter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [latlong addObject:steps[i][@"end_location"]];
        [arrSteps addObject:finalString];
    }
    return latlong;
}


-(void)routePlottingBtnClick
{
    CLLocationCoordinate2D location;
    
    
    if([[self.storeData valueForKey:@"routes"] count])
    {
        for (NSDictionary *dictionary in [self arrayLatLong])
        {
            location.latitude = [dictionary[@"lat"] floatValue];
            location.longitude = [dictionary[@"lng"] floatValue];
        }
        
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                                longitude:location.longitude
                                                                     zoom:10];
        self.mapView.camera=camera;
        self.mapView.mapType = kGMSTypeNormal;
        self.mapView.delegate=self;
        
        //     Creates a marker in the center of the map.
        GMSMarker *start_marker = [[GMSMarker alloc] init];
        start_marker.position = CLLocationCoordinate2DMake([[[routeArray firstObject] startLat] doubleValue], [[[routeArray firstObject] startLon] doubleValue]);
        start_marker.map = self.mapView;
        start_marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        
        GMSMarker *end_marker = [[GMSMarker alloc] init];
        end_marker.position = CLLocationCoordinate2DMake([[[routeArray firstObject] endLat] doubleValue], [[[routeArray firstObject] endLon] doubleValue]);
        end_marker.map = self.mapView;
        
//        AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        
    }
    
}


-(void) updateCurrentLocationAnim
{
    
    static int i = 0;
    if(gpxCount < markerLocation.count)
    {
        NSDictionary *dictionary = markerLocation[gpxCount];
        CLLocationCoordinate2D location;
        location.latitude = [dictionary[@"latitude"] floatValue];
        location.longitude = [dictionary[@"longitude"] floatValue];
        // Creates a marker in the center of the map.
        
        markerAnim.icon = [UIImage imageNamed:@"current-location.png"];
        
        markerAnim.title = @"";
        
        markerAnim.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        gpxCount++;
    }
    
}
-(NSMutableArray *)decodePolyLine:(NSString *)encodedStr {
    
    NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
    NSMutableDictionary *latLongDictionary=[[NSMutableDictionary alloc]init];
    
    NSMutableArray *arrLatLong=[[NSMutableArray alloc]init];
    [encoded appendString:encodedStr];
    
    [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                                options:NSLiteralSearch
                                  range:NSMakeRange(0, [encoded length])];
    NSInteger len = [encoded length];
    NSInteger index = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSInteger lat=0;
    NSInteger lng=0;
    while (index < len) {
        NSInteger b;
        NSInteger shift = 0;
        NSInteger result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lat += dlat;
        shift = 0;
        result = 0;
        do {
            b = [encoded characterAtIndex:index++] - 63;
            result |= (b & 0x1f) << shift;
            shift += 5;
        } while (b >= 0x20);
        NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
        lng += dlng;
        NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
        NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
        
        latLongDictionary=[[NSMutableDictionary alloc]initWithObjectsAndKeys:latitude,@"latitude",longitude,@"longitude", nil];
        [arrLatLong addObject:latLongDictionary];
    }
    return arrLatLong;
}
/******************************** Route Plotting Function **************************/

-(void)routePlotting:(int)count
{
    NSError *error=nil;
    pathArray = [[NSMutableArray alloc] init];
    if (!error) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            for(int i=0;i<[routeArray count];i++)
            {
                Route *rt = [routeArray objectAtIndex:i];
                NSString *strEncodedPath= [rt points];
                GMSPath *path=[GMSPath pathFromEncodedPath:strEncodedPath];
                GMSPolyline *polyline = [[GMSPolyline alloc] init];
                polyline=[GMSPolyline polylineWithPath:path];
                [polyline setTappable:TRUE];
                
                if(i==0)
                {
                    polyline.strokeColor=[UIColor redColor];
                    polyline.strokeWidth=4;
                    
                    selectedPolyline = polyline;
                    polyline.title=@"0";
                }
                else
                {
                    polyline.strokeColor=[UIColor grayColor];
                    polyline.strokeWidth=2;
                    polyline.title = [NSString stringWithFormat:@"%d",i ];
                }
                
                polyline.map=self.mapView;
                
                [pathArray addObject:polyline];
                
                
            }
            
        }];
        
        
    }
    
}

#pragma  mark- Route Plotting Buttons
- (IBAction)btnTrainTransit:(id)sender {
    
    
    if(self.txtFieldDestination.text.length==0)
    {
        defaultTableTransit.hidden=FALSE;
    }
    [self performSelector:@selector(plotTrainRoute) withObject:nil afterDelay:4.0];
    
    
    [activity startAnimating];
}

-(void) plotTrainRoute
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    
    if(networkStatus != NotReachable)
    {
        [self.txtFieldOrigin resignFirstResponder];
        [self.txtFieldDestination resignFirstResponder];
        
        [self hideOriginDestFields];
        
        [stepView removeFromSuperview];
        stepTableView = nil;
        pathArray=nil;
        [self.mapView clear];
        
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.transitMode=kTrainTransit;
        
        
        
        [self.btnTrainTransitRef setBackgroundImage:[UIImage imageNamed:@"train_on.png"] forState:UIControlStateNormal];
        [self.btnCarTransitref setBackgroundImage:[UIImage imageNamed:@"car_off.png"] forState:UIControlStateNormal];
        [self.btnBicycleTransitRef setBackgroundImage:[UIImage imageNamed:@"bike_off.png"] forState:UIControlStateNormal];
        [self.btnWalkTransitRef setBackgroundImage:[UIImage imageNamed:@"walk_off.png"] forState:UIControlStateNormal];
        
        
        //*************************** Setting location of origin  as current Location *********************//
        
        if ([self.txtFieldOrigin.text length]==0 || [self.txtFieldOrigin.text isEqualToString:@"Current Location"])
        {
            
            if(addressString != nil)
                appDelegate.origin1=addressString;
            if(self.txtFieldDestination.text != nil)
                appDelegate.destination1=self.txtFieldDestination.text;
        }
        else
        {
            appDelegate.origin1=self.txtFieldOrigin.text;
            appDelegate.destination1=self.txtFieldDestination.text;
            
        }
        
        
        [self transitImageChange:0];
        
        
        storeData=[[NSDictionary alloc]init];
        self.parseClass = [[JsonParsing alloc]init];
        self.storeData = [self.parseClass simpleJsonParsing];
        
        if(self.txtFieldDestination.text.length==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([[self.storeData valueForKey:@"routes"] count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No routes found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        
        }
        else
        {
            [self createTransitData];
            [self routePlottingBtnClick];
            
          
            [self routePlotting:1];
            
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        
        [alert show];
    }
    
    [activity stopAnimating];
    
    if((self.txtFieldDestination.text.length!=0) && (self.txtFieldOrigin.text.length!=0))
    {
        self.transitTbl.hidden=FALSE;
        
    }
    self.scrollViewTransit.contentOffset = CGPointMake(0, 0);
    self.btnTransitRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
    self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    btnOrderAndPayisTapped = FALSE;
}


- (IBAction)btnCarTransit:(id)sender {
    
    if(self.txtFieldDestination.text.length==0)
    {
        defaultTableTransit.hidden=FALSE;
    }
    
    [self performSelector:@selector(plotCarRoute) withObject:nil afterDelay:4.0];
    [activity startAnimating];
}

-(void) plotCarRoute
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if(networkStatus != NotReachable)
    {
        [self.txtFieldOrigin resignFirstResponder];
        [self.txtFieldDestination resignFirstResponder];
        
        [self hideOriginDestFields];
        
        [stepView removeFromSuperview];
        
        stepTableView = nil;
        pathArray=nil;
        [self.mapView clear];
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.transitMode=kCarTransit;
        
        if ([self.txtFieldOrigin.text length]==0 || [self.txtFieldOrigin.text isEqualToString:@"Current Location"])
        {
            
            if(addressString != nil)
                appDelegate.origin1=addressString;
            if(self.txtFieldDestination.text != nil)
                appDelegate.destination1=self.txtFieldDestination.text;
        }
        else
        {
            appDelegate.origin1=self.txtFieldOrigin.text;
            appDelegate.destination1=self.txtFieldDestination.text;
            
        }
        
        [self transitImageChange:1];
        storeData=[[NSDictionary alloc]init];
        self.parseClass = [[JsonParsing alloc]init];
        self.storeData = [self.parseClass simpleJsonParsing];
        if(self.txtFieldDestination.text.length==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([[self.storeData valueForKey:@"routes"] count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No routes found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }

        else
        {
            //        if ([self arrayLatLong].count!=0) {
            //            [self routePlottingBtnClick];
            //
            //        }
            
            [self createTransitData];
            [self routePlottingBtnClick];
            [self routePlotting:2];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        
        [alert show];
    }
    [activity stopAnimating];
    
    if((self.txtFieldDestination.text.length!=0) && (self.txtFieldOrigin.text.length!=0))
    {
        self.transitTbl.hidden=FALSE;
        
    }
    self.scrollViewTransit.contentOffset = CGPointMake(0, 0);
    self.btnTransitRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
    self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    btnOrderAndPayisTapped = FALSE;

}

- (IBAction)btnWalkTransit:(id)sender {
    
    if(self.txtFieldDestination.text.length==0)
    {
        defaultTableTransit.hidden=FALSE;
    }
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate NetworkStatus];
    
    [self performSelector:@selector(plotWalkRoute) withObject:nil afterDelay:4.0];
    [activity startAnimating];
}

-(void) plotWalkRoute
{
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    
    if(networkStatus != NotReachable)
    {
        [self.txtFieldOrigin resignFirstResponder];
        [self.txtFieldDestination resignFirstResponder];
        
        [self hideOriginDestFields];
        
        [stepView removeFromSuperview];
        stepTableView = nil;
        pathArray=nil;
        [self.mapView clear];
        
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.transitMode=kWalking;
        
        if ([self.txtFieldOrigin.text length]==0 || [self.txtFieldOrigin.text isEqualToString:@"Current Location"])
        {
            
            if(addressString != nil)
                appDelegate.origin1=addressString;
            if(self.txtFieldDestination.text != nil)
                appDelegate.destination1=self.txtFieldDestination.text;
        }
        else
        {
            appDelegate.origin1=self.txtFieldOrigin.text;
            appDelegate.destination1=self.txtFieldDestination.text;
            
        }
        
        [self transitImageChange:2];
        
        storeData=[[NSDictionary alloc]init];
        self.parseClass = [[JsonParsing alloc]init];
        self.storeData = [self.parseClass simpleJsonParsing];
        if(self.txtFieldDestination.text.length==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([[self.storeData valueForKey:@"routes"] count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No routes found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }
        else
        {
            
            
            [self createTransitData];
            [self routePlottingBtnClick];
            [self routePlotting:0];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        
        [alert show];
    }
    [activity stopAnimating];
    if((self.txtFieldDestination.text.length!=0) && (self.txtFieldOrigin.text.length!=0))
    {
        self.transitTbl.hidden=FALSE;
        
    }
    self.scrollViewTransit.contentOffset = CGPointMake(0, 0);
    self.btnTransitRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
    self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    btnOrderAndPayisTapped = FALSE;

}

- (IBAction)btnCycleTransit:(id)sender {
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate NetworkStatus];
    
    if(self.txtFieldDestination.text.length==0)
    {
        defaultTableTransit.hidden=FALSE;
    }
    [self performSelector:@selector(plotCycleRoute) withObject:nil afterDelay:4.0];
    [activity startAnimating];
}

-(void) plotCycleRoute
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    
    
    if(networkStatus != NotReachable)
    {
        [self.txtFieldOrigin resignFirstResponder];
        [self.txtFieldDestination resignFirstResponder];
        
        [self hideOriginDestFields];
        
        [stepView removeFromSuperview];
        stepTableView = nil;
        pathArray=nil;
        [self.mapView clear];
        
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        appDelegate.transitMode=kBicycleTransit;
        
        
        [self transitImageChange:3];
        
        if ([self.txtFieldOrigin.text length]==0 || [self.txtFieldOrigin.text isEqualToString:@"Current Location"])
        {
            
            if(addressString != nil)
                appDelegate.origin1=addressString;
            if(self.txtFieldDestination.text != nil)
                appDelegate.destination1=self.txtFieldDestination.text;
        }
        else
        {
            appDelegate.origin1=self.txtFieldOrigin.text;
            appDelegate.destination1=self.txtFieldDestination.text;
            
        }
        storeData=[[NSDictionary alloc]init];
        self.parseClass = [[JsonParsing alloc]init];
        self.storeData = [self.parseClass simpleJsonParsing];
        if(self.txtFieldDestination.text.length==0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else if ([[self.storeData valueForKey:@"routes"] count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No routes found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            
        }

        else
        {
            //        if ([self arrayLatLong].count!=0) {
            //            [self routePlottingBtnClick];
            //
            //        }
            
            [self createTransitData];
            [self routePlottingBtnClick];
            [self routePlotting:1];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        
        [alert show];
    }
    [activity stopAnimating];
    
    if((self.txtFieldDestination.text.length!=0) && (self.txtFieldOrigin.text.length!=0))
    {
        self.transitTbl.hidden=FALSE;
        
    }
    self.scrollViewTransit.contentOffset = CGPointMake(0, 0);
    self.btnTransitRef.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]; //light orange
    self.btnNearByRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    self.btnOAPRef.backgroundColor=[UIColor colorWithRed:245.0/255.0 green:133.0/255.0 blue:2.0/255.0 alpha:1.0]; //dark orange
    btnOrderAndPayisTapped = FALSE;

}

- (void) mapView:(GMSMapView *) mapView didTapOverlay:(GMSOverlay *) overlay
{
    GMSPolyline *polyline = (GMSPolyline*)overlay;
    
    for(GMSPolyline *pl in pathArray)
    {
        pl.strokeColor = [UIColor grayColor];
        pl.strokeWidth = 2.0f;
    }
    
    polyline.strokeColor=[UIColor redColor];
    polyline.strokeWidth=4;
    
    selectedPolyline = polyline;
    
    
    //Logic to show setp view on route selection on map
    int routeTag = [polyline.title intValue];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:routeTag inSection:0];
    selectedIp=ip;
    //    if(!stepView)
    //          stepView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, self.sliderView.frame.size.width, self.sliderView.frame.size.height-512)];
    
    if(!stepView)
    {
        
        if(isSlideViewUp)
            stepView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, self.sliderView.frame.size.width, 550)];
        else
            stepView = [[UIView alloc] initWithFrame:CGRectMake(0, 52, self.sliderView.frame.size.width, self.sliderView.frame.size.height-512)];
        
    }
    
    CGRect stepFrame = [stepView frame];
    stepFrame.origin.y = 52.0;
    stepView.frame = stepFrame;
    
    [stepView setBackgroundColor:[UIColor yellowColor]];
    
    //[transitTbl setHidden:YES];
    [defaultTableTransit setHidden:YES];
    //selectedIp = indexPath;
    [self.sliderView addSubview:stepView];
    [self setUpStepView];
    
}

- (IBAction)addEvent:(id)sender {
    if (!isSlideViewUp)
    {
        
        eventView = [[UIView alloc] initWithFrame:CGRectMake(90,78,250,310)];
        
        UILabel *setLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, 200, 30)];
        setLbl.text = @"Set Date and Time";
        [setLbl setTextColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0]];
        
        UIPickerView *timePkr =[[UIPickerView alloc] initWithFrame:CGRectMake(80, 30, 110, 50)];
        timePkr.delegate=self;
        timePkr.dataSource=self;
        
        
        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 250, 80, 30)];
        [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(removeEventView) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(160, 250, 50, 30)];
        [okBtn setTitle:@"OK" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
        [okBtn addTarget:self action:@selector(removeEventView) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        [eventView setBackgroundColor:[UIColor whiteColor]];
        [eventView addSubview:setLbl];
        [eventView addSubview:cancelBtn];
        [eventView addSubview:okBtn];
        [eventView addSubview:timePkr];
        [self.view addSubview:eventView];
    }
}

-(void) removeEventView
{
    [eventView removeFromSuperview];
}

-(void) displayDateView
{
    [eventView removeFromSuperview];
    datePickerView = [[UIView alloc] initWithFrame:CGRectMake(30,80,350,320)];
    [datePickerView setBackgroundColor:[UIColor whiteColor]];
    
    datelabel = [[UILabel alloc] init];
    datelabel.frame = CGRectMake(10, 10, 300, 40);
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.textColor = [UIColor blackColor];
    datelabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 14.0];
    datelabel.textAlignment = NSTextAlignmentLeft;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = kCFDateFormatterFullStyle;
    datelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:[NSDate date]]];
    
    [datePickerView addSubview:datelabel];
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, 300, 200)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    [datePicker addTarget:self
                   action:@selector(LabelChange:)
         forControlEvents:UIControlEventValueChanged];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(90, 270, 80, 30)];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeDateView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(220, 270, 60, 30)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(displayTimeView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [datePickerView addSubview:datePicker];
    [datePickerView addSubview:cancelBtn];
    [datePickerView addSubview:okBtn];
    [self.view addSubview:datePickerView];
    
}
- (void)LabelChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = kCFDateFormatterFullStyle;
    datelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
}

-(void) removeDateView
{
    [datePickerView removeFromSuperview];
}

-(void) displayTimeView
{
    [datePickerView removeFromSuperview];
    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(50,80,320,320)];
    [timePickerView setBackgroundColor:[UIColor whiteColor]];
    
    timelabel = [[UILabel alloc] init];
    timelabel.frame = CGRectMake(10, 10, 300, 40);
    timelabel.backgroundColor = [UIColor clearColor];
    timelabel.textColor = [UIColor blackColor];
    timelabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 14.0];
    timelabel.textAlignment = NSTextAlignmentLeft;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    timelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:[NSDate date]]];
    
    [timePickerView addSubview:timelabel];
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, 300, 200)];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.hidden = NO;
    timePicker.date = datePicker.date;
    [timePicker addTarget:self
                   action:@selector(timeLabelChange)
         forControlEvents:UIControlEventValueChanged];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 270, 80, 30)];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeTimeView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 270, 60, 30)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [okBtn addTarget:self action:@selector(createEvent) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [timePickerView addSubview:cancelBtn];
    [timePickerView addSubview:okBtn];
    [timePickerView addSubview:timePicker];
    [self.view addSubview:timePickerView];
}

-(void) timeLabelChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    timelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:timePicker.date]];
}

-(void) removeTimeView
{
    [timePickerView removeFromSuperview];
}

-(void) createEvent
{
    //Create an Event in the Calender here..
    
    EKEventStore *store = [EKEventStore new];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if (!granted) { return; }
        
        EKEvent *event = [EKEvent eventWithEventStore:store];
        event.title = @"Event Title";
        
        event.startDate = datePicker.date;
        
        
        event.endDate = [event.startDate dateByAddingTimeInterval:60*60];  //set 1 hour meeting
        event.calendar = [store defaultCalendarForNewEvents];
        
        EKAlarm *date;
        
        date= [[EKAlarm alarmWithRelativeOffset:60]init];
        
        [date setAbsoluteDate:timePicker.date];
        
        [event addAlarm:date];
        
        
        
        NSError *err = nil;
        [store saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        // self.savedEventId = event.eventIdentifier;  //save the event id if you want to access this later
    }];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Event added successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [timePickerView removeFromSuperview];
    [datePickerView removeFromSuperview];
    
}
#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 80.0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,60,40)];
    UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    switch (row)
    {
        case 0:viewLabel.text = @"Leave Now";
            break;
        case 1:viewLabel.text = @"Leave At";
            break;
        case 2:viewLabel.text = @"Arrive By";
            break;
    }
    
    return viewLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if(row ==1 || row == 2)
    {
        [self displayDateView];
    }
}


//******************** Vaibhav changes ***********//


-(void) ReverseJrny {
    
    
    [self.txtFieldOrigin resignFirstResponder];
    [self.txtFieldDestination resignFirstResponder];
    
    [self hideOriginDestFields];
    
    [stepView removeFromSuperview];
    stepTableView = nil;
    pathArray=nil;
    [self.mapView clear];
    
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    if ((appDelegate.origin1 != nil)&& (appDelegate.destination1 != nil)) {
        
        NSString *tempString = appDelegate.origin1;
        appDelegate.origin1 = appDelegate.destination1;
        appDelegate.destination1 = tempString;
        
        [self.txtFieldOrigin setText:appDelegate.origin1];
        [self.txtFieldDestination setText:appDelegate.destination1];
        
        if ([appDelegate.transitMode isEqual:kTrainTransit] )
            [self transitImageChange:0];
        
        if ([appDelegate.transitMode isEqual:kCarTransit] )
            [self transitImageChange:1];
        
        if ([appDelegate.transitMode isEqual:kWalking] )
            [self transitImageChange:2];
        
        if ([appDelegate.transitMode isEqual:kBicycleTransit] )
            [self transitImageChange:3];
        
        
        storeData=[[NSDictionary alloc]init];
        self.parseClass = [[JsonParsing alloc]init];
        self.storeData = [self.parseClass simpleJsonParsing];
        if([[self.storeData valueForKey:@"routes"] count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else{
            if ([self arrayLatLong].count!=0)
                [self routePlottingBtnClick];
        }
        
        [self createTransitData];
        
        if ([appDelegate.transitMode isEqual:kTrainTransit] )
            [self routePlotting:1];
        
        if ([appDelegate.transitMode isEqual:kCarTransit] )
            [self routePlotting:2];
        
        if ([appDelegate.transitMode isEqual:kWalking] )
            [self routePlotting:0];
        
        if ([appDelegate.transitMode isEqual:kBicycleTransit] )
            [self routePlotting:1];
        
    }else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        
        [alert show];
        
    }
}

-(void) transitImageChange: (int)transitMode {
    
    switch (transitMode) {
        case 0:
            
            [self.btnTrainTransitRef setImage:[UIImage imageNamed:@"train_on.png"] forState:UIControlStateNormal];
            [self.btnCarTransitref setImage:[UIImage imageNamed:@"car_off.png"] forState:UIControlStateNormal];
            [self.btnBicycleTransitRef setImage:[UIImage imageNamed:@"bike_off.png"] forState:UIControlStateNormal];
            [self.btnWalkTransitRef setImage:[UIImage imageNamed:@"walk_off.png"] forState:UIControlStateNormal];
            
            break;
            
        case 1:
            
            [self.btnTrainTransitRef setImage:[UIImage imageNamed:@"train_off.png"] forState:UIControlStateNormal];
            [self.btnCarTransitref setImage:[UIImage imageNamed:@"car_on.png"] forState:UIControlStateNormal];
            [self.btnBicycleTransitRef setImage:[UIImage imageNamed:@"bike_off.png"] forState:UIControlStateNormal];
            [self.btnWalkTransitRef setImage:[UIImage imageNamed:@"walk_off.png"] forState:UIControlStateNormal];
            
            break;
            
        case 2:
            [self.btnTrainTransitRef setImage:[UIImage imageNamed:@"train_off.png"] forState:UIControlStateNormal];
            [self.btnCarTransitref setImage:[UIImage imageNamed:@"car_off.png"] forState:UIControlStateNormal];
            [self.btnBicycleTransitRef setImage:[UIImage imageNamed:@"bike_off.png"] forState:UIControlStateNormal];
            [self.btnWalkTransitRef setImage:[UIImage imageNamed:@"walk_on.png"] forState:UIControlStateNormal];
            
            break;
            
        case 3:
            [self.btnTrainTransitRef setImage:[UIImage imageNamed:@"train_off.png"] forState:UIControlStateNormal];
            [self.btnCarTransitref setImage:[UIImage imageNamed:@"car_off.png"] forState:UIControlStateNormal];
            [self.btnBicycleTransitRef setImage:[UIImage imageNamed:@"bike_on.png"] forState:UIControlStateNormal];
            [self.btnWalkTransitRef setImage:[UIImage imageNamed:@"walk_off.png"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

//********************** Kindly check the function  as this is giving error while merging on line number 3709 hided that line only *************
- (void)showGpx {
    
    pageLoaded = TRUE;
    
    //For Testing decoding polyline code
    [customAlertview removeFromSuperview];
    transitMenuView = nil;
    
    [self cancelCabRequest];
    
    if ((self.txtFieldOrigin.text.length != 0)&& (self.txtFieldDestination.text.length != 0)) {
        [self.mapView clear];
        markerLocation = [[NSArray alloc] init];
        markerLocation =[self decodePolyLine:[[selectedPolyline path] encodedPath]];
        
        markerAnim = [[GMSMarker alloc] init];
        markerAnim.map = self.mapView;
        gpxCount=0;
        timer = [NSTimer scheduledTimerWithTimeInterval:0.5f
                                         target:self
                                       selector:@selector(updateCurrentLocationAnim)
                                       userInfo:nil
                                        repeats:YES];
        
        
        GMSPath *path=[selectedPolyline path];
        self.polyline=[GMSPolyline polylineWithPath:path];
        self.polyline.strokeWidth=4;
        self.polyline.strokeColor=[UIColor blueColor];
        self.polyline.map=self.mapView;
        
        //create marker for start and end location
        
        GMSMarker *start_marker = [[GMSMarker alloc] init];
        start_marker.position = CLLocationCoordinate2DMake([[[routeArray firstObject] startLat] doubleValue], [[[routeArray firstObject] startLon] doubleValue]);
        start_marker.map = self.mapView;
        start_marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        
        GMSMarker *end_marker = [[GMSMarker alloc] init];
        end_marker.position = CLLocationCoordinate2DMake([[[routeArray firstObject] endLat] doubleValue], [[[routeArray firstObject] endLon] doubleValue]);
        end_marker.map = self.mapView;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please choose origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void) saveMap {
    
    CGRect rect = CGRectMake(0, 0, 375, 459);
    
    _myView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, 459)];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    rect = [_myView bounds];
    
    
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    [_myView.layer renderInContext:context];
    capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    if (capturedScreen != NULL) {
        UIImageWriteToSavedPhotosAlbum(capturedScreen, nil, nil, nil);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Map is saved in Album" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    
}

-(void) shareMap {
    
    
    _myView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 375, 459)];
    
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [_myView bounds];
    
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    //    [_myView.layer renderInContext:context];
    capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray *objectsToShare = [[NSArray alloc] initWithObjects:capturedScreen, nil];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    shareController.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypePostToWeibo,UIActivityTypePostToFlickr, UIActivityTypePostToVimeo,UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList];
    
    shareController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController isKindOfClass:[TransitViewController class]])
    {
        [topController presentViewController:shareController animated:YES completion:nil];
        
    }
}


-(void) createTransitData
{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    tempArray = [storeData valueForKey:@"routes"];
    
    [routeArray removeAllObjects];
    for(int i=0; i<[tempArray count]; i++)
    {
        Route *route = [[Route alloc] init];
        NSDictionary *legDict = [[[tempArray objectAtIndex:i] valueForKey:@"legs"] objectAtIndex:0];
        
        
        route.arrival_time = [[legDict valueForKey:@"arrival_time"] valueForKey:@"text"];
        route.dep_time = [[legDict  valueForKey:@"departure_time"] valueForKey:@"text"];
        route.distance = [[legDict  valueForKey:@"distance"] valueForKey:@"text"];
        route.routeDuration =  [[legDict  valueForKey:@"duration"] valueForKey:@"text"];
        route.endAddress = [legDict valueForKey:@"end_address"];
        route.startAddress = [legDict  valueForKey:@"start_address"];
        
        route.startLat = [[legDict  valueForKey:@"start_location"] valueForKey:@"lat"];
        route.startLon = [[legDict  valueForKey:@"start_location"] valueForKey:@"lng"];
        
        route.endLat = [[legDict  valueForKey:@"end_location"] valueForKey:@"lat"];
        route.endLon = [[legDict  valueForKey:@"end_location"] valueForKey:@"lng"];
        route.points = [[[tempArray objectAtIndex:i] valueForKey:@"overview_polyline"] valueForKey:@"points"];
        
        //route.short_Name=
        NSMutableArray *stepArray = [[NSMutableArray alloc] init];
        stepArray = [legDict valueForKey:@"steps"];

        route.num_of_steps = [stepArray count];
        route.step_arr = [self constructSubStep:stepArray withCount:route.num_of_steps];
        
        
        [routeArray addObject:route];
    }
    [transitTbl reloadData];
    
    [self.scrollViewTransit sendSubviewToBack:defaultTableTransit];
    
}

-(NSMutableArray*) constructSubStep:(NSArray*) subStepArr withCount:(long) subStepCount
{
    // if(![[subStepArr objectAtIndex:0] valueForKey:@"steps"])
    //    return nil;
    NSMutableArray *stepArray = [[NSMutableArray alloc] init];
    
    for(int step_count=0; step_count < [subStepArr count];step_count++)
    {
        Steps *step = [[Steps alloc] init];
        
        
        step.distance = [[[subStepArr objectAtIndex:step_count] valueForKey:@"distance"] valueForKey:@"text"];
        step.duration = [[[subStepArr objectAtIndex:step_count] valueForKey:@"duration"] valueForKey:@"text"];
        
        
        step.instruction = [[subStepArr objectAtIndex:step_count] valueForKey:@"html_instructions"];
        
        if([[[subStepArr objectAtIndex:step_count] valueForKey:@"travel_mode"] isEqualToString:@"WALKING"])
            step.tm = walking;
        else if ([[[subStepArr objectAtIndex:step_count] valueForKey:@"travel_mode"] isEqualToString:@"TRANSIT"])
            step.tm = transit;
        
        if(![[subStepArr objectAtIndex:step_count ] valueForKey:@"steps"])
            step.subStep=nil;
        else
        {
            step.step_arr = [self constructSubStep:[[subStepArr objectAtIndex:step_count] valueForKey:@"steps"] withCount:1];
        }
        
        //Transit Details
        TransitDetail *td = [[TransitDetail alloc] init];
        td.arrStopName = [[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"arrival_stop"] valueForKey:@"name"];
        td.arrTime = [[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"arrival_time"] valueForKey:@"text"];
        td.depStopName = [[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"departure_stop"] valueForKey:@"name"];
        td.depTime = [[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"departure_time"] valueForKey:@"text"];
        td.lineName =[[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"name"];
        td.lineAgencyName = [[[[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"agencies"] objectAtIndex:0] valueForKey:@"name"];
        td.numStop = [[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"num_stops"] stringValue];
        
        td.headSign = [[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"headsign"];
        td.short_name = [[[[subStepArr objectAtIndex:step_count] valueForKey:@"transit_details"] valueForKey:@"line"] valueForKey:@"short_name"];
    
        
        step.transtDtls = td;
        [stepArray addObject:step];
    }
    return stepArray;
}

-(NSString *)convertHTML:(NSString *)html {
    
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

- (IBAction)showRouteBtnClicked:(id)sender {
    if (isSlideViewUp == FALSE) {
        self.txtFieldOrigin.hidden = NO;
        self.txtFieldDestination.hidden = NO;
        self.modeOfTransportView.hidden = NO;
        
        CGRect tempFrame = self.modeOfTransportView.frame;
        tempFrame.origin.y = 130;
        self.modeOfTransportView.frame = tempFrame;
    }
}

- (void) hideOriginDestFields {
    self.txtFieldOrigin.hidden = YES;
    self.txtFieldDestination.hidden = YES;
    
    [self.modeOfTransportView setFrame:CGRectMake(self.modeOfTransportView.frame.origin.x, 65, self.modeOfTransportView.frame.size.width, self.modeOfTransportView.frame.size.height)];
}

-(void)arrOAP
{
    NSArray *results=storeDataOAP[@"results"];
    
    for(int i=0;i<[results count];i++)
    {
        Restaurant *resto = [[Restaurant alloc] init];
        resto.name = [[results objectAtIndex:i] valueForKey:@"name"];
        resto.lat = [[[[results objectAtIndex:i] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lat"] ;
        resto.lon = [[[[results objectAtIndex:i] valueForKey:@"geometry"] valueForKey:@"location"] valueForKey:@"lng"];
        
        resto.address = [[results objectAtIndex:i] valueForKey:@"vicinity"];
        resto.iconUrl = [[results objectAtIndex:i] valueForKey:@"icon"];
        
        [restoArray addObject:resto];
    }
    
}

-(void) saveInCustomFile
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserInfo1.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"UserInfo1.plist"] ];
    }
    [data writeToFile: path atomically:YES];
    
}
- (IBAction)btnHelpCenter:(id)sender {
    isHelpCenterViewPresented=@"YES";
    [data setObject:isHelpCenterViewPresented forKey:@"isHelpCenterViewPresented"];
    [self saveInCustomFile];
    viewHelpCenter.hidden = TRUE;
    
}
@end

