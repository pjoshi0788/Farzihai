//
//  TimeTableViewController.h
//  MastercardFinal
//
//  Created by administrator on 28/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Route.h"
#import "JsonParsing.h"
@interface TimeTableViewController : UIViewController<UIScrollViewDelegate,JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,GMSMapViewDelegate,CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *timeTableMapView;

@property (strong, nonatomic) SidebarViewController *sideBarViewController;

- (IBAction)SideBarButton:(id)sender;

- (IBAction)TabBtns:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *RouteBtn;
@property (weak, nonatomic) IBOutlet UIView *RouteBtnIndicator;

@property (weak, nonatomic) IBOutlet UIButton *FavoritesBtn;
@property (weak, nonatomic) IBOutlet UIView *FavoritesBtnIndicator;

@property (weak, nonatomic) IBOutlet UIButton *MapBtn;
@property (weak, nonatomic) IBOutlet UIView *MapBtnIndicator;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


- (IBAction)StationDropDown:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *OriginDropDownBtnReference;
@property (weak, nonatomic) IBOutlet UIButton *DestinationDropDownBtnReference;
@property (weak, nonatomic) IBOutlet UIButton *TransitTypeDropDownReference;

@property (weak, nonatomic) IBOutlet UIButton *DateBtnReference;
@property (weak, nonatomic) IBOutlet UIButton *TimeBtnReference;

- (IBAction)DepartSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *DepartSwitchReference;

- (IBAction)ArriveSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *ArriveSwitchReference;

@property (weak, nonatomic) IBOutlet UILabel *FavouriteLabel;
@property (strong, nonatomic) NSDictionary *storeData;
@property (strong, nonatomic) JsonParsing *parseClass;
- (IBAction)SetDateTimeBtn:(id)sender;

- (IBAction)GetScheduleBtn:(id)sender;


@end
