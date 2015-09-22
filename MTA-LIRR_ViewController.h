//
//  MTA-LIRR_ViewController.h
//  MastercardFinal
//
//  Created by administrator on 07/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface MTA_LIRR_ViewController : UIViewController <JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) SidebarViewController *sideBarViewController;

@end
