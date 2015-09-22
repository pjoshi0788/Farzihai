//
//  MTA-LIRR_ViewController.m
//  MastercardFinal
//
//  Created by administrator on 07/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#define DeviceWidth self.view.bounds.size.width
#define DeviceHeight self.view.bounds.size.height

#import "MTA-LIRR_ViewController.h"
#import "constant.h"

@interface MTA_LIRR_ViewController ()
{
    UIButton *MTA_Button;
    UIButton *LIRR_Button;
    UIButton *METRO_NORTH_Button;
    
    UILabel *MTA_SelectionIndicator;
    UILabel *LIRR_SelectionIndicator;
    UILabel *METRO_NORTH_SelectionIndicator;

    UIScrollView *StaticMapView;
}
@end

@implementation MTA_LIRR_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    UIView *topTitleHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 55)];
    topTitleHeader.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topTitleHeader];
    
    UIButton *sideBarViewButton = [[UIButton alloc] initWithFrame:CGRectMake(13, 24, 28, 25)];
    [sideBarViewButton setImage:[UIImage imageNamed:@"Hamburger-Menu.png"] forState:UIControlStateNormal];
    [sideBarViewButton addTarget:self action:@selector(SideBarViewButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [topTitleHeader addSubview:sideBarViewButton];
    
    UILabel *Title = [[UILabel alloc] initWithFrame:CGRectMake(55, 24, DeviceWidth - 55, 25)];
    Title.text = @"Maps";
    Title.textColor = [UIColor whiteColor];
    [topTitleHeader addSubview:Title];

    MTA_Button = [UIButton buttonWithType:UIButtonTypeSystem];
    MTA_Button.frame = CGRectMake(0, 55, DeviceWidth/3, 41);
    MTA_Button.tag = MTA_MAP_TAB;
    [MTA_Button setTitle:@"MTA" forState:UIControlStateNormal];
    [MTA_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [MTA_Button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
   // MTA_Button.backgroundColor = [UIColor orangeColor];
    [MTA_Button setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0]];
    MTA_Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:MTA_Button];
    
    LIRR_Button = [UIButton buttonWithType:UIButtonTypeSystem];
    LIRR_Button.frame = CGRectMake(DeviceWidth/3, 55, DeviceWidth/3, 41);
    LIRR_Button.tag = LIRR_MAP_TAB;
    [LIRR_Button setTitle:@"LIRR" forState:UIControlStateNormal];
    [LIRR_Button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchDown];
    //LIRR_Button.backgroundColor = [UIColor orangeColor];
    [LIRR_Button setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [LIRR_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    LIRR_Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:LIRR_Button];
    
    METRO_NORTH_Button = [UIButton buttonWithType:UIButtonTypeSystem];
    METRO_NORTH_Button.frame = CGRectMake(DeviceWidth*2/3, 55, DeviceWidth/3, 41);
    METRO_NORTH_Button.tag = METRO_NORTH_MAP_TAB;
    [METRO_NORTH_Button setTitle:@"Metro North" forState:UIControlStateNormal];
    [METRO_NORTH_Button addTarget:self action:@selector(ButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // MTA_Button.backgroundColor = [UIColor orangeColor];
    [METRO_NORTH_Button setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0]];
    [METRO_NORTH_Button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    METRO_NORTH_Button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:METRO_NORTH_Button];

    
    MTA_SelectionIndicator = [[UILabel alloc] initWithFrame:CGRectMake(0, 96, DeviceWidth/3, 4)];
    MTA_SelectionIndicator.backgroundColor = [UIColor redColor];
    [self.view addSubview:MTA_SelectionIndicator];
    
    LIRR_SelectionIndicator = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth/3, 96, DeviceWidth/3, 4)];
    LIRR_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    [self.view addSubview:LIRR_SelectionIndicator];
    
    METRO_NORTH_SelectionIndicator = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth*2/3, 96, DeviceWidth/3, 4)];
    METRO_NORTH_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    [self.view addSubview:METRO_NORTH_SelectionIndicator];
    
    StaticMapView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, DeviceWidth, DeviceHeight-100)];
    StaticMapView.contentSize  = CGSizeMake(DeviceWidth * 4, DeviceHeight-90);
    StaticMapView.pagingEnabled = YES;
        
    [self.view addSubview:StaticMapView];
    
    UIImageView *MTA_map = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, DeviceWidth - 10, DeviceHeight-120)];
    MTA_map.image = [UIImage imageNamed:@"mta_offline.png"];
    MTA_map.contentMode = UIViewContentModeScaleAspectFit;
    MTA_map.backgroundColor = [UIColor clearColor];
    [StaticMapView addSubview:MTA_map];
    
    UIImageView *LIRR_map = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth + 5, 10, DeviceWidth -10, DeviceHeight-120)];
        LIRR_map.image = [UIImage imageNamed:@"lirr.png"];
    LIRR_map.backgroundColor = [UIColor clearColor];
    LIRR_map.contentMode = UIViewContentModeScaleAspectFit;
    [StaticMapView addSubview:LIRR_map];
    
    UIImageView *METRO_NORTH = [[UIImageView alloc] initWithFrame:CGRectMake(DeviceWidth*2, 10, DeviceWidth*2 , DeviceHeight-120)];
    METRO_NORTH.image = [UIImage imageNamed:@"mnrmap.png"];
    METRO_NORTH.contentMode = UIViewContentModeScaleAspectFill;
    METRO_NORTH.backgroundColor = [UIColor clearColor];
    [StaticMapView addSubview:METRO_NORTH];

    
    self.navigationItem.revealSidebarDelegate=self;
    StaticMapView.delegate = self;
    
}

