//
//  PricelessCitiesViewController.h
//  MastercardFinal
//
//  Created by administrator on 11/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"


@interface PricelessCitiesViewController : UIViewController <UIAlertViewDelegate,JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>

@property (strong, nonatomic) SidebarViewController *sideBarViewController;
- (IBAction)SideBarBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *BookRSVPBtnView;
- (IBAction)RSVPBtn:(id)sender;
- (IBAction)NotAttendingBtn:(id)sender;
- (IBAction)btnBack:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *ShareAndCancelRSVPBtnView;
- (IBAction)CancelRSVPBtn:(id)sender;
- (IBAction)ShareBtn:(id)sender;

@end
