//
//  QkrViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/6/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface QkrViewController : UIViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *qkrScrollView;
- (IBAction)makePayment:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
- (IBAction)toggleView:(id)sender;
- (IBAction)decreaseCount:(id)sender;
- (IBAction)increaseCount:(id)sender;
- (IBAction)cancelBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (nonatomic) BOOL isDemoModeOn;
@end
