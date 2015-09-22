//
//  widgetViewController.m
//  mtaWidget
//
//  Created by Prateek on 6/8/15.
//  Copyright (c) 2015 matrix. All rights reserved.
//
#import "AppDelegate.h"
#define DeviceWidth self.view.bounds.size.width
#define DeviceHeight self.view.bounds.size.height
#import "widgetViewController.h"
#import "MtaInfoTableViewCell.h"
#import "SubwayTableViewCell.h"
#import "AppDelegate.h"
#define kGOOD_SERVICE @"\n    GOOD SERVICE"

#define kSERVICE_CHANGE @"\n    SERVICE CHANGE"
#define kPLANNED_WORK @"\n    PLANNED WORK"
#define kDELAY @"\n    DELAYS"
#import "constant.h"

#define kIMG_GOOD_SERVICE @"busGoodService1.png"
#define kIMG_SERVICE_CHANGE @"busServiceChange1.png"
#define kIMG_PLANNED_WORK @"busDelay1.png"
#define kIMG_BG_VIEW @"/Users/matrix/Documents/GIT CODE/mtaWidget 2/Notification-List/MTA-QR-Ticket-bg.png"
#define kTransitUrl @"https://maps.googleapis.com/maps/api/directions/json?"
@interface widgetViewController ()

@end


@implementation widgetViewController
@synthesize dictLine,arrSubway,arrBus,arrLineData,arrLirr,mstrXMLString,arrTableData,arrBt,topView,scrollViewNotifyFeed;
@synthesize mtaSelectionView,socialFeedSelectionView,newsFeedSelectionView,socialLogInButton,newsLogInButton;
@synthesize imgRoute;

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self getDataFromServer];
    [self constructAssetDict];
    
   // [topView setFrame:CGRectMake(0, 0, 414, 45)];
    [self setupTabSelection:0];

    //[topView setFrame:CGRectMake(0, 0, 414, 55)];
    
     self.scrollViewNotificationFeed.delegate=self;
    [self.scrollViewNotificationFeed setContentSize:CGSizeMake(1128, 564)];
    [self.scrollViewNotificationFeed setScrollEnabled:YES];
    [self.scrollViewNotificationFeed setPagingEnabled:YES];
    
    currDict = [[NSMutableDictionary alloc] init];
    busDict = [[NSMutableDictionary alloc] init];
    subwayDict = [[NSMutableDictionary alloc] init];
    socialFeedArray=[[NSMutableArray alloc] init];
    //self.scrollViewNotificationFeed.backgroundColor = [UIColor clearColor];
     [self loadSocialFeedTab];
     [self loadNewsFeedTab];
    
    
    tblMtaInfo = [[UITableView alloc] initWithFrame:CGRectMake(0,0,375,564)];
  
    tblMtaInfo.delegate=self;
    tblMtaInfo.dataSource=self;
    
    [self.scrollViewNotificationFeed addSubview:tblMtaInfo];
   
    [tblMtaInfo registerNib:[UINib nibWithNibName:@"SubwayTableViewCell" bundle:nil ] forCellReuseIdentifier:@"subwayCell"];
    
    [tblMtaInfo registerNib:[UINib nibWithNibName:@"MtaInfoTableViewCell" bundle:nil ] forCellReuseIdentifier:@"mtaCell"];
    [tblMtaInfo setSeparatorStyle:UITableViewCellSeparatorStyleNone];
   
    self.navigationItem.revealSidebarDelegate=self;
}


#pragma  mark -Data from URL
-(void) myRouteData
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *userinfo_dic=[appDelegate UserinfoplistContent:NO];
    
    NSLog(@"Home Address = %@", [userinfo_dic valueForKey:@"homeAddress"]);
    NSLog(@"Work Address = %@", [userinfo_dic valueForKey:@"workAddress"]);
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:MM"];
    int hours =[[[userinfo_dic valueForKey:@"depart_time"] substringToIndex:2] intValue];
    int minutes = [[[userinfo_dic valueForKey:@"depart_time"] substringWithRange:NSMakeRange(3, 2)] intValue];
    long totalSec = hours*3600 + minutes*60;
    int seconds = [[[NSDate date] dateByAddingTimeInterval:totalSec] timeIntervalSinceReferenceDate];
//    double milliseconds = seconds*1000;
    
    
    NSString *subwayURLString=[NSString stringWithFormat:@"%@origin=%@&destination=%@&departure_time=%d&mode=transit&alternatives=true",kTransitUrl,[userinfo_dic valueForKey:@"homeAddress"], [userinfo_dic valueForKey:@"workAddress"],seconds];
    
    NSURL *subwayURL=[NSURL URLWithString:[subwayURLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    //Create mutable HTTP reques    t
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:subwayURL];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    
    NSOperationQueue *queue=[[NSOperationQueue alloc]init];
   
    [NSURLConnection
     sendAsynchronousRequest:urlRequest
     queue:queue
     completionHandler:^(NSURLResponse *response,
                         NSData *data,
                         NSError *error) {
         
         //looks like we received some data from the server
         if ([data length] >0 && error == nil){
             
             [self parseTransitData:data];
             [tblMtaInfo reloadData];
         }
         
             }];
    
   
}


