    
//
//  SubscriberViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/9/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "Constant.h"
#import "SubscriberViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LocationPickerViewController.h"
#import <AppDelegate.h>
#import "TransitViewController.h"

#define NO_NETWORK_ALERT 36
@interface SubscriberViewController ()
{
    CGPoint pointNow;
    UITapGestureRecognizer *touches;
    NSString *userName;
}
@end

@implementation SubscriberViewController
@synthesize subscriberScrollView, aboutYouView, transitInfoView, preferencesView,data;
@synthesize usernameTxtFld, livingTypeView, livingStatusView,appUsageView, addressView, commuteTimeView, nearView, cityLivingSwitch, suburbLivingSwitch, visitingTypeView,visitingTypeLabel,livingTypeLabel;
@synthesize businessNYSwitch,touristNYSwitch;
@synthesize backBtn,liveinNY, visitingNY,commuteSwitch,homeAddrFld, workAddrFld, homeAddrBtn,workAddrBtn;
@synthesize leaveHomeTimeBtn,leaveWorkBtn, ATMswitch, EntertainmentSwitch, FoodAndBeveragesSwitch, ConcertsSwitch, SportsSwitch,TapToPaySwitch,skipBtn;

//iphone 6 
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setCenter:self.view.center];
    [self.view addSubview:activity];
    [self.skipBtn setHidden:YES];

    
