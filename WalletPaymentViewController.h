//
//  WalletPaymentViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/3/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"
#import "RentCarViewController.h"
@interface WalletPaymentViewController : UIViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *selectedCardView;
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
@property (nonatomic) NSInteger selectedCardIndex;
@property (weak, nonatomic) IBOutlet UILabel *cardTypeLbl;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) NSString *rechargeVal;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)payWithCard:(id)sender;
- (IBAction)toggleView:(id)sender;
-(void) dismissView;

@property (strong, nonatomic) NSString *RechargeValueDemoTime;

@property(nonatomic) BOOL isCalledFromFare;
@end