-(void) parseTransitData:(NSData*)data
{
     NSDictionary *transitDict;
    NSError *er=nil;
  
    transitDict =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&er];
    
     NSDictionary *routeDict = [transitDict valueForKey:@"routes"];
    
   NSArray *shortNameDict = [routeDict valueForKeyPath:@"legs.steps.transit_details.line.short_name"];
    
    //.storeData[@"routes"][0][@"overview_polyline"][@"points"];
    NSMutableArray *namesArr = [[NSMutableArray alloc] init];
    for(int i=0;i<[shortNameDict count];i++)
    {
        NSLog(@"Short_name = %@", shortNameDict[i][0]);
        
        
        for(int j=0;j<[shortNameDict[i][0] count];j++)
            if(![shortNameDict[i][0][j] isKindOfClass:[NSNull class]])
               [namesArr addObject:shortNameDict[i][0][j]];
    }
    
     NSLog(@"Names = %@", namesArr);
    
     myRouteDict= [[NSMutableDictionary alloc] init];
    myRouteArr = [[NSMutableArray alloc] init];
    for(int k=0;k<[namesArr count];k++)
    {
        
        for(int i=0;i<[busArray count];i++)
        {
            NSString *chStr = [namesArr[k] substringToIndex:1];
            
            if([[busArray objectAtIndex:i] rangeOfString:chStr].location != NSNotFound)
            {
                [myRouteDict setValue:@"B" forKey:namesArr[k]];
                [myRouteArr addObject:namesArr[k]];
                break;
            }
        }
        
        for(int i=0;i<[subwayArray count];i++)
        {
            if([[subwayArray objectAtIndex:i] rangeOfString:namesArr[k]].location != NSNotFound)
            {
                [myRouteDict setValue:@"S" forKey:namesArr[k]];
                [myRouteArr addObject:namesArr[k]];
                break;
            }
        }
        
        for(int i=0;i<[tempArrayTrainAndMetroNoth count];i++)
        {
            if([namesArr[k] length] > 1)
            {
                if([[tempArrayTrainAndMetroNoth objectAtIndex:i] rangeOfString:namesArr[k]].location != NSNotFound)
                {
                    [myRouteDict setValue:@"T" forKey:namesArr[k]];
                    break;
                }
            }
        }
        
    }
    
     NSLog(@"myRouteArray = %@", myRouteArr);
    NSOrderedSet *orderedSet = [NSOrderedSet orderedSetWithArray:myRouteArr];
    
    finalRouteArray = [orderedSet array];
   
    
   
    
}
-(void)getDataFromServer
{
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        NSString *subwayURLString=@"http://web.mta.info/status/serviceStatus.txt";
        
        NSURL *subwayURL=[NSURL URLWithString:subwayURLString];
        
        //Create mutable HTTP reques    t
        NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:subwayURL];
        
        [urlRequest setTimeoutInterval:30.0f];
        [urlRequest setHTTPMethod:@"POST"];
        
        NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        
        [NSURLConnection
         sendAsynchronousRequest:urlRequest
         queue:queue
         completionHandler:^(NSURLResponse *response,
                             NSData *data,
                             NSError *error) {
             

             //looks like we received some data from the server
             if ([data length] >0 && error == nil){
                 
                 //convert the data to string so that we can display in console log
                 
                 [self parseXMLData:data];
                 
             }
             else if ([data length] == 0 && error == nil){
                 NSLog(@"Empty Response");
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Delays deatils not available." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
             }
             else if (error != nil){
                 NSLog(@"error: %@", [error localizedDescription]);
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];
             }
        [self myRouteData];
        [tblMtaInfo reloadData];
        
         }];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
   
   
    [self performSelector:@selector(reloadMtaTable) withObject:nil afterDelay:2.0];
}

-(void) reloadMtaTable
{
    [tblMtaInfo reloadData];
}

-(void) constructAssetDict
{
    assetDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1.png",@"1",@"2.png",@"2",@"3.png",@"3",@"4.png",@"4",@"5.png",@"5",@"6.png",@"6",@"7.png",@"7",@"a.png",@"A",@"b.png",@"B",@"c.png",@"C",@"d.png",@"D",@"e.png",@"E",@"f.png",@"F",@"g.png",@"G",@"j.png",@"J",@"m.png",@"M",@"n.png",@"N",@"q.png",@"Q",@"r.png",@"R",@"s.png",@"S",@"t.png",@"T",@"z.png",@"Z",@"l.png",@"L", nil];
}

