//
//  RentCarViewController.h
//  MastercardFinal
//
//  Created by administrator on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "MenuView.h"
#import "AppDelegate.h"

@interface RentCarViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, JTRevealSidebarV2Delegate, SidebarViewControllerDelegate, UIScrollViewDelegate>
{
   MenuView *transitMenuView;
}

@property (strong, nonatomic) SidebarViewController *sideBarViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (strong,nonatomic) UILabel *PriceLabel;
- (IBAction)showMenuView:(id)sender;

@property (strong, nonatomic) NSString *RentPriceDemoTime;

- (IBAction)SideBarControllerBtn:(id)sender;
//- (IBAction)cancelBtn:(id)sender;

@end
