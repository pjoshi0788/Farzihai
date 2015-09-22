//
//  InControllViewController.h
//  MastercardFinal
//
//  Created by administrator on 09/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

#import "PNChart.h"

@interface InControllViewController : UIViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,PNChartDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) SidebarViewController *sideBarViewController;

- (IBAction)SideBarControllerBtn:(id)sender;

- (IBAction)ExpensesBtn:(id)sender;
- (IBAction)DashBoardBtn:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *DashBoardIndicatorView;
@property (weak, nonatomic) IBOutlet UIView *ExpensesIndicatorView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;



@property (weak, nonatomic) IBOutlet UITableView *MonthSelectionTableView;

- (IBAction)MonthSelector:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *DashboardDropDownLabel;

@property (weak, nonatomic) IBOutlet UIImageView *CenterImage;

@property (weak, nonatomic) IBOutlet UILabel *ExpensesDropDownLabel;

@property(strong,nonatomic) PNPieChart *pieChart;
@property (weak, nonatomic) IBOutlet UIView *pieChartView;

@end