- (void) parseXMLData:(NSData *) xml {
    self.xmlParser = [[NSXMLParser alloc] initWithData:xml];
    
    self.xmlParser.delegate = self;
    
    if ([self.xmlParser parse]){
        dispatch_async(dispatch_get_main_queue(), ^{
           // arrCurrent = arrSubway;
            

            arrTableData = arrSubway;
            [tblMtaInfo reloadData];

        });
        
       
    }
    else{
        NSLog(@"XML parsing failed");
    }
    
    
}

//************************ Parsing delegates **********************//



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    elementName =   [elementName lowercaseString];


    if([elementName isEqualToString:@"bus"])
    {
        
       // arrCurrent= [[NSMutableArray alloc]init];
        currDict = [[NSMutableDictionary alloc] init];

    }
    
    if([elementName isEqualToString:@"subway"])
    {

         currDict = [[NSMutableDictionary alloc] init];
    }
    else if([elementName isEqualToString:@"lirr"])
    {
        currDict = [[NSMutableDictionary alloc] init];

    }
    if([elementName isEqualToString:@"metronorth"])
    {
        currDict = [[NSMutableDictionary alloc] init];
        
    }

}
//**************************************** Found  Parsing the content ******************************//

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    
   
    mstrXMLString=[[NSMutableString alloc]init];
    [mstrXMLString appendString:string];
    
}

//**************************************** End Parsing the content ******************************//
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    
    elementName =   [elementName lowercaseString];


    if ([elementName isEqualToString:@"bus"]){
  
        busDict = [[NSMutableDictionary alloc] initWithDictionary:currDict];
        busArray = [[NSMutableArray alloc] initWithArray:[busDict allKeys]];
       }
    else if([elementName isEqualToString:@"subway"])
    {
        subwayDict = [[NSMutableDictionary alloc] initWithDictionary:currDict];
        subwayArray = [[NSMutableArray alloc] initWithArray:[subwayDict allKeys]];
    }
    
    else if([elementName isEqualToString:@"metronorth"])
    {
        metroNorth = [[NSMutableDictionary alloc] initWithDictionary:currDict];
        metroArray=[[NSMutableArray alloc] initWithArray:[metroNorth allKeys]];
        
        
        tempDictTrainAndMetroNorth=[[NSMutableDictionary alloc]initWithDictionary:btDict];
        [tempDictTrainAndMetroNorth addEntriesFromDictionary:metroNorth];
        
        
        tempArrayTrainAndMetroNoth = [NSMutableArray arrayWithArray:trainArray];
        [tempArrayTrainAndMetroNoth addObjectsFromArray:metroArray];
    }
    else if([elementName isEqualToString:@"lirr"])
    {
        btDict = [[NSMutableDictionary alloc] initWithDictionary:currDict];
        trainArray = [[NSMutableArray alloc] initWithArray:[btDict allKeys]];
        
    }
   

    else if([elementName isEqualToString:@"name"])
    {
        currLineName = [[NSString alloc] initWithString:mstrXMLString];
    }
    else if([elementName isEqualToString:@"status"])
    {
        [currDict setValue:mstrXMLString forKey:currLineName];
         
   }
    
}