//    liveinNY.userInteractionEnabled = NO;
    cityLivingSwitch.userInteractionEnabled = NO;
    suburbLivingSwitch.userInteractionEnabled = NO;
    touristNYSwitch.userInteractionEnabled= NO;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Persona Selection" message:@"Only Business Persona is available in iOS version of MasterCard App" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    
    data = [NSMutableDictionary dictionary];
    homeAddrFld.delegate=self;
    workAddrFld.delegate=self;
    homeAddrBtn.tag = HOME_ADDR_FLD;
    workAddrBtn.tag = WORK_ADDR_FLD;
    hourArray = [[NSArray alloc] initWithObjects:@"1",@"12",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12", nil];
    minuteArray = [[NSArray alloc] initWithObjects:@"1",@"12",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",
                   @"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",
                   @"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",
                   @"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",
                   @"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",
                   @"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59", nil];
    timeZoneArray = [[NSArray alloc] initWithObjects:@"AM",@"PM",nil];
    subscriberScrollView.delegate=self;
  
    [subscriberScrollView setContentSize:CGSizeMake(1125, 600)];
    [subscriberScrollView setScrollEnabled:YES];
    [subscriberScrollView setPagingEnabled:YES];
    
    leaveHomeBtnTapd = FALSE;
   // [self aboutYouSetUp];
    
   // [self transitInfoSetUp];
    
   // [self preferencesSetUp];
    
    touches = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
    touches.enabled = YES;
    touches.delegate = self;
    
    [backBtn setHidden:YES];
    
    //About You Tab
    [usernameTxtFld.layer setBorderColor:[[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0] CGColor]];
    //[usernameTxtFld becomeFirstResponder];
    UIColor *color = [UIColor whiteColor];
    usernameTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Your Name" attributes:@{NSForegroundColorAttributeName: color}];
    usernameTxtFld.layer.borderWidth = 0.0;
    
    homeAddrFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Set Home Address" attributes:@{NSForegroundColorAttributeName: color}];
    workAddrFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Set Work Address" attributes:@{NSForegroundColorAttributeName: color}];
    
    livingTypeView.layer.borderWidth = 0.0;
    [livingTypeView.layer setBorderColor:[[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0] CGColor]];
    
    livingStatusView.layer.borderWidth = 0.0;
    [livingStatusView.layer setBorderColor:[[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0] CGColor]];
    
    
    // Transit Info tab
    
    appUsageView.layer.borderWidth = 0.0;
    [appUsageView.layer setBorderColor:[[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0] CGColor]];
    
    addressView.layer.borderWidth = 0.0;
    [addressView.layer setBorderColor:[[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0] CGColor]];
    
    commuteTimeView.layer.borderWidth = 0.0;
    [commuteTimeView.layer setBorderColor:[[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0] CGColor]];
    
    //Preferences Tab
    
    nearView.layer.borderWidth = 0.0;
    [nearView.layer setBorderColor:[[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1.0] CGColor]];

    
    [liveinNY addTarget:self action:@selector(livingNYSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    [visitingNY addTarget:self action:@selector(visitingNYSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [visitingNY isOn];
    [businessNYSwitch addTarget:self action:@selector(businessSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [touristNYSwitch addTarget:self action:@selector(touristNYSwitchChange:) forControlEvents:UIControlEventValueChanged];
    
    [cityLivingSwitch addTarget:self action:@selector(cityLivingSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [suburbLivingSwitch addTarget:self action:@selector(suburbLivingSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [commuteSwitch addTarget:self action:@selector(dailycommuteSwitchChange:) forControlEvents:UIControlEventValueChanged];
    /*UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];*/
    usernameTxtFld.delegate=self;
    usernameTxtFld.autocapitalizationType = UITextAutocapitalizationTypeWords;
    tableViewhomeAddr = [[UITableView alloc]initWithFrame:CGRectMake(380, 174, 360, 150)];
    tableViewhomeAddr.backgroundColor=[UIColor clearColor ];
    tableViewhomeAddr.delegate = self;
    tableViewhomeAddr.dataSource = self;
    tableViewhomeAddr.hidden = YES;
    [tableViewhomeAddr setAllowsSelection:YES];
    [self.subscriberScrollView addSubview:tableViewhomeAddr];
    
    tableViewworkAddr = [[UITableView alloc]initWithFrame:CGRectMake(380, 204, 360, 150)];
    tableViewworkAddr.backgroundColor=[UIColor clearColor];
    tableViewworkAddr.delegate = self;
    tableViewworkAddr.dataSource = self;
    tableViewworkAddr.hidden = YES;
    [tableViewworkAddr setAllowsSelection:YES];
    [self.subscriberScrollView addSubview:tableViewworkAddr];
   
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *UserInfo = [appDelegate UserinfoplistContent:YES];
    NSString *isHelpCenterViewPresentedCheck = [UserInfo objectForKey:@"isHelpCenterViewPresented"];
    if(isHelpCenterViewPresentedCheck == NULL) {
        [data setObject:@"NO" forKey:@"isHelpCenterViewPresented"];
    }
}

-(void) handleTapFrom:(UITapGestureRecognizer *)recognizer{
    
    NSLog(@"recogn : %@",recognizer);
//    CGPoint currentlocation = [recognizer locationInView:self.view];
//    tableViewworkAddr.delegate = self;
//    tableViewhomeAddr.delegate = self;
//    if (currentlocation.x < tableViewhomeAddr.frame.origin.x || currentlocation.x <375 || currentlocation.y > tableViewhomeAddr.frame.size.height || currentlocation.x > tableViewhomeAddr.frame.size.width) {
//
//        [tableViewhomeAddr setHidden:TRUE];
//    }
//    if (currentlocation.x < tableViewworkAddr.frame.origin.x || currentlocation.x <375 || currentlocation.y > tableViewworkAddr.frame.size.height || currentlocation.x > tableViewworkAddr.frame.size.width){
//        [tableViewworkAddr setHidden:TRUE];
//    }
//    
}

-(void)sendDataToA:(NSString *)address forAddress:(BOOL)homeAddress
{
  
   if(homeAddress)
   {
       homeAddrFld.text = address;
       [data setObject:address forKey:@"homeAddress"];
       [subscriberScrollView setScrollEnabled:YES];
       
   }
   else
   {
       workAddrFld.text = address;
       [data setObject:address forKey:@"workAddress"];
       [subscriberScrollView setScrollEnabled:YES];
   }
    
}

-(void) livingNYSwitchChange:(id)sender{
//    if([sender isOn]){
//        [data setObject:@"1" forKey:@"liveInNY"];
//        [subscriberScrollView setScrollEnabled:YES];
//        [visitingNY setOn:NO animated:YES];
//        [visitingTypeView setHidden:YES];
//        [livingTypeView setHidden:NO];
//        [visitingTypeLabel setHidden:YES];
//        [livingTypeLabel setHidden:NO];
//        livingTypeLabel.text=@"Where do you live?";
//       
//    } else{
//        [visitingNY setOn:YES animated:YES];
//        
//        [visitingTypeView setHidden:NO];
//        [livingTypeView setHidden:YES];
//        
//        [visitingTypeLabel setHidden:NO];
//        [livingTypeLabel setHidden:YES];
//    }
    [liveinNY setOn:NO];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Choose Visiting New York, as Business Persona is supported in iOS" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}

-(void) visitingNYSwitchChange:(id)sender{
    if([sender isOn]){
        [data setObject:@"1" forKey:@"visitInNY"];
        [subscriberScrollView setScrollEnabled:YES];
        [liveinNY setOn:NO animated:YES];
        [visitingTypeView setHidden:NO];
        [livingTypeView setHidden:YES];
        [visitingTypeLabel setHidden:NO];
        [livingTypeLabel setHidden:YES];
        visitingTypeLabel.text = @"What brings you to New York?";
       
    } else{
//        [liveinNY setOn:YES animated:YES];
        [liveinNY setOn:NO animated:YES];
//        [visitingTypeView setHidden:YES];
        [visitingTypeView setHidden:NO];
//        [livingTypeView setHidden:NO];
        [livingTypeView setHidden:YES];
//        [visitingTypeLabel setHidden:YES];
        [visitingTypeLabel setHidden:NO];
//        [livingTypeLabel setHidden:NO];
        [livingTypeLabel setHidden:YES];
        
    }
}

-(void) businessSwitchChange:(id)sender{
    if([sender isOn]){
        [data setObject:@"1" forKey:@"businessInNY"];
        [subscriberScrollView setScrollEnabled:YES];
        [touristNYSwitch setOn:NO animated:YES];
    } else{
//        [touristNYSwitch setOn:YES animated:YES];
        [touristNYSwitch setOn:NO animated:YES];

    }
}

-(void) touristNYSwitchChange:(id)sender{
    if([sender isOn]){
        [data setObject:@"1" forKey:@"touristInNY"];
        [subscriberScrollView setScrollEnabled:YES];
        [businessNYSwitch setOn:NO animated:YES];
    } else{
        [businessNYSwitch setOn:YES animated:YES];
    }
}

-(void) cityLivingSwitchChange:(id)sender{
    if([sender isOn]){
        [data setObject:@"1" forKey:@"cityLiving"];
        [subscriberScrollView setScrollEnabled:YES];
        [suburbLivingSwitch setOn:NO animated:YES];
        
    } else{
        [suburbLivingSwitch setOn:YES animated:YES];
    }
}
-(void) suburbLivingSwitchChange:(id)sender{
    if([sender isOn]){
        [data setObject:@"1" forKey:@"suburbLiving"];
        [subscriberScrollView setScrollEnabled:YES];
        [cityLivingSwitch setOn:NO animated:YES];
        
    } else{
        [cityLivingSwitch setOn:YES animated:YES];
    }
}
-(void)dailycommuteSwitchChange:(id)sender{
    if([sender isOn]){
        [data setObject:@"1" forKey:@"dailyCommute"];
        [subscriberScrollView setScrollEnabled:YES];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) saveInCustomFile
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"UserInfo.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path])
    {
        path = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat: @"UserInfo.plist"] ];
    }
   [data writeToFile: path atomically:YES];
    

}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    pointNow = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    NSLog(@"%f",scrollView.contentOffset.x);
    
    CGFloat xDist = (scrollView.contentOffset.x - pointNow.x);

    if (xDist != 0.0) {
        if(page == 0)
        {
            if(self.isAboutYoudetailsFilled == FALSE)
                [subscriberScrollView setScrollEnabled:NO];
            else
                [subscriberScrollView setScrollEnabled:YES];
        }else if(page == 1) {
            if(self.istransitPageDetailsFilled == FALSE)
                [subscriberScrollView setScrollEnabled:NO];
            else
                [subscriberScrollView setScrollEnabled:YES];
        }
    }
    
    [self removeTimeView];
    if(usernameTxtFld.isFirstResponder)
        [usernameTxtFld resignFirstResponder];
    else if(homeAddrFld.isFirstResponder)
           [homeAddrFld resignFirstResponder];
    else if(workAddrFld.isFirstResponder)
          [workAddrFld resignFirstResponder];
    
    switch (page)
    {
            case 0:
                [aboutYouView setBackgroundColor:[UIColor redColor]];
                [preferencesView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                [transitInfoView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                [backBtn setHidden:YES];
               [self.skipBtn setHidden:YES];
                break;
            case 1:
                [aboutYouView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                [preferencesView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                [transitInfoView setBackgroundColor:[UIColor redColor]];
                [self.skipBtn setHidden:NO];
                [backBtn setHidden:NO];
//                [tableViewhomeAddr addGestureRecognizer:touches];
//                [tableViewworkAddr addGestureRecognizer:touches];
//            [subscriberScrollView addGestureRecognizer:touches];
                break;
            case 2: [aboutYouView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                [preferencesView setBackgroundColor:[UIColor redColor]];
                [transitInfoView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                [backBtn setHidden:NO];
                [self.skipBtn setHidden:NO];
                break;
            default:[aboutYouView setBackgroundColor:[UIColor redColor]];
                [preferencesView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                [transitInfoView setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:166.0/255.0 blue:32.0/255.0 alpha:1.0]];
                break;
    }
   
}



-(BOOL) isLetsGoBtnDisabled {
    
    if ([TapToPaySwitch isOn] || [ATMswitch isOn] ||[EntertainmentSwitch isOn] || [FoodAndBeveragesSwitch isOn] || [ConcertsSwitch isOn] || [SportsSwitch isOn]) {
        return 0;
    }
    
    return 1;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(usernameTxtFld.isFirstResponder)
    {
        if([textField.text isEqualToString:@" "])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter the name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
          [data setObject:textField.text forKey:@"name"];
            userName = textField.text;
          [subscriberScrollView setScrollEnabled:YES];
        }
    }else if(homeAddrFld.isFirstResponder)
    {
        [data setObject:textField.text forKey:@"homeAddress"];
        [subscriberScrollView setScrollEnabled:YES];
    }else if(workAddrFld.isFirstResponder)
    {
        [data setObject:textField.text forKey:@"workAddress"];
        [subscriberScrollView setScrollEnabled:YES];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField

{
    usernameTxtFld.text = [usernameTxtFld.text capitalizedString];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if(textField==homeAddrFld)
//       [self.subscriberScrollView addSubview:homeAddrFld];
//    if(textField==workAddrFld)
//        [self.subscriberScrollView addSubview:workAddrFld];
    return TRUE;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    textField.text = [textField.text capitalizedString];
    
    if(textField == usernameTxtFld)
    {
        if (range.location == 0 && [string isEqualToString:@" "]) {
            return NO;
        }
    }
    
    NSString *searchText;
    
    searchText=[textField.text stringByAppendingString:string];
    
    if (textField == homeAddrFld) {
        tableViewhomeAddr.hidden = NO;
        tableViewworkAddr.hidden = YES;
    } else if(textField == workAddrFld){
        tableViewhomeAddr.hidden = YES;
        tableViewworkAddr.hidden = NO;
    }
    if(textField == homeAddrFld || textField == workAddrFld)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];
       
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        if(appDelegate.NetworkStatus == YES)
        {
            tableData=(NSMutableArray*)[[self arrGlobalSearch:searchText] filteredArrayUsingPredicate:predicate];
            [self tableHomeRoladData];
            [self tableworkReloadData];

        }else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    
        
       /* NSMutableArray *sortedArray = [[NSMutableArray alloc]initWithArray: [tableData
                                                                         sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];*/
    
       
    }
    return TRUE;

}
-(void) tableHomeRoladData{
    
    UITableView * selfTable = tableViewhomeAddr;
    
    [selfTable reloadData];
    
}
-(void) tableworkReloadData{
    
    UITableView * selfTableDest = tableViewworkAddr;
    
    [selfTableDest reloadData];
}
//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//    NSUserDefaults *textFieldData = [NSUserDefaults standardUserDefaults];
//    
//    if (textField.tag == USERNAME_TXT_FLD_TAG) {
//        [textFieldData setObject:textField.text forKey:@"name"];
//    }
//    
//}

-(NSMutableArray *)arrGlobalSearch:(NSString *)arrGlobal
{
    
    
    NSString *geocode=@"geocode";
    
    NSString *key=@"AIzaSyCdbGLZGIlbKgf9qQU-9iKW8C568VXBR9A";
    
    
    NSHTTPURLResponse *response = nil;
    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@input=%@&types=%@&key=%@", kDirectionsURL, arrGlobal, geocode,key];
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSError *error=nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSMutableDictionary *dataHold = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers  error:nil];
    if(error)
    {
        NSLog(@"ERROR MESSAGE = %@", error.description);
    }
  
    NSArray *results=dataHold[@"predictions"];
    
    NSMutableArray *textsteps=[[NSMutableArray alloc] init];
    
    for(int i=0; i< [results count]; i++){
        NSString *name=results[i][@"description"];
        
        [textsteps addObject:name];
    }
 
   
    return textsteps;
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error code %@", error);
}

-(void)dismissKeyboard {
    for (UIView * txt in self.subscriberScrollView.subviews){
        if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
            [txt resignFirstResponder];
        }
    }
   
   
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)tabBtnTapped:(id)sender {
    
    if(usernameTxtFld.isFirstResponder)
        [usernameTxtFld resignFirstResponder];
    
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == ABOUT_YOU_TAB)
    {
        
        [subscriberScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [backBtn setHidden:YES];
    }
    else if(btn.tag == TRANSIT_INFO_TAB)
    {
        if(self.isAboutYoudetailsFilled == TRUE)
        {
           [subscriberScrollView setContentOffset:CGPointMake(376, 0) animated:YES];
           [backBtn setHidden:NO];
        }
    }
    else if(btn.tag == PREFERENCES_TAB)
    {
        if(self.isAboutYoudetailsFilled == TRUE) {
            if(self.istransitPageDetailsFilled == TRUE)
            {
                [subscriberScrollView setContentOffset:CGPointMake(751, 0) animated:YES];
                [backBtn setHidden:NO];
            }else
            {
                if(self.homeAddrFld.text.length == 0 && self.workAddrFld.text.length == 0){
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all the details before proceeding" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
            }
        }
//        }else
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all the details before proceeding" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
        
    }
}


#pragma mark - UIPickerView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if ((tableView==tableViewhomeAddr) || (tableView==tableViewworkAddr))
    {
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
    
    //[lblAddressLine1 setText:[arrFinalLine1 objectAtIndex:[indexPath row]]];
        cell.textLabel.text =[tableData objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont  fontWithName:@"Helvetica Neue" size:14]];
    }
     return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *selectedCell = [tableViewhomeAddr cellForRowAtIndexPath:indexPath];
    
    if (tableView== tableViewhomeAddr) {
        homeAddrFld.text=selectedCell.textLabel.text;
        [workAddrFld becomeFirstResponder];
        tableViewhomeAddr.hidden = YES;
    }
    else if (tableView== tableViewworkAddr)
    {
        workAddrFld.text = selectedCell.textLabel.text;
        tableViewworkAddr.hidden = YES;
        
    }
}
#pragma mark - UIPickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component)
    {
        case 0: return 12;
            break;
        case 1: return 59;
            break;
        case 2: return 2;
            break;
            
    }
    return 1;
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 50.0;
}
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return @"Hours";
//}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,60,40)];
    UILabel *viewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    
    switch (component)
    {
        case 0:[viewLabel setText:[hourArray objectAtIndex:row]];
                break;
        case 1:[viewLabel setText:[minuteArray objectAtIndex:row]];
                break;
        case 2:[viewLabel setText:[timeZoneArray objectAtIndex:row]];
                break;
    }
    
    [viewLabel setTextColor:[UIColor whiteColor]];
    
    [customView addSubview:viewLabel];
    return customView;
}

- (IBAction)letsGoBtnTapped:(id)sender {
    //Save the User data
 
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate NetworkStatus];
    [self performSelector:@selector(callLetsGo) withObject:nil afterDelay:3.0];
}

-(void) callLetsGo
{
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.nwStatus ==YES)
    {
     if ([TapToPaySwitch isOn] || [ATMswitch isOn] || [EntertainmentSwitch isOn] || [FoodAndBeveragesSwitch isOn] || [ConcertsSwitch isOn] || [SportsSwitch isOn])
     {
    
         if (![self isLetsGoBtnDisabled]) {
             
             [data setObject:@"Success" forKey:@"setupDone"];
             [self saveInCustomFile];

         UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
             
             
             TransitViewController *transitVc = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
             [self presentViewController:transitVc animated:YES completion:nil];

         [NSThread detachNewThreadSelector:@selector(animateActivityWheel) toTarget:self withObject:nil];
            
//                 
//             TransitViewController *transitVc = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
//             [self presentViewController:transitVc animated:YES completion:nil];
             
             [activity stopAnimating];
//              [NSThread sleepForTimeInterval:0.2];
             }
         
         
     }else
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all the details before proceeding" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [alert show];
     }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.tag =NO_NETWORK_ALERT;
        alert.delegate=self;
        [alert show];
    }
      //[self saveInCustomFile];
  
}
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag == NO_NETWORK_ALERT)
    exit(0);
}


- (IBAction)backBtnTapped:(id)sender {
    CGFloat width = subscriberScrollView.frame.size.width;
    NSInteger page = (subscriberScrollView.contentOffset.x + (0.5f * width)) / width;
    
    switch (page)
    {
        case 1:[subscriberScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            [backBtn setHidden:YES];
            break;
        case 2:[subscriberScrollView setContentOffset:CGPointMake(376, 0) animated:YES];
            [backBtn setHidden:NO];
            break;
    }
    
}
-(void) animateActivityWheel
{
    [activity startAnimating];
    
}

- (IBAction)skipSetupTapped:(id)sender {
    
//     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;

    [appDelegate NetworkStatus];
    [self performSelector:@selector(callSkipSetUp) withObject:nil afterDelay:1.0];
}

-(void) callSkipSetUp
{
     AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];

    if(appDelegate.nwStatus==YES)
    {

    if (self.isAboutYoudetailsFilled == TRUE) {
    
    [self saveInCustomFile];
        
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
        TransitViewController *transitVc = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
        [self presentViewController:transitVc animated:YES completion:nil];
        
    [NSThread detachNewThreadSelector:@selector(animateActivityWheel) toTarget:self withObject:nil];
        
//    TransitViewController *transitVc = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
//    [self presentViewController:transitVc animated:YES completion:nil];
     [activity stopAnimating];
     [NSThread sleepForTimeInterval:0.2];
    
           }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all the Details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        [alert show];
    }
}

-(BOOL) isAboutYoudetailsFilled {
    
    NSString *username=[data objectForKey:@"name"];
    NSInteger LivingNYSelectionIndex = 0;
    NSInteger VisitingNYSelectionIndex = 0;
    
    BOOL livingOptionNY = FALSE;
    BOOL livingOptionVisiting = FALSE;
    
    if ([liveinNY isOn]) {
        livingOptionNY = TRUE;
        if ([cityLivingSwitch isOn] || [suburbLivingSwitch isOn])
            LivingNYSelectionIndex = 1;
    }
    
    if ([visitingNY isOn]) {
        livingOptionVisiting = TRUE;
        if ([businessNYSwitch isOn] || [touristNYSwitch isOn])
            VisitingNYSelectionIndex = 1;
    }
    
    
    if ((username.length != 0) && (LivingNYSelectionIndex != 0 || VisitingNYSelectionIndex != 0)){
        [subscriberScrollView setScrollEnabled:YES];
        return TRUE;
    }else if (username.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter your name" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }else if ((username.length != 0) && (livingOptionNY == FALSE && livingOptionVisiting == FALSE)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter living option" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }else if ((username.length != 0) && (LivingNYSelectionIndex == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select atleast one persona from option" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }else if ((username.length != 0) && (VisitingNYSelectionIndex == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please select atleast one persona from option" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }else
        return FALSE;
    
    
}

-(BOOL) istransitPageDetailsFilled {
    
    
    if (self.homeAddrFld.text.length != 0 && self.workAddrFld.text.length != 0)
    {
        [subscriberScrollView setScrollEnabled:YES];
    
        return  TRUE;
    }else if ((subscriberScrollView.contentOffset.x >= 375 || subscriberScrollView.contentOffset.x < 700) && (self.homeAddrFld.text.length == 0 && self.workAddrFld.text.length != 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill Home Address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }else if ((subscriberScrollView.contentOffset.x >= 375 || subscriberScrollView.contentOffset.x < 700) && (self.homeAddrFld.text.length != 0 && self.workAddrFld.text.length == 0)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill Work Address" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return FALSE;
    }else
        return FALSE;
    
}

- (IBAction)continueTapped:(id)sender
{
    
    CGFloat width = subscriberScrollView.frame.size.width;
    NSInteger page = (subscriberScrollView.contentOffset.x + (0.5f * width)) / width;

    [self removeTimeView];
    if(usernameTxtFld.isFirstResponder)
        [usernameTxtFld resignFirstResponder];
    else if(homeAddrFld.isFirstResponder)
        [homeAddrFld resignFirstResponder];
    else if(workAddrFld.isFirstResponder)
        [workAddrFld resignFirstResponder];
    switch (page)
    {
        case 0:
            if(self.isAboutYoudetailsFilled == TRUE)
            {
                [subscriberScrollView setContentOffset:CGPointMake(376, 0) animated:YES];
                [backBtn setHidden:NO];
            }//else
//            {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all the details before proceeding" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [alert show];
//            }

            break;
        case 1:
            if(self.istransitPageDetailsFilled == TRUE)
            {
                [subscriberScrollView setContentOffset:CGPointMake(751, 0) animated:YES];
                [backBtn setHidden:NO];
            }else
            {
                if(self.homeAddrFld.text.length == 0 && self.workAddrFld.text.length == 0){
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please fill all the details before proceeding" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            }
            break;
    }
}


-(IBAction)getTime:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    if(btn.tag == LEAVE_HOME_BTN)
        leaveHomeBtnTapd = TRUE;
    else
        leaveHomeBtnTapd = FALSE;
    

    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(35,100,300,320)];

   

    [timePickerView setBackgroundColor:[UIColor whiteColor]];
    
    timelabel = [[UILabel alloc] init];
    timelabel.frame = CGRectMake(10, 10, 300, 40);
    timelabel.backgroundColor = [UIColor clearColor];
    timelabel.textColor = [UIColor blackColor];
    timelabel.font = [UIFont fontWithName:@"HelveticaNeue" size: 14.0];
    timelabel.textAlignment = NSTextAlignmentCenter;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    timelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:[NSDate date]]];
    
    [timePickerView addSubview:timelabel];
    timePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 50, 300, 200)];
    timePicker.datePickerMode = UIDatePickerModeTime;
    timePicker.hidden = NO;
    timePicker.date = [NSDate date];
    [timePicker addTarget:self
                   action:@selector(timeLabelChange)
         forControlEvents:UIControlEventValueChanged];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 270, 80, 30)];
    [cancelBtn setTitle:@"CANCEL" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(removeTimeView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(210, 270, 60, 30)];
    [okBtn setTitle:@"OK" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:134/255.0 blue:10/255.0 alpha:1.0] forState:UIControlStateNormal];
    //[okBtn addTarget:self action:@selector(createEvent) forControlEvents:UIControlEventTouchUpInside];
    [okBtn addTarget:self  action:@selector(addTime) forControlEvents:UIControlEventTouchUpInside];
    [timePickerView addSubview:cancelBtn];
    [timePickerView addSubview:okBtn];
    [timePickerView addSubview:timePicker];
    [self.view addSubview:timePickerView];
}

