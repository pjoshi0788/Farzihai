//
//  TimeTableViewController.m
//  MastercardFinal
//
//  Created by administrator on 28/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#define deviceWidth self.view.bounds.size.width
#define deviceHeight self.view.bounds.size.height

#import "TimeTableViewController.h"
#import "constant.h"
#import "TrainScheduleViewController.h"
#import "TransitViewController.h"
#import "JsonParsing.h"
#import "AppDelegate.h"

@interface TimeTableViewController ()
{
    UITableView *table;
    NSMutableArray *routeArray ;
    UIView *timePickerView;
    UILabel *timelabel;
    UIDatePicker *timePicker;
    
    NSArray *arrLIRRArray,*arrFromArray,*arrToArray;
         NSInteger DropDownBtnTag;
    BOOL originBtnSelected;
    BOOL TransitBtnSelected;
    BOOL destBtnSelected;
    
    BOOL dateBtnSelected;
}
@property(strong,nonatomic) GMSPolyline *polyline;
@end

@implementation TimeTableViewController
@synthesize timeTableMapView;
@synthesize storeData;
@synthesize TransitTypeDropDownReference,DestinationDropDownBtnReference,OriginDropDownBtnReference;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //*********** Three Drop Down ******************//
    

    
    arrLIRRArray=[[NSArray alloc] initWithObjects:@"  Long Island Rail Road", nil];
    arrFromArray=[[NSArray alloc] initWithObjects:@"  Penn Station", nil];
    arrToArray=[[NSArray alloc] initWithObjects:@"  Hicksville", nil];
    
    //************ EO DROP DOWN *******************//
    
    
    // Do any additional setup after loading the view.
    storeData=[[NSDictionary alloc]init];
    self.parseClass = [[JsonParsing alloc]init];
    self.storeData = [self.parseClass jsonTimeTableMapData];
    routeArray=[[NSMutableArray alloc]init];
    _myScrollView.frame = CGRectMake(0, 90, 375, 676);
    _myScrollView.contentSize = CGSizeMake(deviceWidth*3, 676);
    _myScrollView.scrollEnabled=YES;
    _myScrollView.pagingEnabled=YES;
     self.timeTableMapView.delegate =self;
    
    _RouteBtn.tag = ROUTE_TAB;
    _FavoritesBtn.tag = FAVORITES_TAB;
    _MapBtn.tag = MAP_TAB;
    
    _RouteBtnIndicator.backgroundColor=[UIColor redColor];
    _FavoritesBtnIndicator.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    _MapBtnIndicator.backgroundColor=[UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    
    
    _DateBtnReference.tag = DateBtn;
    _TimeBtnReference.tag = TimeBtn;
    
    originBtnSelected = FALSE;
    TransitBtnSelected=FALSE;
    dateBtnSelected = FALSE;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMM dd yyyy"];
    
    [_DateBtnReference setTitle:[NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    
    [df setDateFormat:@"hh:mm a"];
    
    [_TimeBtnReference setTitle:[NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]] forState:UIControlStateNormal];
    
   // [self plotMapRoute];
    
    _FavouriteLabel.hidden = TRUE;
   
    

    [_DepartSwitchReference setOn:NO];
    [_ArriveSwitchReference setOn:YES];
    
    _myScrollView.delegate = self;
    self.navigationItem.revealSidebarDelegate = self;
     [self plotRoute];
}

-(void)routePlotting:(int)count
{
    NSError *error=nil;
    NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    if (!error) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            for(int i=0;i<[routeArray count];i++)
            {
                Route *rt = [routeArray objectAtIndex:i];
                NSString *strEncodedPath= [rt points];
                GMSPath *path=[GMSPath pathFromEncodedPath:strEncodedPath];
                GMSPolyline *polyline = [[GMSPolyline alloc] init];
                polyline=[GMSPolyline polylineWithPath:path];
                [polyline setTappable:TRUE];
                
                if(i==0)
                {
                    polyline.strokeColor=[UIColor redColor];
                    polyline.strokeWidth=4;
                }
                else
                {
                    polyline.strokeColor=[UIColor grayColor];
                    polyline.strokeWidth=2;
                }
                
                polyline.map=self.timeTableMapView;
                
                [pathArray addObject:polyline];
            }
            
        }];
        
        
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

// table VIew delegates and Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    if (DropDownBtnTag == 10 )
        cell.textLabel.text = @"Long Island Rail Road";
    
    else if (DropDownBtnTag==20)
    {
    cell.textLabel.text=@"Penn Station";
    }
    else if(DropDownBtnTag==30)
    {
     cell.textLabel.text = @"Hicksville";
    }
    cell.backgroundColor=[UIColor blackColor];
    cell.textLabel.textColor=[UIColor whiteColor];
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (DropDownBtnTag == 10) {
        self.TransitTypeDropDownReference.titleLabel.text=[arrLIRRArray objectAtIndex:indexPath.row];
        [tableView removeFromSuperview];
        
     
    }
    else if (DropDownBtnTag == 20)
        {
         self.OriginDropDownBtnReference.titleLabel.text=[arrFromArray objectAtIndex:indexPath.row];
              [tableView removeFromSuperview];
        }
    
    else if (DropDownBtnTag == 30){
        self.DestinationDropDownBtnReference.titleLabel.text=[arrToArray objectAtIndex:indexPath.row];
          [tableView removeFromSuperview];
        
    }
}


