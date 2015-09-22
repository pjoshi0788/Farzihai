//
//  ParkingViewController.m
//  MastercardFinal
//
//  Created by administrator on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "ParkingViewController.h"
#import "TransitWalletViewController.h"
#import "TransitViewController.h"
#import "AppDelegate.h"
#import <EventKit/EventKit.h>

@interface ParkingViewController ()
{
    UITableView *durationSelector;
    NSArray *DurationDescription;
    NSArray *priceArray;
    NSString *price;
    
    UIView *timePickerView;
    UILabel *timelabel;
    UIDatePicker *timePicker;
    
    BOOL startDateClicked;
    BOOL startTimeClicked;
    BOOL updateDateBtns;
    BOOL startdateSet;
}
@end

@implementation ParkingViewController
@synthesize parkingScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    durationSelector = [[UITableView alloc] initWithFrame:CGRectMake(44, 250, 300, 170)];
    durationSelector.backgroundColor = [UIColor blackColor];
    self.parkingScrollView.scrollEnabled = YES;
    self.parkingScrollView.contentSize = CGSizeMake(375, 700);
    
    DurationDescription = [[NSArray alloc] initWithObjects:@"Early Bird (All Day $16.50)",@"Early Bird (Two Day $32.50)",@"Early Bird (Three Day $40.00)",@"Early Bird (Thirty Day $116.50)", nil];
    priceArray = [[NSArray alloc] initWithObjects:@"$16.50",@"$32.50",@"$40.00",@"$116.50", nil];
    
     self.navigationItem.revealSidebarDelegate = self;
    [_PayWithMasterPassReference setOn:YES animated:NO];
    [_PayWithRentalCounterReference setOn:NO animated:NO];
    
    _ParkingPlaceAddress.lineBreakMode = NSLineBreakByWordWrapping;
    _ParkingPlaceAddress.numberOfLines=0;
    
    if (_ParkingPlaceTitleText != NULL){
        _ParkingPlaceTitle.text = _ParkingPlaceTitleText;
        _ParkingPlaceAddress.text = _ParkingPlaceAddressText;
    }else {
        _ParkingPlaceTitle.text = @"Parking";
        _ParkingPlaceAddress.text = @"100056, NY";
    }
    
    price = @"$40.00";
    
    [durationSelector setDelegate:self];
    [durationSelector setDataSource:self];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd yyyy"];
    
    [_StartDateReference setTitle:[NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    [_EndDateReference setTitle:[NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    
    [df setDateFormat:@"hh:mm a"];
    
    [_StartTimeReference setTitle:[NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    [_EndTimeReference setTitle:[NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    
    startTimeClicked = FALSE;
    startDateClicked = FALSE;
    updateDateBtns = FALSE;
    startdateSet = FALSE;
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

- (IBAction)DurationPickerControllerBtn:(id)sender {
    
    durationSelector.hidden = false;
    
    [self.view addSubview:durationSelector];

    
}

- (IBAction)PayWithMasterPass:(id)sender {
    
        [_PayWithRentalCounterReference setOn:NO animated:YES];
    
}

- (IBAction)PayAtRentalCounter:(id)sender {
        [_PayWithMasterPassReference setOn:NO animated:YES];

}

- (IBAction)CancelBtn:(id)sender {
    
    TransitViewController *transitVC=[[TransitViewController alloc]init];
    
    [self dismissViewControllerAnimated:transitVC completion:nil];
}

- (IBAction)ContinueBtn:(id)sender {
    
    if ([self.PayWithMasterPassReference isOn]) {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    TransitWalletViewController *homeCtrl = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
    
    homeCtrl.rechargeVal = price;
    
    [self presentViewController:homeCtrl animated:YES completion:nil];
    }
}

- (IBAction)ShowMenuView:(id)sender {
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = [DurationDescription objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor lightGrayColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    price = [priceArray objectAtIndex:indexPath.row];
    
    [self.DurationPickerReference setTitle:[DurationDescription objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    
    durationSelector.hidden = TRUE;
}

-(void) getTime {
    
    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,180,414,320)];
//    [timePickerView setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
    [timePickerView setBackgroundColor:[UIColor whiteColor]];
    timelabel = [[UILabel alloc] init];
    timelabel.frame = CGRectMake(0, 10, 414, 40);
    timelabel.backgroundColor = [UIColor whiteColor];
    timelabel.textColor = [UIColor blackColor];
    timelabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    timelabel.textAlignment = NSTextAlignmentCenter;
    
    [timePickerView addSubview:timelabel];
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, timePickerView.bounds.size.width, 200)];
    [self setCalenderOrTimePicker];
//    timePicker.datePickerMode = UIDatePickerModeDate;
    timePicker.hidden = NO;
//    timePicker.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.date = [NSDate date];
    [timePicker addTarget:self
                   action:@selector(timeLabelChange)
         forControlEvents:UIControlEventValueChanged];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 280, 187, 30)];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeTimeView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(207, 280, 207, 30)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okBtn addTarget:self  action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
    
    [timePickerView addSubview:cancelBtn];
    [timePickerView addSubview:okBtn];
    [timePickerView addSubview:timePicker];
    [self.view addSubview:timePickerView];
}

-(void)setCalenderOrTimePicker {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    if (updateDateBtns) {
        df.timeStyle = NSDateFormatterNoStyle;
        df.dateStyle = NSDateFormatterMediumStyle;
        timelabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
        timePicker.datePickerMode = UIDatePickerModeDate;
    }else {
        timePicker.datePickerMode = UIDatePickerModeTime;
        
    }
}

-(void) timeLabelChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    if (updateDateBtns) {
       [df setDateFormat:@"MMM dd yyyy"];
       timelabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:timePicker.date]];
        
    } else {

        [df setDateFormat:@"hh:mm a"];
        timelabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:timePicker.date]];
        
    }
}

