//
//  TransitWalletViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/3/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"

@interface TransitWalletViewController : UIViewController<UIScrollViewDelegate,UIAlertViewDelegate,JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>
{

}

@property (weak, nonatomic) IBOutlet UIScrollView *cardScrollView;
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
@property (weak, nonatomic) IBOutlet UILabel *selectedCard;
@property (strong, nonatomic) UIColor *primaryColor;
@property (nonatomic, strong) SIMChargeCardViewController *chargeController;
@property (strong, nonatomic) NSString *rechargeVal;
- (IBAction)chooseOtherCard:(id)sender;
- (IBAction)toggleView:(id)sender;
- (IBAction)cancelBtnTapped:(id)sender;
 @property (nonatomic, assign) BOOL isCalledFromFare;

@end