#pragma mark SidebarViewControllerDelegate
- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    [self toggleRevealState:JTRevealedStateLeft];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger page = (_myScrollView.contentOffset.x + (0.5f * deviceWidth)) / deviceWidth;
    
    switch (page)
    {
        case 0:
            if (table) {
                table.hidden = TRUE;
            }
            _RouteBtnIndicator.backgroundColor = [UIColor redColor];
            _FavoritesBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            _MapBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 1:
            if (table) {
                table.hidden = TRUE;
            }
            _RouteBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            _FavoritesBtnIndicator.backgroundColor = [UIColor redColor];
            _MapBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            break;
        case 2:
            if (table) {
                table.hidden = TRUE;
            }
            _RouteBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            _FavoritesBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
            _MapBtnIndicator.backgroundColor = [UIColor redColor];
           

            break;
    }
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
    
    if (dateBtnSelected) {
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
    if (dateBtnSelected) {
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
    if(dateBtnSelected)
    {
        [_DateBtnReference setTitle:timelabel.text forState:UIControlStateNormal];
        dateBtnSelected = FALSE;
        
    }else
        [_TimeBtnReference setTitle:timelabel.text forState:UIControlStateNormal];
    
    [timePickerView removeFromSuperview];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)SideBarButton:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];    
}

- (IBAction)TabBtns:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    
    if (btn.tag == ROUTE_TAB) {
        if (table) {
            table.hidden = TRUE;
        }
        
        [_myScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _RouteBtnIndicator.backgroundColor = [UIColor redColor];
        _FavoritesBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];        _MapBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        
    }else if (btn.tag == FAVORITES_TAB){
        if (table) {
            table.hidden = TRUE;
        }

        [_myScrollView setContentOffset:CGPointMake(deviceWidth, 0) animated:YES];
        _RouteBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        _FavoritesBtnIndicator.backgroundColor = [UIColor redColor];
        _MapBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
    }
    else if (btn.tag == MAP_TAB){
        if (table) {
            table.hidden = TRUE;
        }

        [_myScrollView setContentOffset:CGPointMake(deviceWidth * 2, 0) animated:YES];
        _RouteBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        _FavoritesBtnIndicator.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:165.0/255.0 blue:30.0/255.0 alpha:1.0];
        _MapBtnIndicator.backgroundColor = [UIColor redColor];
        
//        [self plotRoute];
    }

    
}
-(void)routePlottingTimeTable:(int)count
{
    NSError *error=nil;
    if (!error) {
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            
            if ([self.storeData[@"routes"] count]) {
                NSString *strEncodedPath=self.storeData[@"routes"][0][@"overview_polyline"][@"points"];
                GMSPath *path=[GMSPath pathFromEncodedPath:strEncodedPath];
                NSLog(@"VALUE IN STORE %@",self.storeData);
                //                for (int j=0; j<=i; j++) {
                
                    self.polyline=[GMSPolyline polylineWithPath:path];
                    self.polyline.strokeWidth=3;
                    self.polyline.strokeColor=[UIColor redColor];
                    self.polyline.map=self.timeTableMapView;
            }
           
            
        }];
    }
    
}

