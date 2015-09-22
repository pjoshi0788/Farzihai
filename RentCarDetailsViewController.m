//
//  RentCarDetailsViewController.m
//  MastercardFinal
//
//  Created by administrator on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "RentCarDetailsViewController.h"
#import "TransitWalletViewController.h"
#import "RentCarViewController.h"

@interface RentCarDetailsViewController ()
{
    NSArray *dateArray1;
    NSArray *dateArray2;
    NSArray *monthArray;
    NSArray *yearArray;
    UIView *timePickerView;
    UILabel *timelabel;
    UIDatePicker *timePicker;
    NSArray *DaySession;
    NSArray *ageSelectionArray;
    
    UITableView *DaySessiontableView;
    UITableView *AgeTableView;
    
    BOOL pickUpBtnClicked;
    BOOL DaySessionSelector;
    BOOL AgeSelector;
    
    NSInteger btnTag;
}
@end

@implementation RentCarDetailsViewController
@synthesize PricePerDayString;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _myScrollView.scrollEnabled = YES;
    _myScrollView.contentSize = CGSizeMake(375, 1300);
    [_myScrollView setDelegate:self];
    
    [_MasterPassSwitchReference setOn:YES];
    [_PayAtRentalSwitchReference setOn:NO];
    
    AgeSelector = FALSE;
    DaySessionSelector = FALSE;
    pickUpBtnClicked = FALSE;
    
    self.PricePerDayLabel.text = PricePerDayString;
    
    dateArray1 = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
    dateArray2 = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
    monthArray = [[NSArray alloc] initWithObjects:@"JAN",@"FEB",@"MAR",@"APR",@"MAY",@"JUN",@"JUL",@"AUG",@"SEP",@"AUG",@"NOV",@"DEC",nil];
    yearArray = [[NSArray alloc] initWithObjects:@"1990",@"1991",@"1992",@"1993",@"1994",@"1995",@"1996",@"1997",@"1998",@"1990",@"2000",@"2001",@"2002",@"2003",@"20045",@"2005",@"2006",@"2007",@"2008",@"2009",@"2010",@"2011",@"2012",@"2013",@"2014",@"2015",@"2016",@"2017",@"2018",@"2019",@"2020",@"2021",nil];
    
    DaySession = [[NSArray alloc] initWithObjects:@"Day",@"Noon",@"Evening",nil];
    ageSelectionArray = [[NSArray alloc] initWithObjects:@"25 years or above", @"25 years or below", @"30 years or above", nil];
    
    UIColor *color = [UIColor darkGrayColor];
    
    _FirstNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"First Name" attributes:@{NSForegroundColorAttributeName: color}];
    _LastNameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Last Name" attributes:@{NSForegroundColorAttributeName: color}];
    _FlightNmbrTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Flight Number (Optional)" attributes:@{NSForegroundColorAttributeName: color}];
    _EmailAddrsTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email Address" attributes:@{NSForegroundColorAttributeName: color}];
    _PhoneNmbrTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
    _AirlineTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Airline (Optional)" attributes:@{NSForegroundColorAttributeName: color}];
    
    DaySessiontableView = [[UITableView alloc] initWithFrame:CGRectMake(161, 365, 231, 90) style:UITableViewStylePlain];
    
    AgeTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 564, 372, 90) style:UITableViewStylePlain];
    
    self.navigationItem.revealSidebarDelegate = self;
    [_FirstNameTxtFld setDelegate:self];
    [_LastNameTxtFld setDelegate:self];
    [_EmailAddrsTxtFld setDelegate:self];
    [_FlightNmbrTxtFld setDelegate:self];
    [_PhoneNmbrTxtFld setDelegate:self];
    [_AirlineTxtFld setDelegate:self];
    
    [DaySessiontableView setDelegate:self];
    [DaySessiontableView setDataSource:self];
    [AgeTableView setDelegate:self];
    [AgeTableView setDataSource:self];
}

