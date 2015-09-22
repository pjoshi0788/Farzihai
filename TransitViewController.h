//
//  TransitViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/5/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <GoogleMaps/GoogleMaps.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "MenuView.h"
#import "Route.h"
#import "Steps.h"
#import "Atm.h"
#import "Restaurant.h"
#import "Parking.h"
#import "TravelNoticeViewController.h"



@interface TransitViewController : UIViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,GMSMapViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    CLLocationManager *locationManager;
    float start;
    float now;
    BOOL directionUp;
 
    MenuView *transitMenuView;
    
    UITableView *tableViewOrigin,*tableViewDest;
    
    NSMutableArray *tableData;//will be storing data that will be displayed in table
    NSMutableArray *result,*arrDataTransit,*arrDataTransitDuration;
    NSDictionary *locationDictionary;
    
    UIView *eventView;
    
    UIDatePicker *datePicker;
    UIDatePicker *timePicker;
    
    UILabel *datelabel;
    UIView *datePickerView;
    
   
    UILabel *timelabel;
    UIView *timePickerView;
    UIView *customAlertview;
    UIView *headViewCustomAlertView;
    UIView *alertTitle;
    
    UIView *stepView;
    UITableView *stepTableView;
    
    NSIndexPath *selectedIp;
    
    NSMutableArray *currStepArr;
    NSMutableArray *pathArray;
    
    NSMutableArray *atmArray;
 
    NSMutableArray *restoArray;
    NSMutableArray *parkingArray;
    
    UIActivityIndicatorView *activity;
    
    GMSPolyline *selectedPolyline;
    
    int gpxCount;
    BOOL isSlideViewUp;
}

@property (nonatomic, retain) NSMutableDictionary *data;
@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
//@property (weak, nonatomic) IBOutlet UITableView *tblDefaultTransit;
@property (weak, nonatomic) IBOutlet UIButton *btnHelpCenterRef;
@property (weak, nonatomic) IBOutlet UIView *viewHelpCenter;
- (IBAction)btnHelpCenter:(id)sender;


@property (nonatomic, assign) bool isFiltered;
@property (strong,nonatomic) NSMutableArray *arrline1,*arrline2,*arrCity,*arrZipCode;
@property (strong,nonatomic) NSMutableArray *arrFinalLine1,*arrFinalLine2,*arrFinalCity,*arrFinalZipCode,*arrFinalATMName,*arrFinalMilesNumber;
@property (weak, nonatomic) IBOutlet UIView *sliderView;
@property (weak, nonatomic) IBOutlet UIView *sliderHdrView;
@property (weak, nonatomic) IBOutlet UITextField *txtFieldOrigin;

@property (strong, nonatomic) SidebarViewController *sideBarViewController;
- (IBAction)toggleView:(id)sender;
- (IBAction)showMenu:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *txtFieldDestination;
@property (weak, nonatomic) IBOutlet UILabel *lblRedBorderTransit;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewTransit;

- (IBAction)btnTransitOptn:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lblNearBy;

@property (weak, nonatomic) IBOutlet UILabel *lblOrderAndPay;
@property (weak,nonatomic) NSString *strOrigin,*strDest;

@property (retain,nonatomic) NSString *strEncodedPath, *addressString;;
@property(nonatomic,retain) NSDictionary *userinfo_dic;
- (IBAction)btnTrainTransit:(id)sender;

- (IBAction)btnCarTransit:(id)sender;
- (IBAction)btnWalkTransit:(id)sender;


- (IBAction)btnCycleTransit:(id)sender;
- (IBAction)addEvent:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblRoutePlot;
@property (weak, nonatomic) IBOutlet UITableView *transitTbl;
@property (weak, nonatomic) IBOutlet UIView *lblTransitModeBar;

@property (strong, nonatomic) IBOutlet UIView *myView;
@property (strong, nonatomic) UITableView *defaultTableTransit;

@property (strong, nonatomic) UITableView *tableViewNearBy;
@property (strong, nonatomic) IBOutlet UIButton *btnTrainTransitRef;
@property (strong, nonatomic) IBOutlet UIButton *btnCarTransitref;
@property (strong, nonatomic) IBOutlet UIButton *btnWalkTransitRef;
@property (strong, nonatomic) IBOutlet UIButton *btnBicycleTransitRef;



- (IBAction)showGpx:(id)sender;
-(void) saveMap;
-(void) shareMap;
-(void) ReverseJrny;
-(void)TravelNotice;
-(void)startDemo;
-(void)FaceBookNotice;
-(void) carRentalNotice;
-(void) pricelessOfferView;
-(void) parkViewNotice;
-(void) MeetingNotice;
-(void)Ordernow;
-(void) shareJourney;
-(void)reloadTransitPage;
-(void) arrayOfParking;
-(void)createTransitData;
-(void)routePlottingBtnClick;
-(void)routePlotting:(int)count;


@property (weak, nonatomic) IBOutlet UIButton *btnTransitRef;

@property (weak, nonatomic) IBOutlet UIButton *btnNearByRef;
@property (weak, nonatomic) IBOutlet UIButton *btnOAPRef;

-(NSMutableArray *)arrayLatLong;
@end