-(void) segmentIndexChanged:(id)sender
{
    
    if([_segmentBar selectedSegmentIndex] == 0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [tblMtaInfo reloadData];
        });
        
        
    }
    if ([_segmentBar selectedSegmentIndex] == 1)
    {
        
        [tblMtaInfo reloadData];
        
    }
    //    if ([_segmentBar selectedSegmentIndex] == 2)
    //    {
    //        arrTableData = arrBus;
    //        [_tblMtaInfo reloadData];
    //
    //    }
    //    if ([_segmentBar selectedSegmentIndex] == 3)
    //    {
    //        arrTableData = arrBt;
    //        [_tblMtaInfo reloadData];
    //
    //    }
    
    for (int i=0; i<[_segmentBar.subviews count]; i++)
    {
        if ([[_segmentBar.subviews objectAtIndex:i]isSelected] )
        {
            UIColor *tintcolor=[UIColor colorWithRed:0 green:103.0/255.0 blue:177.0/255.0 alpha:1.0];
            [[_segmentBar.subviews objectAtIndex:i] setTintColor:tintcolor];
        }
        else
        {
            [[_segmentBar.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
    
}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"openTabBar"]) {
        tabBarController = [segue destinationViewController];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *str ;
    
    if (tableView == tblMtaInfo)
    {
        
        if (section==0)
        {   if([finalRouteArray count]==0)
            str= @"No Relevant Routes";
            else
                str= @"My Routes";
        }
        else if(section ==1)
            str= @"Bus";
        else if(section ==2)
            str= @"Train";
        else if (section ==3)
            str = @"Subway";
    }
    
    else if (tableView == tblSocialFeedInfo)
    {
        str= @"";
    }
    
    else if (tableView == tblNewsFeedInfo)
    {
        str= @"";
    }
    else
        str= @"";
    
    
    //    else if(section ==3)
    //        str= @"BT";
    
    return str;
    
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//
//
//    NSString *str ;
//    if (section==0)
//        str= @"Bus";
//    else if(section ==1)
//        str= @"Train";
//    else if(section ==2)
//        str= @"Subway";
//    else if(section ==3) 
//        str= @"BT";
//
//
//    UILabel *label = [[UILabel alloc] init];
//    label.frame = CGRectMake(5, -5, 100, 30);
//    label.textColor=[UIColor whiteColor];
//
//    label.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
//    label.text = str;
//
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
//    view.backgroundColor = [UIColor colorWithRed:192.0/255.0 green:192.0/255.0 blue:192.0/255.0 alpha:1.0];
//    [view addSubview:label];
//
//    return view;
//
//
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == tblMtaInfo)
    {
        return 4;
    }
    
    else if (tableView == tblSocialFeedInfo)
    {
        return 1;
    }
    
    else if (tableView == tblNewsFeedInfo)
    {
        return 1;
    }
    else
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if (tableView == tblMtaInfo)
    {
        if (section==0) {
            
            return [finalRouteArray count];
            
        }
        else   if (section==1) {
            
            
            return [busArray count];
        }
        else   if (section==2) {
            
            
            return [tempArrayTrainAndMetroNoth count];
        }
        else   if (section==3) {
            
            
            return [subwayArray count];
        }

        else
            return 1;
    }
    
    else if (tableView == tblSocialFeedInfo)
    {
        return socialFeedArray.count;
    }
    
    else if (tableView == tblNewsFeedInfo)
    {
        return newsFeedArray.count;
    }
    else
        return 1;
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblMtaInfo)
    {
        return 60.0;
    }
    
    else if (tableView == tblSocialFeedInfo)
    {
        return 120.0;
    }
    
   else  if (tableView == tblNewsFeedInfo)
    {
        return 120.0;
    }
    else
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tblMtaInfo)
    {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     static NSString *CellIdentifierMta = @"mtaCell";
    static NSString *subwayCellId = @"subwayCell";
    

    if (tableView==tblMtaInfo) {
        MtaInfoTableViewCell *transitCell = (MtaInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierMta];

        
        if(transitCell==nil)
        {
            transitCell = [[MtaInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierMta];
        }
        if(indexPath.section==0)
        {
            transitCell.mtaName.text = [finalRouteArray objectAtIndex:indexPath.row];
            
            if([[myRouteDict valueForKey:[finalRouteArray objectAtIndex:indexPath.row]] isEqualToString:@"S"])
            {
                transitCell.mtaType.image = [UIImage imageNamed:@"subway-2.png"];
            }
            else if([[myRouteDict valueForKey:[finalRouteArray objectAtIndex:indexPath.row]] isEqualToString:@"B"])
            {
                if ([transitCell.mtaStatus.text isEqualToString:@"DELAYS"]) {
                    
                    transitCell.mtaStatus.textColor=[UIColor redColor];
                    transitCell.mtaType.image = [UIImage imageNamed:@"mta_bus4.png"];
                }
                else
                {
                      transitCell.mtaType.image = [UIImage imageNamed:@"Bus.png"];
                    transitCell.mtaStatus.textColor=[UIColor blackColor];
                }
            }
            else if([[myRouteDict valueForKey:[finalRouteArray objectAtIndex:indexPath.row]] isEqualToString:@"T"])
            {
                if ([transitCell.mtaStatus.text isEqualToString:@"DELAYS"]) {
                    
                    transitCell.mtaStatus.textColor=[UIColor redColor];
                     transitCell.mtaType.image = [UIImage imageNamed:@"train3.png"];
                }
                else
                {
                transitCell.mtaType.image = [UIImage imageNamed:@"train-1.png"];
                     transitCell.mtaStatus.textColor=[UIColor blackColor];
                }
                
            }
            
        }
        if (indexPath.section==1) {
        
       
        transitCell.mtaName.text = [busArray objectAtIndex:indexPath.row];
        transitCell.mtaStatus.text = [busDict valueForKey:[busArray objectAtIndex:indexPath.row]];
            if ([transitCell.mtaStatus.text isEqualToString:@"DELAYS"]) {
                
                transitCell.mtaStatus.textColor=[UIColor redColor];
                transitCell.mtaType.image = [UIImage imageNamed:@"mta_bus4.png"];
            }
            else
            {
                 transitCell.mtaType.image = [UIImage imageNamed:@"Bus.png"];
                 transitCell.mtaStatus.textColor=[UIColor blackColor];
            }
            
            
        }
        else if (indexPath.section==2) {
            
            
            transitCell.mtaName.text = [tempArrayTrainAndMetroNoth objectAtIndex:indexPath.row];
            transitCell.mtaStatus.text = [tempDictTrainAndMetroNorth valueForKey:[tempArrayTrainAndMetroNoth objectAtIndex:indexPath.row]];
            
            if ([transitCell.mtaStatus.text isEqualToString:@"DELAYS"]) {
                
                transitCell.mtaStatus.textColor=[UIColor redColor];
                transitCell.mtaType.image = [UIImage imageNamed:@"train3.png"];
            }
            else
            {
                transitCell.mtaType.image = [UIImage imageNamed:@"train-1.png"];
                if([[tempArrayTrainAndMetroNoth objectAtIndex:indexPath.row] isEqualToString:@"Waterbury"])
                    transitCell.mtaType.image = [UIImage imageNamed:@"train-2.png"];
                
                transitCell.mtaStatus.textColor=[UIColor blackColor];
            }
            
        }
        else if(indexPath.section==3)
        {
            
           SubwayTableViewCell  *subwayCell = (SubwayTableViewCell*)[tableView dequeueReusableCellWithIdentifier:subwayCellId];
            
            
            if(subwayCell==nil)
            {
                subwayCell = [[SubwayTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:subwayCellId];
            }
            
            subwayCell.imageType.image = [UIImage imageNamed:@"subway-2.png"];
            NSString *mtaName = [subwayArray objectAtIndex:indexPath.row];
            
            for(int i=0;i<[mtaName length];i++)
            {
                NSString *ch = [mtaName substringWithRange:NSMakeRange(i,1)];
                
                if(i==0)
                    subwayCell.imageName1.image = [UIImage imageNamed:[assetDict valueForKey:ch]];
                
                if(i==1)
                    subwayCell.imageName2.image = [UIImage imageNamed:[assetDict valueForKey:ch]];
                    
                if(i==2)
                    subwayCell.imageName3.image = [UIImage imageNamed:[assetDict valueForKey:ch]];
                    
                if(i==3)
                    subwayCell.imageName4.image = [UIImage imageNamed:[assetDict valueForKey:ch]];
                
            }
        subwayCell.statusLbl.text = [subwayDict valueForKey:[subwayArray objectAtIndex:indexPath.row]];
            
            return subwayCell;
        }
        return transitCell;
    }
    
    return cell;
    } else if (tableView == tblSocialFeedInfo)
    {
        static NSString *CellIdentifier = @"socialFeedCell";
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        UILabel *tweetLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 30)];
        tweetLabel.text=[[socialFeedArray objectAtIndex:indexPath.row] valueForKey:@"profileName"];
        UIImageView *tweetIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        if([[[socialFeedArray objectAtIndex:indexPath.row] valueForKey:@"profileName"] containsString:@"MTA"]){
             tweetIcon.image = [UIImage imageNamed:@"mta_logo.png"];
        }else{
             tweetIcon.image = [UIImage imageNamed:@"silhouette_icon1.png"];
        }
       
        UILabel *tweetText=[[UILabel alloc] initWithFrame:CGRectMake(60, 40, 300, 70)];
        
        tweetText.numberOfLines=3;
        tweetText.text=[[socialFeedArray objectAtIndex:indexPath.row] valueForKey:@"text"];

       UILabel *dateLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 110, 300, 10)];
       // dateLbl.text = [[socialFeedArray objectAtIndex:indexPath.row] valueForKey:@"createdAt"];
       // [dateLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:8]];
        [cell.contentView addSubview:dateLbl];
         [cell.contentView addSubview:tweetIcon];
         [cell.contentView addSubview:tweetLabel];
         [cell.contentView addSubview:tweetText];
        
        return cell;
    }
    
    else  if (tableView == tblNewsFeedInfo)
    {
        static NSString *CellIdentifier = @"newsFeedCell";
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        UIImageView *tweetIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        tweetIcon.image = [UIImage imageNamed:@"silhouette_icon1.png"];
        
        UILabel *tweetLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 300, 30)];
        tweetLabel.text=[[newsFeedArray objectAtIndex:indexPath.row] valueForKey:@"profileName"];
        UILabel *tweetText=[[UILabel alloc] initWithFrame:CGRectMake(60, 40, 300, 70)];
        
        tweetText.numberOfLines=3;
        tweetText.text=[[newsFeedArray objectAtIndex:indexPath.row] valueForKey:@"text"];
        
        [cell.contentView addSubview:tweetIcon];
        [cell.contentView addSubview:tweetLabel];
        [cell.contentView addSubview:tweetText];

        
        return cell;

    }else
    {
        static NSString *CellIdentifier = @"default";
        UITableViewCell *cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //static NSString *CellIdentifierMta = @"mtaCell";
        return cell;
    }
    
    
}


