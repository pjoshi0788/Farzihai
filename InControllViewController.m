//
//  InControllViewController.m
//  MastercardFinal
//
//  Created by administrator on 09/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#define DeviceWidth self.view.bounds.size.width
#define DeviceHeight self.view.bounds.size.height

#import "InControllViewController.h"
#import "constant.h"

@interface InControllViewController ()
{
    NSArray *months;
    NSInteger DropDownBtnTag;
}
@end

@implementation InControllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myScrollView.frame = CGRectMake(0, 102, DeviceWidth, DeviceHeight-102);
    _myScrollView.contentSize = CGSizeMake(DeviceWidth * 2, DeviceHeight-102);
    _myScrollView.backgroundColor = [UIColor whiteColor];
    _myScrollView.pagingEnabled = YES;

//    self.view.backgroundColor = [UIColor blackColor];
    
    self.ExpensesIndicatorView.backgroundColor = [UIColor redColor];
    self.DashBoardIndicatorView.backgroundColor = [UIColor blackColor];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *monthComponent = [calendar components:NSCalendarUnitMonth fromDate:date];
    
    long month = [monthComponent month];
    
    months = [[NSArray alloc]initWithObjects:@"January", @"February", @"March", @"April", @"May", @"June", @"July",@"August",@"September",@"October",@"November",@"December", nil];

    _ExpensesDropDownLabel.text = [months objectAtIndex:(month - 1)];
    _DashboardDropDownLabel.text = [months objectAtIndex:(month - 1)];

    [self drawPieChart];
    
    self.myScrollView.delegate = self;
    self.navigationItem.revealSidebarDelegate = self;
    self.MonthSelectionTableView.delegate = self;
    self.MonthSelectionTableView.dataSource = self;
    
}

-(void) drawPieChart {

    self.MonthSelectionTableView.backgroundColor = [UIColor lightGrayColor];
    
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:28.6 color:PNLightBlue description:@"25%"],
                       [PNPieChartDataItem dataItemWithValue:25.8 color:PNLightGreen description:@"25%"],
                       [PNPieChartDataItem dataItemWithValue:23.3 color:PNRed description:@"25%"],
                       [PNPieChartDataItem dataItemWithValue:22.3 color:PNMauve description:@"25%"]
                       ];
    
    
    _pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(0, 0, _pieChartView.bounds.size.width, _pieChartView.bounds.size.height) items:items];
    [_pieChartView addSubview:_pieChart];
    _pieChart.descriptionTextColor = [UIColor whiteColor];
    _pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:9.0];
    [_pieChart strokeChart];
    
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    [self.pieChart strokeChart];
    _pieChart.delegate = self;
    
    
    self.pieChart.legendStyle = PNLegendItemStyleSerial;
    self.pieChart.legendPosition = PNLegendPositionBottom;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:200];
    [legend setFrame:CGRectMake(15, 220, legend.frame.size.width, legend.frame.size.height)];
    [_pieChart addSubview:legend];

}

- (void)userClickedOnPieIndexItem:(NSInteger)pieIndex {
    
    NSArray *localImageArray = [[NSArray alloc] initWithObjects:@"bus_blue_big.png",@"train_green.png",@"car_image.png",@"tramp_image.png", nil];
    _CenterImage.image = [UIImage imageNamed:[localImageArray objectAtIndex:pieIndex]];
}

//******Scroll View Delegate******//

- (void)ScrollViewDidScroll:(UIScrollView *)ScrollView {
    
    NSInteger page = (ScrollView.contentOffset.x + (0.5f * DeviceWidth)) / DeviceWidth;
    
    switch (page)
    {
        case 0:
            self.ExpensesIndicatorView.backgroundColor = [UIColor redColor];
            self.DashBoardIndicatorView.backgroundColor = [UIColor blackColor];
            
            break;
        case 1:
            self.DashBoardIndicatorView.backgroundColor = [UIColor redColor];
            self.ExpensesIndicatorView.backgroundColor = [UIColor blackColor];
            break;
    }
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

- (IBAction)SideBarControllerBtn:(id)sender {
    [self toggleRevealState:JTRevealedStateLeft];
}

- (IBAction)ExpensesBtn:(id)sender {
    
    [self.myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    self.ExpensesIndicatorView.backgroundColor = [UIColor redColor];
    self.DashBoardIndicatorView.backgroundColor = [UIColor blackColor];
    
}

- (IBAction)DashBoardBtn:(id)sender {
    
    [self.myScrollView setContentOffset:CGPointMake(DeviceWidth,0) animated:YES];
    self.DashBoardIndicatorView.backgroundColor = [UIColor redColor];
    self.ExpensesIndicatorView.backgroundColor = [UIColor blackColor];
    
}

//*************Table View delegate and DataSource Methods***************//

//delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.MonthSelectionTableView.hidden = true;
    
    if (DropDownBtnTag == 10) {
        
        _ExpensesDropDownLabel.text = [months objectAtIndex:indexPath.row];
        
    } else {
        _DashboardDropDownLabel.text = [months objectAtIndex:indexPath.row];
    }
    
}


////datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 12;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [months objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    return cell;
}

- (IBAction)MonthSelector:(id)sender {
    
    UIButton *btn = (UIButton *) sender;
    
    if (btn.tag == 10) {
        
        DropDownBtnTag = btn.tag;
        
        self.MonthSelectionTableView.frame = CGRectMake(29, 158, 120, 300);
        self.MonthSelectionTableView.hidden = FALSE;
        [self.myScrollView addSubview:self.MonthSelectionTableView];

    } else if (btn.tag == 20) {
     
        DropDownBtnTag = btn.tag;
        
        self.MonthSelectionTableView.frame = CGRectMake(430, 50, 120, 300);
        self.MonthSelectionTableView.hidden = FALSE;
        [self.myScrollView addSubview:self.MonthSelectionTableView];
    }
}
@end
