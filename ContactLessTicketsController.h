//
//  ContactLessTicketsController.h
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

@interface ContactLessTicketsController : UIViewController <JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) SidebarViewController *sideBarViewController;

@property (strong, nonatomic) NSString *TicketName;
@property (strong, nonatomic) NSString *OriginStationName;
@property (strong, nonatomic) NSString *DestinationStationName;

@end