- (IBAction)segmentBarClicked:(id)sender {
}
#pragma mark JTRevealSidebarDelegate
// This is an examle to configure your sidebar view without a UIViewController
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



- (IBAction)btnToggleView:(id)sender {
    [self toggleRevealState:JTRevealedStateLeft];
}

-(void) setupTabSelection:(NSInteger)btnIndex{
    switch (btnIndex) {
        case 0:
            mtaSelectionView.backgroundColor=[UIColor redColor];
            //[customAlertview setBackgroundColor:[UIColor colorWithRed:251 green:181 blue:40 alpha:1]];
            socialFeedSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            newsFeedSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            break;
        case 1:
            mtaSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            socialFeedSelectionView.backgroundColor=[UIColor redColor];
            newsFeedSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            
            break;
        case 2:
            mtaSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            socialFeedSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            newsFeedSelectionView.backgroundColor=[UIColor redColor];
            break;
            
        default:
            mtaSelectionView.backgroundColor=[UIColor redColor];
            socialFeedSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            newsFeedSelectionView.backgroundColor=[UIColor colorWithRed:251.0/255.0 green:181.0/255.0 blue:40.0/255.0 alpha:1.0];
            break;
    }

}


- (IBAction)tabBtnTapped:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == MTA_TAB)
    {
        [self.socialLogInButton setHidden:YES];
        [self.newsLogInButton setHidden:YES];
        [self setupTabSelection:0];
        
        //[subscriberScrollView setContentOffset:CGPointMake(416, 0) animated:YES];
        [self.scrollViewNotificationFeed setContentOffset:CGPointMake(0, 0) animated:YES];
       
    }
    else if(btn.tag == SOCIAL_TAB)
    {
         [self setupTabSelection:1];
        if ([[Twitter sharedInstance] session]) {
            if (self.socialLogInButton!=NULL) {
                [self.socialLogInButton setHidden:YES];
            }
            if (self.newsLogInButton!=NULL) {
                [self.newsLogInButton setHidden:YES];
            }
            
        }else{
            if (self.socialLogInButton!=NULL) {
                [self.socialLogInButton setHidden:NO];
            }
            if (self.newsLogInButton!=NULL) {
                [self.newsLogInButton setHidden:NO];
            }}

            // [self loadSocialFeedTab];
      
        [self.scrollViewNotificationFeed setContentOffset:CGPointMake(376, 0) animated:YES];
        
    }
    else if(btn.tag == NEWS_TAB)
    {
        if ([[Twitter sharedInstance] session]) {
            if (self.socialLogInButton!=NULL) {
                [self.socialLogInButton setHidden:YES];
            }
            if (self.newsLogInButton!=NULL) {
                [self.newsLogInButton setHidden:YES];
            }
            
        }else{
            if (self.socialLogInButton!=NULL) {
                [self.socialLogInButton setHidden:NO];
            }
            if (self.newsLogInButton!=NULL) {
                [self.newsLogInButton setHidden:NO];
            }}

         [self setupTabSelection:2];
       // [self loadNewsFeedTab];
    
        [self.scrollViewNotificationFeed setContentOffset:CGPointMake(752, 0) animated:YES];
       
    }
}


