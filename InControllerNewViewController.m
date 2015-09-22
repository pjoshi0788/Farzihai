//
//  InControllerNewViewController.m
//  MastercardFinal
//
//  Created by administrator on 13/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//
#define deviceWidth self.view.bounds.size.width
#define deviceHeight self.view.bounds.size.height

#import "InControllerNewViewController.h"

@interface InControllerNewViewController ()
{
    CGPoint currentPoint;
}
@end

@implementation InControllerNewViewController

@synthesize sideBarViewController,dashBoardTabIndicator,budgetTabIndicator,myScrollView,TitleName,AlertView,AlertPhonePurchaseAmountLabel,AlertPurchaseDateLabel,circleChart,CircleChartView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    myScrollView.contentSize = CGSizeMake(deviceWidth * 2, 567);
    myScrollView.scrollEnabled = YES;
    myScrollView.pagingEnabled = YES;
    
    [self drawPieChart];
    
    myScrollView.delegate = self;
    self.navigationItem.revealSidebarDelegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) drawPieChart {
    
    circleChart = [[PNCircleChart alloc] initWithFrame:CGRectMake(0, 0, 250, 250) total:[NSNumber numberWithInt:4]  current:[NSNumber numberWithInt:1] clockwise:YES shadow:YES shadowColor:[UIColor lightGrayColor] displayCountingLabel:NO overrideLineWidth:[NSNumber numberWithFloat:40.0]];
    [circleChart strokeChart];
    
    [CircleChartView addSubview:circleChart];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark SidebarViewControllerDelegate

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
- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    [self toggleRevealState:JTRevealedStateLeft];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    currentPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = (myScrollView.contentOffset.x + (0.5f * deviceWidth)) / deviceWidth;
    
    switch (page)
    {
        case 0:
//            myScrollView.contentOffset = CGPointMake(0, 0);
            dashBoardTabIndicator.backgroundColor = [UIColor redColor];
            budgetTabIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 1:
//            myScrollView.contentOffset = CGPointMake(375, 0);
            dashBoardTabIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            budgetTabIndicator.backgroundColor = [UIColor redColor];
            break;
    }
    
    
    
}

- (IBAction)sideBarControllerBtn:(id)sender{
    
    [self toggleRevealState:JTRevealedStateLeft];
}

- (IBAction)tabBtnTapped:(id)sender{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10) {
        myScrollView.contentOffset = CGPointMake(0, 0);
        dashBoardTabIndicator.backgroundColor = [UIColor redColor];
        budgetTabIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    }else if (btn.tag == 20){
        myScrollView.contentOffset = CGPointMake(375, 0);
        dashBoardTabIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        budgetTabIndicator.backgroundColor = [UIColor redColor];
    }
}


- (IBAction)rightMenuBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Right Menu is not available in this page" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

    
}

- (IBAction)TopAlertBtn:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Action is not Defined right now" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

- (IBAction)AddVirtualCard:(id)sender {
    
    self.myScrollView.delegate = nil;
    
    UIView *AddedVirtualCardView = [[UIView alloc] initWithFrame:CGRectMake(0, self.VirtualCardBtnView.frame.origin.y, 375, 60)];
    UIImageView *AddBtnImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 60, 30)];
    AddBtnImage.image = [UIImage imageNamed:@"unselect-box1.png"];
    AddBtnImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(108, 5, 200, 30)];
    label.text = @"Virtual Card * 8798";
    label.font = [UIFont fontWithName:@"HelveticaNeue" size: 14.0];
    
    UIImageView *TimerImage = [[UIImageView alloc] initWithFrame:CGRectMake(102, 32, 34, 16)];
    TimerImage.image = [UIImage imageNamed:@"clock_new.png"];
    TimerImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [AddedVirtualCardView addSubview:AddBtnImage];
    [AddedVirtualCardView addSubview:label];
    [AddedVirtualCardView addSubview:TimerImage];
    
    [self.VirtualCardContainerView addSubview:AddedVirtualCardView];
    
    self.VirtualCardBtnView.frame =CGRectMake(0, self.VirtualCardBtnView.frame.origin.y + 60, 375, 60);
    self.VirtualCardContainerView.frame = CGRectMake(0, 54, 375, self.VirtualCardContainerView.bounds.size.height + 60);
    self.MiddleView.frame = CGRectMake(0, 188, 375, self.MiddleView.bounds.size.height + 60);
    self.LowerView.frame = CGRectMake(0, self.LowerView.frame.origin.y + 60, 375, 192);
    
    self.myScrollView.contentSize = CGSizeMake(deviceWidth * 2, self.LowerView.frame.origin.y+192);
    NSLog(@"%f",self.myScrollView.bounds.size.height);
    myScrollView.scrollEnabled = YES;
    myScrollView.pagingEnabled = YES;    
    self.myScrollView.delegate = self;
}

- (IBAction)AlertBtn:(id)sender {
    
    TitleName.text = @"In Control Alerts";
    
    UIButton *btn = (UIButton *) sender;
    if (btn.tag == 10) {
        AlertPurchaseDateLabel.text = @"October 10, 2015";
        AlertPhonePurchaseAmountLabel.text = @"$1,000.00";
    }else if (btn.tag == 20){
        AlertPurchaseDateLabel.text = @"October 9, 2015";
        AlertPhonePurchaseAmountLabel.text = @"$995.00";
    }
    
    AlertView.hidden = FALSE;
    [self.view addSubview:AlertView];
}

- (IBAction)AlertDismissBtn:(id)sender {
    TitleName.text = @"Budget";
    AlertView.hidden = TRUE;
}

- (IBAction)BudgetDropDown:(id)sender {
}

- (IBAction)toggleBtn:(id)sender {
    
    currentPoint = myScrollView.contentOffset;
    
    if (currentPoint.x == 0) {
        myScrollView.contentOffset = CGPointMake(375, 0);
        dashBoardTabIndicator.backgroundColor = [UIColor orangeColor];
        budgetTabIndicator.backgroundColor = [UIColor redColor];
    }else{
        myScrollView.contentOffset = CGPointMake(0, 0);
        dashBoardTabIndicator.backgroundColor = [UIColor redColor];
        budgetTabIndicator.backgroundColor = [UIColor orangeColor];
    }
}
@end