// table VIew delegates and Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (DaySessionSelector == TRUE ) {
        cell.textLabel.text = [DaySession objectAtIndex:indexPath.row];
    } else if (AgeSelector == TRUE){
        cell.textLabel.text = [ageSelectionArray objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (DaySessionSelector == TRUE) {
        if (btnTag == 10) {
            [_PickUpTimeDropDownReference setTitle:[DaySession objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            DaySessiontableView.hidden = TRUE;
            DaySessionSelector = FALSE;

        }else if (btnTag == 20){
            [_ReturnTimeDropDownReference setTitle:[DaySession objectAtIndex:indexPath.row] forState:UIControlStateNormal];
            DaySessiontableView.hidden = TRUE;
        }
//        }else {
//            [_PickUpTimeDropDownReference setTitle:[DaySession objectAtIndex:indexPath.row] forState:UIControlStateNormal];
//            DaySessiontableView.hidden = TRUE;
//            DaySessionSelector = FALSE;
//        }
        }else if (AgeSelector == TRUE) {
        [ _AgeDropDownReference setTitle:[ageSelectionArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        AgeTableView.hidden = TRUE;
        AgeSelector = FALSE;
    }
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


//text Field Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    for (UIView *txt in _myScrollView.subviews ) {
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
    
    return YES;
}

- (IBAction)MasterPassSwitch:(id)sender {
    if ([sender isOn]) {
        [_PayAtRentalSwitchReference setOn:NO animated:YES];
    }else {
        [_PayAtRentalSwitchReference setOn:YES animated:YES];
    }
}

- (IBAction)PayAtRentalSwitch:(id)sender {
    if ([sender isOn]) {
        [_MasterPassSwitchReference setOn:NO animated:YES];
    } else {
        [_MasterPassSwitchReference setOn:YES animated:YES];
    }
}

- (IBAction)CancelBtn:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RentCarViewController *RVC = [storyboard instantiateViewControllerWithIdentifier: @"rentCarViewController"];
    [self presentViewController:RVC animated:YES completion:nil];
    
}

- (IBAction)ContinueBtn:(id)sender {
    
    if ([self.MasterPassSwitchReference isOn]) {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    TransitWalletViewController *homeCtrl = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
    homeCtrl.rechargeVal= PricePerDayString;
    [self presentViewController:homeCtrl animated:YES completion:nil];
    }
}

- (IBAction)SideBarControllerBtn:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
    
}

- (IBAction)DatePickerBtn:(id)sender {
    
    UIButton *btn = (UIButton *) sender;
    
    if (btn == _pickUpDateReference) {
        pickUpBtnClicked = TRUE;
        [self getTime];
    } else {
        pickUpBtnClicked = FALSE;
        [self getTime];
    }
}

- (IBAction)TimeDropDown:(id)sender {
    UIButton *btn = (UIButton *) sender;
    AgeSelector = FALSE;
    DaySessionSelector = TRUE;
    AgeTableView.hidden = TRUE;
    btnTag = btn.tag;
    
    if (btn.tag == 10) {
        
        DaySessiontableView.hidden = FALSE;
        DaySessiontableView.frame = CGRectMake(131, 365, 231, 90);
        [self.myScrollView addSubview:DaySessiontableView];
    }else {
        DaySessiontableView.hidden = FALSE;
        DaySessiontableView.frame = CGRectMake(131, 460, 231, 90);
        [self.myScrollView addSubview:DaySessiontableView];
    }
    
}

- (IBAction)AgeDropDown:(id)sender {
    AgeSelector = TRUE;
    AgeTableView.hidden =FALSE;
    DaySessionSelector = FALSE;
      DaySessiontableView.hidden = TRUE;
    [self.myScrollView addSubview:AgeTableView];
    
}

// Picker View Data Source and Delegate Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return 31;
            break;
        case 1: return 12;
            break;
        case 2: return 32;
            break;
            
    }
    return 1;
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50.0;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,60,40)];
    UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    
    switch (component)
    {
        case 0:[viewLabel setText:[dateArray1 objectAtIndex:row]];
            break;
        case 1:[viewLabel setText:[monthArray objectAtIndex:row]];
            break;
        case 2:[viewLabel setText:[yearArray objectAtIndex:row]];
            break;
    }
    
    [viewLabel setTextColor:[UIColor whiteColor]];
    
    [customView addSubview:viewLabel];
    return customView;
}

-(void) getTime {
    
    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,180,414,320)];
    [timePickerView setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
    
    timelabel = [[UILabel alloc] init];
    timelabel.frame = CGRectMake(0, 10, 414, 40);
    timelabel.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    timelabel.textColor = [UIColor whiteColor];
    timelabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 16.0];
    timelabel.textAlignment = NSTextAlignmentCenter;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateStyle = NSDateFormatterMediumStyle;
    timelabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
    
    [timePickerView addSubview:timelabel];
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, timePickerView.bounds.size.width, 200)];
    timePicker.datePickerMode = UIDatePickerModeDate;
    timePicker.hidden = NO;
    timePicker.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    //    timePicker.backgroundColor = [UIColor whiteColor];
    timePicker.date = [NSDate date];
    [timePicker addTarget:self
                   action:@selector(timeLabelChange)
         forControlEvents:UIControlEventValueChanged];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 280, 187, 30)];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeTimeView) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(207, 280, 207, 30)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self  action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
    [timePickerView addSubview:cancelBtn];
    [timePickerView addSubview:okBtn];
    [timePickerView addSubview:timePicker];
    [self.view addSubview:timePickerView];
}

-(void) timeLabelChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateStyle = NSDateFormatterMediumStyle;
    
    timelabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:timePicker.date]];
}
-(void) removeTimeView
{
    [timePickerView removeFromSuperview];
}

-(void) addTime {
    if(pickUpBtnClicked)
    {
        [_pickUpDateReference setTitle:timelabel.text forState:UIControlStateNormal];
        pickUpBtnClicked = FALSE;
    }
    else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"MMM dd yyyy"];
        NSString *tempString = [_pickUpDateReference titleForState:UIControlStateNormal];
        //            NSDate *setDate = [[NSDate alloc] init];
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDate *setDate = [df dateFromString:tempString];
        
        NSTimeInterval inter1 = [setDate timeIntervalSince1970];
        NSTimeInterval inter2 = [timePicker.date timeIntervalSince1970];
        if (inter1 < inter2) {
            [_returnDateReference setTitle:timelabel.text forState:UIControlStateNormal];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End Date" message:@"Please select date which is greater than Start Date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }

    }
    
    
    [timePickerView removeFromSuperview];
    
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


@end