-(void) loadTwitter:(NSString*) searchText {
    NSLog(@"search text : %@", searchText);
    
   // NSString *searchAPIUrl=@"https://api.twitter.com/1.1/search/tweets.json";
    // NSString *searchAPIUrl=@"https://api.twitter.com/1.1/users/show.json?screen_name=twitterdev";
    //NSDictionary *params = NULL;
    
    NSString *searchAPIUrl=@"https://api.twitter.com/1.1/statuses/user_timeline.json";
    NSDictionary *params = @{@"screen_name" : searchText,
                             @"count":@"20"};
    NSError *clientError;
    
    
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:searchAPIUrl parameters:params error:&clientError];
    
    if (request) {
        [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if(!connectionError){
            if (data) {
                // handle the response data e.g.
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                ///NSLog(@"data: %@", json);
               
                for (int i=0; i<json.count; i++) {
                    NSDictionary *tweetData=json[i];
                    NSString *statusText=[tweetData valueForKey:@"text"];
                    NSString *createdAt=[tweetData valueForKey:@"created_at"];
                    NSDictionary *userDic=[tweetData valueForKey:@"user"];
                    NSString *name=[userDic valueForKey:@"name"];
                    NSString *screenName=[userDic valueForKey:@"screen_name"];
                    NSString *tweetLabel = [name stringByAppendingString:[@" @" stringByAppendingString:screenName]];
                    
                    
                    
                    
                   // NSLog(@"CREATED AT = %@",  createdAt);
                    
                    NSMutableDictionary *tweetDictionary=[[NSMutableDictionary alloc] init];
                    [tweetDictionary setObject:statusText forKey:@"text"];
                    [tweetDictionary setObject:tweetLabel forKey:@"profileName"];
                    [tweetDictionary setObject:name forKey:@"name"];
                    [tweetDictionary setObject:createdAt forKey:@"createdAt"];
                    [socialFeedArray addObject:tweetDictionary];
                    if(i==(json.count-1)){
                        if([searchText isEqualToString:@"MTA"]){
                            [self loadTwitter:@"LIRR"];
                            
                        }
                        if([searchText isEqualToString:@"LIRR"]){
                            [self loadTwitter:@"MetroNorth"];
                        }
                        if([searchText isEqualToString:@"MetroNorth"]){
                            [self loadTwitter:@"NYCTSubway"];
                            //  [self loadSocialList];
                        }
                        if([searchText isEqualToString:@"NYCTSubway"]){
                            [self loadSocialList];
                        }
                    }
                }
              
            }}
            else {
                 NSLog(@"connectionError: %@", connectionError);
                if ([searchText containsString:@"MTA" ]) {
                  //  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[connectionError localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                   // [alert show];
                }else
                [self loadSocialList];
            }
        }];
       
    }
    else {
        NSLog(@"clientError: %@", clientError);
        //if ([searchText containsString:@"MTA" ]) {
            
       // }else
            //[self loadSocialList];

    }
}



