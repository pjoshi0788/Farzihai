//
//  FareViewController.h
//  MastercardFinal
//
//  Created by Brillio on 03/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"
#import "TransitViewController.h"

@interface FareViewController : UIViewController <JTRevealSidebarV2Delegate, SidebarViewControllerDelegate, UIScrollViewDelegate, UITableViewDelegate,UITableViewDataSource>
{
    NSString *rechareVal;
}


@property (strong, nonatomic) SidebarViewController *sideBarViewController;
- (IBAction)SideBarControllerBtn:(id)sender ;
@property (weak, nonatomic) IBOutlet UIScrollView *fareScrollView;
@property (strong, nonatomic) IBOutlet UITableView *valueSelectionTableView;

- (IBAction)pickerSelector:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *transitPassTypeLbl;

@property (strong, nonatomic) IBOutlet UILabel *transitTypeLbl;
@property (strong, nonatomic) IBOutlet UILabel *transitCardLbl;
@property (strong, nonatomic) IBOutlet UIView *transitCardView;
@property (strong, nonatomic) IBOutlet UIView *LIRRView;
@property (strong, nonatomic) IBOutlet UILabel *fromStationLbl;
@property (strong, nonatomic) IBOutlet UILabel *toStationLbl;
- (IBAction)makePayment:(id)sender;
- (IBAction)cancelPayment:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *rechargeCardView;
@property (strong, nonatomic) IBOutlet UISwitch *departAtTimeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *arriveByTimeSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sevenDayUnlimitedSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *sevenDayExpressSwitch;
@property (strong, nonatomic) IBOutlet UILabel *mtaticketRechargeValue;
@property (strong, nonatomic) IBOutlet UISwitch *thirtyDaysUnlimitedSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *MasterPassSwitch;



@property (strong, nonatomic) IBOutlet UILabel *mtaTicketLbl;
@property (strong, nonatomic) IBOutlet UILabel *mtaTotalRechagreValue;
@property (strong, nonatomic) IBOutlet UILabel *mtaAddTotalValue;
@property (strong, nonatomic) IBOutlet UILabel *lirrTotalValue;



- (IBAction)btnTrainTicketCtrl:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *btnWalletRef;


@end