- (IBAction)showLocationPicker:(id)sender {
    
    if (tableViewhomeAddr) {
        [tableViewhomeAddr setHidden:YES];
    }
    if (tableViewworkAddr) {
        [tableViewworkAddr setHidden:YES];
    }
    
    UIButton *btn = (UIButton *) sender;
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    
    LocationPickerViewController *locationVc = [storyboard instantiateViewControllerWithIdentifier:@"locnPkrVireConrtoller"];
    [self presentViewController:locationVc animated:YES completion:nil];
    locationVc.delegate=self;
    if(btn.tag == HOME_ADDR_FLD)
            locationVc.homeAddress = FALSE;
      else
            locationVc.homeAddress = TRUE;
}

-(void) timeLabelChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"hh:mm a"];
    timelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:timePicker.date]];
}
-(void) removeTimeView
{
    if(timePickerView.isHidden == NO)
       [timePickerView removeFromSuperview];
}

-(void) addTime
{
    if(leaveHomeBtnTapd)
    {
        [leaveHomeTimeBtn setTitle:timelabel.text forState:UIControlStateNormal];
        leaveHomeBtnTapd = FALSE;
        [data setObject:timelabel.text forKey:@"depart_time"];
    }
    else
        [leaveWorkBtn setTitle:timelabel.text forState:UIControlStateNormal];
    
    [timePickerView removeFromSuperview];
}

@end