-(void)loadSocialList
{
    
    //NSSortDescriptor *sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"createdAt"
                                                           //      ascending:YES];
   // NSArray *sortDescriptors = [NSArray arrayWithObject:sortByDate];
  //  NSArray *sortedArray = [socialFeedArray sortedArrayUsingDescriptors:sortDescriptors];
    
   // [socialFeedArray removeAllObjects];
    //socialFeedArray = [[NSMutableArray alloc] initWithArray:sortedArray copyItems:YES];
    
    
    tblSocialFeedInfo = [[UITableView alloc] initWithFrame:CGRectMake(375,0,375,564) style:UITableViewStylePlain];
    tblSocialFeedInfo.sectionFooterHeight = 0;
    tblSocialFeedInfo.delegate=self;
    tblSocialFeedInfo.dataSource=self;
    //[tblSocialFeedInfo reloadData];
    [self.scrollViewNotificationFeed addSubview:tblSocialFeedInfo];

}


-(void) loadNewsFeedTwitter :(NSString*) searchText{
   
    NSString *searchAPIUrl=@"https://api.twitter.com/1.1/statuses/user_timeline.json";
    NSDictionary *params = @{@"screen_name" : searchText,
                             @"count":@"80"};
    NSError *clientError;
    
    
    NSURLRequest *request = [[[Twitter sharedInstance] APIClient] URLRequestWithMethod:@"GET" URL:searchAPIUrl parameters:params error:&clientError];
    
    if (request) {
        [[[Twitter sharedInstance] APIClient] sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                // handle the response data e.g.
                NSError *jsonError;
                NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
                 newsFeedArray=[[NSMutableArray alloc] init];
              
                for (int i=0; i<json.count; i++) {
                    NSDictionary *tweetData=json[i];
                    NSString *statusText=[tweetData valueForKey:@"text"];
                     NSString *createdAt=[tweetData valueForKey:@"created_at"];
                    NSDictionary *userDic=[tweetData valueForKey:@"user"];
                     NSString *name=[userDic valueForKey:@"name"];
                    NSString *screenName=[userDic valueForKey:@"screen_name"];
                      NSString *tweetLabel = [name stringByAppendingString:[@" @" stringByAppendingString:screenName]];
                    
                    NSMutableDictionary *tweetDictionary=[[NSMutableDictionary alloc] init];
                    [tweetDictionary setObject:statusText forKey:@"text"];
                     [tweetDictionary setObject:name forKey:@"name"];
                    [tweetDictionary setObject:tweetLabel forKey:@"profileName"];
                    [tweetDictionary setObject:createdAt forKey:@"createdAt"];
                    [newsFeedArray addObject:tweetDictionary];
                }

                tblNewsFeedInfo = [[UITableView alloc] initWithFrame:CGRectMake(752,0,375,564) style:UITableViewStylePlain];
                tblNewsFeedInfo.sectionFooterHeight = 0;
            
                tblNewsFeedInfo.delegate=self;
                tblNewsFeedInfo.dataSource=self;
                [self.scrollViewNotificationFeed addSubview:tblNewsFeedInfo];
                
            }
            else {
                NSLog(@"Error: %@", connectionError);
               // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[connectionError localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
               // [alert show];
            }
        }];
    }
    else {
               NSLog(@"Error: %@", clientError);
       // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[clientError localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //[alert show];
    }
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
   pointNow = scrollView.contentOffset;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.scrollViewNotificationFeed)
    {
    CGFloat width = scrollView.frame.size.width+10;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    CGFloat yDist = (scrollView.contentOffset.y - pointNow.y);
    
    if (yDist==0.0) {
        switch (page)
        {
            case 0:
                [self setupTabSelection:0];
                if (scrollView.contentOffset.x>0) {
                    if ([[Twitter sharedInstance] session]) {
                        if (self.socialLogInButton!=NULL) {
                            [self.socialLogInButton setHidden:YES];
                        }
                        if (self.newsLogInButton!=NULL) {
                            [self.newsLogInButton setHidden:YES];
                        }
                        
                    }else{
                        if (self.socialLogInButton!=NULL) {
                            [self.socialLogInButton setHidden:NO];
                        }
                        if (self.newsLogInButton!=NULL) {
                            [self.newsLogInButton setHidden:NO];
                        }}
                    
                }else{
                    if (self.socialLogInButton!=NULL) {
                        [self.socialLogInButton setHidden:YES];
                    }
                    if (self.newsLogInButton!=NULL) {
                        [self.newsLogInButton setHidden:YES];
                    }
                }
                
                break;
            case 1:
                
                if (scrollView.contentOffset.x>375) {
                    if (self.newsLogInButton!=NULL) {
                        [self.newsLogInButton setHidden:NO];
                    }
                }else{
                    if (self.newsLogInButton!=NULL) {
                        [self.newsLogInButton setHidden:YES];
                    }
                }
                
                [self setupTabSelection:1];
                if ([[Twitter sharedInstance] session]) {
                    if (self.socialLogInButton!=NULL) {
                        [self.socialLogInButton setHidden:YES];
                    }
                    if (self.newsLogInButton!=NULL) {
                        [self.newsLogInButton setHidden:YES];
                    }
                    
                }else{
                    self.socialLogInButton.center = self.view.center;
                    [self.view addSubview:self.socialLogInButton];
                    
                }
                
                //[self loadSocialFeedTab];
                break;
            case 2:
                
                [self setupTabSelection:2];
                if ([[Twitter sharedInstance] session]) {
                    if (self.socialLogInButton!=NULL) {
                        [self.socialLogInButton setHidden:YES];
                    }
                    if (self.newsLogInButton!=NULL) {
                        [self.newsLogInButton setHidden:YES];
                    }
                    
                }else{
                    self.newsLogInButton.center = self.view.center;
                    [self.view addSubview:self.newsLogInButton];}
                
                //[self loadNewsFeedTab];
                break;
                //default:[self setupTabSelection:0];
                //break;
        }
    }
    
    }
    
}

