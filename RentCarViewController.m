//
//  RentCarViewController.m
//  MastercardFinal
//
//  Created by administrator on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "RentCarViewController.h"
#import "RentCarDetailsViewController.h"
#import "AppDelegate.h"

@interface RentCarViewController ()
{
    NSArray *CarType;
    NSArray *Price;
    NSArray *PricePerDay;
   
}
@end

@implementation RentCarViewController
@synthesize PriceLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CarType = [[NSArray alloc] initWithObjects:@"Economy", @"Compact", @"Intermediate", @"Standard", @"Full Size", @"Premium",@"Luxury", nil];
    Price = [[NSArray alloc] initWithObjects: @"$67.62", @"$67.57", @"$67.62", @"$75.28", @"$87.09", @"NA", @"NA", nil];
    PricePerDay = [[NSArray alloc] initWithObjects:@"$50.32 USD/Day", @"$50.28 USD/Day", @"$50.32 USD/Day",@"$56.07 USD/Day",@"$64.94 USD/Day",@"Sold Out",@"Sold Out", nil];
    
//    _myScrollView.scrollEnabled = YES;
//    _myScrollView.contentSize = CGSizeMake(375, 1000);
 
    self.navigationItem.revealSidebarDelegate = self;
    [_myTableView setDataSource: self];
    [_myTableView setDelegate:self];
    [self.view addSubview:self.myTableView];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.imageView.image = [UIImage imageNamed:@"rent-a-car-s.png"];
    cell.textLabel.text = [CarType objectAtIndex:indexPath.row];
    
    cell.detailTextLabel.text = [PricePerDay objectAtIndex:indexPath.row];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    
    PriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width-30, 18, 80, 50)];
    PriceLabel.text = [Price objectAtIndex:indexPath.row];
    PriceLabel.textColor = [UIColor blackColor];
    [cell addSubview:PriceLabel];
    
    UILabel *TotalPerDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.bounds.size.width-30, 40, 80, 50)];
    TotalPerDayLabel.text = @"Total/Day";
    TotalPerDayLabel.textColor = [UIColor blackColor];
    [cell addSubview:TotalPerDayLabel];
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    PriceLabel.text = [Price objectAtIndex:indexPath.row];
    
//    NSArray *localPriceArray = [[PricePerDay objectAtIndex:indexPath.row] componentsSeparatedByString:@" "];
//    NSString *localPriceVal = [localPriceArray objectAtIndex:0];
//    _RentPriceDemoTime = localPriceVal;
    
    
    
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    RentCarDetailsViewController *RENTCtrl = [storyboard instantiateViewControllerWithIdentifier:@"rentCarDetailsViewController"];
    RENTCtrl.PricePerDayString = [Price objectAtIndex:indexPath.row];
    [self presentViewController:RENTCtrl animated:YES completion:nil];
    
}

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


- (IBAction)showMenuView:(id)sender {
    
    if(transitMenuView == nil)
    {
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        if(appDelegate.setnotice == NO)
            transitMenuView = [[MenuView alloc] initWithFrame:CGRectMake(220, 20, 170, 260)];
        else
            transitMenuView = [[MenuView alloc] initWithFrame:CGRectMake(220, 20, 170, 290)];
        
        [transitMenuView setBackgroundColor:[UIColor colorWithRed:14/255.0 green:14/255.0 blue:14/255.0 alpha:1.0]];
        [self.view addSubview:transitMenuView];
        
    }else if(transitMenuView.isHidden == FALSE)
    {
        [transitMenuView removeFromSuperview];
        transitMenuView = nil;
    }

}

- (IBAction)SideBarControllerBtn:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
    
}

- (IBAction)cancelBtn:(id)sender {
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    [self dismissViewControllerAnimated:topController completion:nil];
    
}
@end
