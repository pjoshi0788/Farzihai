//
//  RechargeViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/16/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuView.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"


@interface RechargeViewController : UIViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>
{
    MenuView *rechgMenuView;
}
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
@property (strong, nonatomic) UIColor *primaryColor;
@property (nonatomic, strong) SIMChargeCardViewController *chargeController;
@property (weak, nonatomic) IBOutlet UISwitch *sevenDayUnlSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *thirtyDayUnlSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *sevenDayExpSwitch;

- (IBAction)showMenu:(id)sender;
- (IBAction)makePayment:(id)sender;
- (IBAction)toggleView:(id)sender;

@end
