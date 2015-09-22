//
//  InControllerNewViewController.h
//  MastercardFinal
//
//  Created by administrator on 13/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

#import "PNChart.h"

@interface InControllerNewViewController : UIViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate, UIScrollViewDelegate, PNChartDelegate>

@property (strong, nonatomic) SidebarViewController *sideBarViewController;

- (IBAction)sideBarControllerBtn:(id)sender;
- (IBAction)rightMenuBtn:(id)sender;
- (IBAction)TopAlertBtn:(id)sender;

- (IBAction)tabBtnTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *TitleName;

@property (weak, nonatomic) IBOutlet UIView *dashBoardTabIndicator;
@property (weak, nonatomic) IBOutlet UIView *budgetTabIndicator;

- (IBAction)toggleBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UIView *MiddleView;
@property (weak, nonatomic) IBOutlet UIView *VirtualCardContainerView;

- (IBAction)AddVirtualCard:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *VirtualCardBtnView;

@property (weak, nonatomic) IBOutlet UIView *LowerView;

- (IBAction)AlertBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *AlertView;
@property (weak, nonatomic) IBOutlet UILabel *AlertPhonePurchaseAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *AlertPurchaseDateLabel;
- (IBAction)AlertDismissBtn:(id)sender;

- (IBAction)BudgetDropDown:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *rightView;


@property(strong,nonatomic) PNCircleChart *circleChart;

@property (weak, nonatomic) IBOutlet UIView *CircleChartView;



@end