-(void) ButtonAction:(UIButton *) sender {
    
    if (sender.tag == MTA_MAP_TAB) {
        
        [StaticMapView setContentOffset:CGPointMake(0, 0) animated:YES];
        MTA_SelectionIndicator.backgroundColor = [UIColor redColor];
        LIRR_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        METRO_NORTH_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    }else if (sender.tag == LIRR_MAP_TAB){
        
        [StaticMapView setContentOffset:CGPointMake(DeviceWidth, 0) animated:YES];
        LIRR_SelectionIndicator.backgroundColor = [UIColor redColor];
        MTA_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        METRO_NORTH_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];

    }
    else if (sender.tag == METRO_NORTH_MAP_TAB){
        
        [StaticMapView setContentOffset:CGPointMake(DeviceWidth * 2, 0) animated:YES];
        METRO_NORTH_SelectionIndicator.backgroundColor = [UIColor redColor];
        LIRR_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        MTA_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    }
}

//******Scroll View Delegate******//

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = (scrollView.contentOffset.x + (0.5f * DeviceWidth)) / DeviceWidth;
    
    switch (page)
    {
        case 0: 
            MTA_SelectionIndicator.backgroundColor = [UIColor redColor];
            LIRR_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            METRO_NORTH_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];

            break;
        case 1: 
            LIRR_SelectionIndicator.backgroundColor = [UIColor redColor];
            MTA_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            METRO_NORTH_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 2:
            LIRR_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            MTA_SelectionIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            METRO_NORTH_SelectionIndicator.backgroundColor = [UIColor redColor];
    }
}

-(void) SideBarViewButtonAction {
    
    [self toggleRevealState:JTRevealedStateLeft];
}

#pragma mark JTRevealSidebarDelegate
// This is an example to configure your sidebar view without a UIViewController
- (UIView *)viewForLeftSidebar {
    CGRect viewFrame = self.applicationViewFrame;
    
    UITableViewController *controller = self.sideBarViewController;
    if ( ! controller) {
        self.sideBarViewController = [[SidebarViewController alloc] init];
        self.sideBarViewController.sidebarDelegate = self;
        controller = self.sideBarViewController;
        
    }
    
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    //controller.view.frame = CGRectMake(0, 30, 270, 500);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
    return controller.view;
}

#pragma mark SidebarViewControllerDelegate
- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    [self toggleRevealState:JTRevealedStateLeft];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