-(void) loadSocialFeedTab{
    if ([[Twitter sharedInstance] session]) {
        if(socialFeedArray.count>0){
            [socialFeedArray removeAllObjects];
            
            
        }
        if(self.socialLogInButton!=NULL){
            [self.socialLogInButton setHidden:YES];
            
        }
        [self loadTwitter:@"MTA"];
        
        
    } else {
        
        self.socialLogInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession* session, NSError* error) {
            if (session) {
                [self storeAuthToken:session.authToken] ;
                [self storeAuthSecretToken:session.authTokenSecret] ;
                if(self.socialLogInButton!=NULL){
                    [self.socialLogInButton setHidden:YES];
                    
                }
                if(socialFeedArray.count>0){
                   [socialFeedArray removeAllObjects];

                }
                //[self loadTwitter:@"#LIRR"];
                [self loadTwitter:@"MTA"];
                [self loadNewsFeedTab];
                
                
                
            } else {
                NSLog(@"error: %@", [error localizedDescription]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
        }];
        
    }


}


-(void) loadNewsFeedTab{
   
    if ([[Twitter sharedInstance] session]) {
        if(self.newsLogInButton!=NULL){
            [self.newsLogInButton setHidden:YES];
            
        }
        [self loadNewsFeedTwitter:@"NY1"];
        
        
    } else {
        
        self.newsLogInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession* session, NSError* error) {
            if (session) {
                if(self.newsLogInButton!=NULL){
                    [self.newsLogInButton setHidden:YES];
                    
                }
                [self storeAuthToken:session.authToken] ;
                [self storeAuthSecretToken:session.authTokenSecret];
                [self loadNewsFeedTwitter:@"NY1"];
                [self loadSocialFeedTab];
                
            } else {
                NSLog(@"error: %@", [error localizedDescription]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
            }
        }];
        
       
       
        
    }
}

- (void)storeAuthToken:(NSString *)authToken {
    [[NSUserDefaults standardUserDefaults]setObject:authToken forKey:@"twitterAuthToken"];
}

- (NSString *)loadAuthToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"twitterAuthToken"];
}

- (void)storeAuthSecretToken:(NSString *)authSecretToken {
    [[NSUserDefaults standardUserDefaults]setObject:authSecretToken forKey:@"twitterAuthSecretToken"];
}

- (NSString *)loadAuthSecretToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"twitterAuthSecretToken"];
}

- (IBAction)socialFeedBtn:(id)sender {
}
@end