-(void) removeTimeView
{
    [timePickerView removeFromSuperview];
}

-(void) addTime {
    if(startDateClicked && updateDateBtns)
    {
        [_StartDateReference setTitle:timelabel.text forState:UIControlStateNormal];
        startDateClicked = FALSE;
        updateDateBtns = FALSE;
        startdateSet = TRUE;

    }
    else if (!startDateClicked && updateDateBtns){
        if (startdateSet) {
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"MMM dd yyyy"];
            NSString *tempString = [_StartDateReference titleForState:UIControlStateNormal];
//            NSDate *setDate = [[NSDate alloc] init];
            [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            NSDate *setDate = [df dateFromString:tempString];
            
            NSTimeInterval inter1 = [setDate timeIntervalSince1970];
            NSTimeInterval inter2 = [timePicker.date timeIntervalSince1970];
            if (inter1 < inter2) {
                [_EndDateReference setTitle:timelabel.text forState:UIControlStateNormal];
                updateDateBtns = FALSE;
                startdateSet = FALSE;
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End Date" message:@"Please select date which is greater than Start Date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        
        }
        
    }else if(startTimeClicked )
    {
        [_StartTimeReference setTitle:timelabel.text forState:UIControlStateNormal];
        startTimeClicked = FALSE;
    }else
        [_EndTimeReference setTitle:timelabel.text forState:UIControlStateNormal];
    
    [timePickerView removeFromSuperview];
    
}




- (IBAction)StartDate:(id)sender {
    
    startDateClicked = TRUE;
    updateDateBtns = TRUE;
    [self getTime];
    
}
- (IBAction)EndDate:(id)sender {
    
    startDateClicked = FALSE;
    updateDateBtns = TRUE;
    [self getTime];
}
- (IBAction)StartTime:(id)sender {
    
    startTimeClicked = TRUE;
    updateDateBtns = FALSE;

     [self getTime];
}
- (IBAction)EndTime:(id)sender {
    
    startTimeClicked = FALSE;
    updateDateBtns = FALSE;

     [self getTime];
}

- (IBAction)SideBarControllerBtn:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
    
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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

@end