-(void)plotRoute
{
//    Reachability *reachability = [Reachability reachabilityForInternetConnection];
//    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
//    
//    
//    [activity stopAnimating];
//    
//    if(networkStatus != NotReachable)
//    {

        TransitViewController *tvc=[[TransitViewController alloc]init];
    
        
        storeData=[[NSDictionary alloc]init];
        self.parseClass = [[JsonParsing alloc]init];
        self.storeData = [self.parseClass jsonTimeTableMapData];
        if([[self.storeData valueForKey:@"routes"] count] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else
        {
            [tvc createTransitData];
            [self routePlottingBtnClick];
            
            
            [self routePlottingTimeTable:1];
            
        }
  //  }
//    else
//    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        alert.delegate=self;
//        
//        [alert show];
//    }

}
-(NSMutableArray *)arrayLatLong
{
    NSArray *routes=storeData[@"routes"];
    NSArray *legs=routes[0][@"legs"];
    NSArray *steps=legs[0][@"steps"];
    NSString *html;
    NSMutableArray *arrSteps=[[NSMutableArray alloc] init];
    NSMutableArray *latlong=[[NSMutableArray alloc]init];
    NSString *finalString;
    
    for(int i=0; i< [steps count]; i++){
        html=steps[i][@"html_instructions"];
        
        NSString *stringFormatter = [html stringByReplacingOccurrencesOfString:@"[<b>]+[</b>]"
                                                                    withString:@""
                                                                       options:NSRegularExpressionSearch
                                                                         range:NSMakeRange(0, html.length)];
        
        finalString = [stringFormatter stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [latlong addObject:steps[i][@"end_location"]];
        [arrSteps addObject:finalString];
    }
    return latlong;
}

-(void)routePlottingBtnClick
{
    CLLocationCoordinate2D location;
    
    
    if([[self.storeData valueForKey:@"routes"] count])
    {
        for (NSDictionary *dictionary in [self arrayLatLong])
        {
            location.latitude = [dictionary[@"lat"] floatValue];
            location.longitude = [dictionary[@"lng"] floatValue];
        }
        
        
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:location.latitude
                                                                longitude:location.longitude
                                                                     zoom:8];
        self.timeTableMapView.camera=camera;
        self.timeTableMapView.mapType = kGMSTypeNormal;
        self.timeTableMapView.delegate=self;
        
        //     Creates a marker in the center of the map.
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        tempArray = [storeData valueForKey:@"routes"];
        Route *route = [[Route alloc] init];
        for(int i=0; i<[tempArray count]; i++)
        {
        NSDictionary *legDict = [[[tempArray objectAtIndex:i] valueForKey:@"legs"] objectAtIndex:0];
        
        
  
        
        route.startLat = [[legDict  valueForKey:@"start_location"] valueForKey:@"lat"];
        route.startLon = [[legDict  valueForKey:@"start_location"] valueForKey:@"lng"];
        
        route.endLat = [[legDict  valueForKey:@"end_location"] valueForKey:@"lat"];
        route.endLon = [[legDict  valueForKey:@"end_location"] valueForKey:@"lng"];
            
        [routeArray addObject:route];
    }
        
        
        
        
        GMSMarker *start_marker = [[GMSMarker alloc] init];
        start_marker.position = CLLocationCoordinate2DMake([[[routeArray firstObject] startLat] doubleValue], [[[routeArray firstObject] startLon] doubleValue]);
        start_marker.map = self.timeTableMapView;
        start_marker.icon = [GMSMarker markerImageWithColor:[UIColor orangeColor]];
        
        GMSMarker *end_marker = [[GMSMarker alloc] init];
        end_marker.position = CLLocationCoordinate2DMake([[[routeArray firstObject] endLat] doubleValue], [[[routeArray firstObject] endLon] doubleValue]);
        end_marker.map = self.timeTableMapView;
        
       
        
    }
    
}


- (IBAction)DepartSwitch:(id)sender {
    
    if ([sender isOn]) {
        [_DepartSwitchReference setOn:YES animated:YES];
        [_ArriveSwitchReference setOn:NO animated:YES];
    }else {
        [_DepartSwitchReference setOn:NO animated:YES];
        [_ArriveSwitchReference setOn:YES animated:YES];
    }
}

- (IBAction)ArriveSwitch:(id)sender {
    
    if ([sender isOn]) {
        [_DepartSwitchReference setOn:NO animated:YES];
        [_ArriveSwitchReference setOn:YES animated:YES];
    }else {
        [_DepartSwitchReference setOn:YES animated:YES];
        [_ArriveSwitchReference setOn:NO animated:YES];
    }
}

- (IBAction)SetDateTimeBtn:(id)sender {

    UIButton *btn = (UIButton *) sender;

    if (btn.tag == DateBtn) {
        dateBtnSelected = TRUE;
        [self getTime];
    }else
        [self getTime];
    
}

- (IBAction)StationDropDown:(id)sender {
    
   
    
    UIButton *btn = (UIButton *) sender;
    if(!table)
    table = [[UITableView alloc] initWithFrame:CGRectMake(4, 83, 364, 55) style:UITableViewStylePlain];
    
    table.dataSource = nil;
    table.hidden = FALSE;
    
    if (btn.tag==10) {
        DropDownBtnTag=btn.tag;
        if (table.frame.origin.y == 162 || table.frame.origin.y == 240 ) {
            table.hidden = TRUE;
        }
        
        
        table.frame = CGRectMake(4, 83, 364, 55);
    [_myScrollView addSubview:table];
    }
    
    else  if (btn.tag == 20) {
        if (table.frame.origin.y == 83 || table.frame.origin.y == 240 ) {
            table.hidden = TRUE;
        }
        DropDownBtnTag=btn.tag;
        table.frame = CGRectMake(4, 162, 364, 55);
        [_myScrollView addSubview:table];
    }

    else if (btn.tag==30) {
        if (table.frame.origin.y == 162 || table.frame.origin.y == 83 ) {
            table.hidden = TRUE;
        }
       
        DropDownBtnTag=btn.tag;
        table.frame = CGRectMake(4, 240, 364, 55);
        [_myScrollView addSubview:table];
    }
    table.dataSource = self;
    table.delegate = self;
    table.hidden = FALSE;
}
- (IBAction)GetScheduleBtn:(id)sender {
    
    _FavouriteLabel.hidden = FALSE;
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TrainScheduleViewController *locationVc = [storyboard instantiateViewControllerWithIdentifier:@"trainScheduleViewController"];
    [self presentViewController:locationVc animated:YES completion:nil];
    
}
@end
