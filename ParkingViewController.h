//
//  ParkingViewController.h
//  MastercardFinal
//
//  Created by administrator on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface ParkingViewController : UIViewController<JTRevealSidebarV2Delegate, SidebarViewControllerDelegate, UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    MenuView *transitMenuView;
}

@property (weak, nonatomic) IBOutlet UILabel *ParkingPlaceTitle;
@property (strong, nonatomic) NSString *ParkingPlaceTitleText;


@property (weak, nonatomic) IBOutlet UILabel *ParkingPlaceAddress;
@property (strong, nonatomic) NSString *ParkingPlaceAddressText;


- (IBAction)DurationPickerControllerBtn:(id)sender;

- (IBAction)PayWithMasterPass:(id)sender;
- (IBAction)PayAtRentalCounter:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *PayWithMasterPassReference;
@property (weak, nonatomic) IBOutlet UISwitch *PayWithRentalCounterReference;


- (IBAction)CancelBtn:(id)sender;
- (IBAction)ContinueBtn:(id)sender;

- (IBAction)ShowMenuView:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *DurationPickerReference;

- (IBAction)StartDate:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *StartDateReference;

- (IBAction)EndDate:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *EndDateReference;

- (IBAction)StartTime:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *StartTimeReference;

- (IBAction)EndTime:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *EndTimeReference;

@property (strong, nonatomic) IBOutlet UIScrollView *parkingScrollView;


@property (strong, nonatomic) SidebarViewController *sideBarViewController;
- (IBAction)SideBarControllerBtn:(id)sender ;

@end
