//
//  LeftSidebarViewController.m
//  JTRevealSidebarDemo
//
//  Created by James Apple Tang on 12/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import "AppDelegate.h"
#import "SidebarViewController.h"
#import "SideBarTableViewCell.h"
#import "RechargeViewController.h"
#import "AboutUsViewController.h"
#import "QkrViewController.h"
#import "ShareViewController.h"
#import "TransitWalletViewController.h"
#import "TransitViewController.h"
#import "PrivacyViewController.h"
#import "ContactLessTicketsController.h"
#import "MTA-LIRR_ViewController.h"
#import "InControllerNewViewController.h"
#import "widgetViewController.h"
#import "TravelNoticeViewController.h"
#import "WorkinprogressViewcontroller.h"
#import "FBCheckinController.h"
#import "SurpriseViewController.h"
#import "TimeTableViewController.h"
#import "TravelNoticeViewController.h"
#import "LostAndFoundViewController.h"
#import "FareViewController.h"

#define  kTrainTransit @"train"
#define  kCarTransit @"driving"
#define  kBicycleTransit @"bicycling"
#define  kWalking @"walking"

@implementation SidebarViewController
@synthesize sidebarDelegate, headViewArray,rootVc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    [self loadModel];
    [self.tableView registerNib:[UINib nibWithNibName:@"SideBarTableViewCell" bundle:nil ] forCellReuseIdentifier:@"Cell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([self.sidebarDelegate respondsToSelector:@selector(lastSelectedIndexPathForSidebarViewController:)]) {
        NSIndexPath *indexPath = [self.sidebarDelegate lastSelectedIndexPathForSidebarViewController:self];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)loadModel{
    _currentRow = -1;
    headViewArray = [[NSMutableArray alloc]init ];
    for(int i = 0;i < 8 ;i++)
    {
        HeadView* headview = [[HeadView alloc] init];
        headview.delegate = self;
        headview.section = i;
        [headview setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
        
        switch (i)
        {
            case 1: [headview.backBtn setTitle:@"Trip Planning" forState:UIControlStateNormal];
                headview.logoImgView.image = [UIImage imageNamed:@"trip-planning-icon.png"];
                headview.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
                headview.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
                break;
            case 2:[headview.backBtn setTitle:@"Fare" forState:UIControlStateNormal];
                headview.logoImgView.image = [UIImage imageNamed:@"card-recharge.png"];
                headview.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
               // headview.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
                [headview.backBtn addTarget:self action:@selector(displayFareView) forControlEvents:UIControlEventTouchDown];
                break;
            case 3:[headview.backBtn setTitle:@"Transit Status" forState:UIControlStateNormal];
                headview.logoImgView.image = [UIImage imageNamed:@"notification-icon.png"];                headview.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
//                headview.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
                [headview.backBtn addTarget:self action:@selector(notificationFeedsView) forControlEvents:UIControlEventTouchDown];
                break;
                
            case 4:[headview.backBtn setTitle:@"Budget" forState:UIControlStateNormal];
                headview.logoImgView.image = [UIImage imageNamed:@"valueadd-icon.png.png"];
                headview.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
//                headview.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
                [headview.backBtn addTarget:self action:@selector(InControlView) forControlEvents:UIControlEventTouchDown];
                break;
                
            case 5:[headview.backBtn setTitle:@"Priceless Cities" forState:UIControlStateNormal];
                headview.logoImgView.image = [UIImage imageNamed:@"mastercard-experience-icon.png"];
                headview.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
//                headview.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
                [headview.backBtn addTarget:self action:@selector(showPriceLessCities) forControlEvents:UIControlEventTouchDown];
                break;
                
            case 6:[headview.backBtn setTitle:@"Other" forState:UIControlStateNormal];
                headview.logoImgView.image = [UIImage imageNamed:@"ic_plus_circle.png"];
                headview.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
                headview.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
                break;
                
            case 7:[headview.backBtn setTitle:@"Settings" forState:UIControlStateNormal];
                headview.logoImgView.image = [UIImage imageNamed:@"settings.png"];
                headview.logoImgView.contentMode = UIViewContentModeScaleAspectFit;
                headview.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
                
                break;
                
        }
        [self.headViewArray addObject:headview];
        
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    //return [self.headViewArray count];
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HeadView* headView = [self.headViewArray objectAtIndex:section];
    
    
    //return headView.open?5:0;
    
    switch (section)
    {
        case 0: return 1;
            break;
        case 1: return headView.open?3:0;
            break;
        case 2: return 0;
            break;
        case 3: return 0;
            break;
        case 4: return 0;
            break;
        case 5: return 0;
            break;
        case 6: return headView.open?3:0;
            break;
       case 7: return headView.open?5:0;
            break;
     
            
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section != 0)
        return 45;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0 && indexPath.row == 0)
    {
        return 150.0;
    }
    
    HeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    
    return headView.open?45:0;
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.headViewArray objectAtIndex:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifierForImage = @"CellIdentifierForImage";
    
    
    
    SideBarTableViewCell *cell = [[SideBarTableViewCell alloc] init];
    
    
  
    
    
//    UIView *lineView;
    if(indexPath.section ==0)
    {
        cell = (SideBarTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifierForImage];
        if (cell == nil) {
            cell = [[SideBarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifierForImage];
//            lineView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
//            lineView.backgroundColor = [UIColor darkGrayColor];
//
//            [cell.contentView addSubview:lineView];
        }
        
    }
    else
    {
        cell = (SideBarTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[SideBarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
//            lineView = [[UIView alloc] initWithFrame:CGRectMake(15, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
//            lineView.backgroundColor = [UIColor darkGrayColor];
//            
//            [cell.contentView addSubview:lineView];
        }
        
    }
    
    switch (indexPath.section) {
        case 0:
        {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,270,150)];
            
            imgView.image = [UIImage imageNamed:@"top-bg_new.png"];
            [cell addSubview:imgView];
        }
        break;
            
        case 1:
            [cell setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
        {
            switch(indexPath.row)
            {
                case 0:
                    [cell.menuLabelBtn setTitle:@"Journey" forState:UIControlStateNormal];
                    cell.menuLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [cell.menuLabelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
                    [cell.menuLabelBtn addTarget:self action:@selector(showNearBy) forControlEvents:UIControlEventTouchUpInside];
                    
                    break;
                case 1:[cell.menuLabelBtn setTitle:@"Time Tables" forState:UIControlStateNormal];
                    cell.menuLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [cell.menuLabelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
                    [cell.menuLabelBtn addTarget:self action:@selector(showTimeTable) forControlEvents:UIControlEventTouchUpInside];
                    
                    break;
                case 2:
                    [cell.menuLabelBtn setTitle:@"System Maps" forState:UIControlStateNormal];
                    cell.menuLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    [cell.menuLabelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
                    [cell.menuLabelBtn addTarget:self action:@selector(ShowMapButton) forControlEvents:UIControlEventTouchUpInside];
                    break;

            }
        }
        break;
            
 
        case 6:
            [cell setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
            {
            [cell.menuLabelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            cell.menuLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            switch (indexPath.row)
            {
                case 0:
                    [cell.menuLabelBtn setTitle:@"Lost & Found" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(showLostAndFound) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 1:
                    [cell.menuLabelBtn setTitle:@"Indoor Navigation" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(showWorkinprogresView) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:
                    [cell.menuLabelBtn setTitle:@"Accessibility Information" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(showWorkinprogresView) forControlEvents:UIControlEventTouchUpInside];
                    break;
            }
            
        }
        break;
        case 7:
            [cell setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
        {    [cell.menuLabelBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            cell.menuLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            switch (indexPath.row)
            {
                case 0:
                    [cell.menuLabelBtn setTitle:@"Travel Notice" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(TransitNoticeView) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 1:
                    [cell.menuLabelBtn setTitle:@"Edit Profile" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(showWorkinprogresView) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 2:
                    [cell.menuLabelBtn setTitle:@"About Us" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(showAboutusView) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 3:
                    [cell.menuLabelBtn setTitle:@"Privacy Notice" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(showPrivacyScreen) forControlEvents:UIControlEventTouchUpInside];
                    break;
                case 4:
                    [cell.menuLabelBtn setTitle:@"Share App" forState:UIControlStateNormal];
                    [cell.menuLabelBtn addTarget:self action:@selector(openShareView) forControlEvents:UIControlEventTouchUpInside];
                    break;
                    
               
//
//                case 5:
//                    [cell.menuLabelBtn setTitle:@"About Us" forState:UIControlStateNormal];
//                    [cell.menuLabelBtn addTarget:self action:@selector(showAboutusView) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                    
//                case 6:
//                    [cell.menuLabelBtn setTitle:@"Privacy Notice" forState:UIControlStateNormal];
//                    [cell.menuLabelBtn addTarget:self action:@selector(showPrivacyScreen) forControlEvents:UIControlEventTouchUpInside];
//                    break;
//                    
//                case 7:
//                    [cell.menuLabelBtn setTitle:@"Share App" forState:UIControlStateNormal];
//                    [cell.menuLabelBtn addTarget:self action:@selector(openShareView) forControlEvents:UIControlEventTouchUpInside];
//                    break;
                    

                    
            }
        }
            break;

            
        default:
            break;
            
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentRow = indexPath.row;
    [self.tableView reloadData];
}

#pragma mark - HeadViewdelegate
-(void)selectedWith:(HeadView *)view{
    _currentRow = -1;
   
    if (view.open) {
        for(int i = 0;i<[headViewArray count];i++)
        {
            HeadView *head = [headViewArray objectAtIndex:i];
            head.open = NO;
            //[head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        }
        
        if(view.section!=2 && view.section != 3 && view.section != 4 && view.section != 5)
        view.dropDwnImgView.image = [UIImage imageNamed:@"down-arrow.png"];
        [self.tableView reloadData];
        return;
    }
    else if(view.section!=2 && view.section != 3 && view.section != 4 && view.section != 5)
        view.dropDwnImgView.image = [UIImage imageNamed:@"up-arrow.png"];
    
    _currentSection = view.section;
    [self reset];
    
}


- (void)reset
{
    for(int i = 0;i<[headViewArray count];i++)
    {
        HeadView *head = [headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = YES;
            
            if(head.section != 2 && head.section != 3 && head.section != 4 && head.section != 5)
            head.dropDwnImgView.image =  [UIImage imageNamed:@"up-arrow.png"];
            
            //[head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_nomal"] forState:UIControlStateNormal];
            

        }else if(head.section !=2 && head.section != 3 && head.section != 4 && head.section != 5) {

            //  [head.backBtn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
            
            head.open = NO;
            head.dropDwnImgView.image =  [UIImage imageNamed:@"down-arrow.png"];
        }
        
    }
    [self.tableView reloadData];
}

-(void) showLostAndFound
{
    
    if([self.sidebarDelegate isKindOfClass:[LostAndFoundViewController class]])
    {
        LostAndFoundViewController *tvc = (LostAndFoundViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    
    else
    {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    LostAndFoundViewController *lostAndFoundVC = [storyboard instantiateViewControllerWithIdentifier:@"lostAndFound"];
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if([topController revealedState]==JTRevealedStateLeft)
            [topController toggleRevealState:JTRevealedStateLeft];

        
    if(appDelegate.rootViewSet)
        [topController presentViewController:lostAndFoundVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:lostAndFoundVC animated:YES completion:nil];
        
    }

    }
}
-(void) showWorkinprogresView
{
    
    if([self.sidebarDelegate isKindOfClass:[WorkinprogressViewcontroller class]])
    {
        WorkinprogressViewcontroller *tvc = (WorkinprogressViewcontroller*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    else
    {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    WorkinprogressViewcontroller *workinprogress = [storyboard instantiateViewControllerWithIdentifier:@"WorkinprogressViewcontroller"];
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
       
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if([topController revealedState]==JTRevealedStateLeft)
            [topController toggleRevealState:JTRevealedStateLeft];
        
        

        
    if(appDelegate.rootViewSet)
    [topController presentViewController:workinprogress animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:workinprogress animated:YES completion:nil];
        
    }
    }
}

-(void) showRechargeView
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    RechargeViewController *transitCtrl = [storyboard instantiateViewControllerWithIdentifier:@"rechargeViewController"];
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.rootViewSet)
    [self presentViewController:transitCtrl animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:transitCtrl animated:YES completion:nil];
        
    }
    
}

-(void) showAboutusView
{
    if([self.sidebarDelegate isKindOfClass:[AboutUsViewController class]])
    {
        AboutUsViewController *tvc = (AboutUsViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    else
    {
  
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    AboutUsViewController *transitCtrl = [storyboard instantiateViewControllerWithIdentifier:@"aboutusViewController"];
    
      AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if([topController revealedState]==JTRevealedStateLeft)
            [topController toggleRevealState:JTRevealedStateLeft];

    if(appDelegate.rootViewSet)
    {
        
    [topController presentViewController:transitCtrl animated:YES completion:nil];
        
    }
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:transitCtrl animated:YES completion:nil];
        
    }

    }
}
-(void) notificationFeedsView
{
    if([self.sidebarDelegate isKindOfClass:[widgetViewController class]])
    {
        widgetViewController *tvc = (widgetViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    
    else
    {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    widgetViewController *widgetCtrl = [storyboard instantiateViewControllerWithIdentifier:@"widgetViewController"];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController revealedState]==JTRevealedStateLeft)
        [topController toggleRevealState:JTRevealedStateLeft];

    
    
    if(appDelegate.rootViewSet)
    [topController presentViewController:widgetCtrl animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:widgetCtrl animated:YES completion:nil];
        
    }
    }
}

-(void) displayFareView
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    FareViewController *fareCtrl = [storyboard instantiateViewControllerWithIdentifier:@"fareViewController"];
    
    if([self.sidebarDelegate isKindOfClass:[FareViewController class]])
    {
        FareViewController *tvc = (FareViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    
    else
    {
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
     UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController revealedState]==JTRevealedStateLeft)
        [topController toggleRevealState:JTRevealedStateLeft];
    
    
    if(appDelegate.rootViewSet)
        [topController presentViewController:fareCtrl animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:fareCtrl animated:YES completion:nil];
        
    }
    }
}

-(void) displayQkrView
{
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    QkrViewController *qkrViewCtrl = [storyboard instantiateViewControllerWithIdentifier:@"qkrViewController"];
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.rootViewSet)
    [self presentViewController:qkrViewCtrl animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:qkrViewCtrl animated:YES completion:nil];
        
    }

}

-(void) openShareView
{
    if([self.sidebarDelegate isKindOfClass:[ShareViewController class]])
    {
        ShareViewController *tvc = (ShareViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    else
    {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    ShareViewController *shareViewCtrl = [storyboard instantiateViewControllerWithIdentifier:@"shareViewController"];
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if([topController revealedState]==JTRevealedStateLeft)
            [topController toggleRevealState:JTRevealedStateLeft];
        
    
        
    if(appDelegate.rootViewSet)
    [topController presentViewController:shareViewCtrl animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:shareViewCtrl animated:YES completion:nil];
        
    }
    }
}
-(void) showMasterPass
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TransitWalletViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
    float val = 31*100;
    transitVC.rechargeVal=[NSString stringWithFormat:@"%f",val];

     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(appDelegate.rootViewSet)
    [self presentViewController:transitVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:transitVC animated:YES completion:nil];
        
    }
}
-(void) showNearBy
{

     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];


    if(appDelegate.NetworkStatus ==YES)
    {
    TransitViewController *vc = (TransitViewController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
   
    if(self.sidebarDelegate == vc)
    [vc toggleRevealState:JTRevealedStateLeft];
    
    else
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TransitViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
        
    if(appDelegate.rootViewSet)
        [self presentViewController:transitVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:transitVC animated:YES completion:nil];
    }
        if ((appDelegate.origin1.length != 0)&& (appDelegate.destination1.length != 0))
        {
            [transitVC.txtFieldOrigin setText:appDelegate.origin1];
            [transitVC.txtFieldDestination setText:appDelegate.destination1];
        }
        if([appDelegate.transitMode isEqualToString:kTrainTransit])
        {
            [transitVC.btnTrainTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
 
        }
        else if([appDelegate.transitMode isEqualToString:kCarTransit])
            [transitVC.btnCarTransitref sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        else if([appDelegate.transitMode isEqualToString:kWalking])
            [transitVC.btnWalkTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
        
        else if([appDelegate.transitMode isEqualToString:kBicycleTransit])
            [transitVC.btnBicycleTransitRef sendActionsForControlEvents:UIControlEventTouchUpInside];
        
 
        [transitVC.defaultTableTransit setHidden:YES];
        [transitVC.transitTbl setHidden:NO];
    }
}
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        alert.delegate=self;
        [alert show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    

// exit(0);

}

-(void) showTaptoPay
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TransitWalletViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
    float val = 31*100;
    transitVC.rechargeVal=[NSString stringWithFormat:@"%f",val];
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.rootViewSet)
    [self presentViewController:transitVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:transitVC animated:YES completion:nil];
        
    }
}

-(void) ContactLessTicketsPay {
    
    ContactLessTicketsController *ContactLessTicketVC = [[ContactLessTicketsController alloc] init];
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.rootViewSet)
    [self presentViewController:ContactLessTicketVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:ContactLessTicketVC animated:YES completion:nil];
        
    }
}


-(void)showFBCheckinView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
     FBCheckinController *fbVC = [storyboard instantiateViewControllerWithIdentifier:@"fbCheckinController"];
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(appDelegate.rootViewSet)
    [self presentViewController:fbVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:fbVC animated:YES completion:nil];
        
    }
}

-(void) showPrivacyScreen
{
    if([self.sidebarDelegate isKindOfClass:[PrivacyViewController class]])
    {
        PrivacyViewController *tvc = (PrivacyViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    
    else
    {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    PrivacyViewController *privacyVC = [storyboard instantiateViewControllerWithIdentifier:@"privacyViewController"];
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if([topController revealedState]==JTRevealedStateLeft)
            [topController toggleRevealState:JTRevealedStateLeft];
        
    if(appDelegate.rootViewSet)
    [topController presentViewController:privacyVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:privacyVC animated:YES completion:nil];
        
    }
    }
}

-(void) ShowMapButton {
    
    if([self.sidebarDelegate isKindOfClass:[MTA_LIRR_ViewController class]])
    {
        MTA_LIRR_ViewController *tvc = (MTA_LIRR_ViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    
    else
    {
    
    MTA_LIRR_ViewController *StaticMapVC = [[MTA_LIRR_ViewController alloc] init];
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController revealedState]==JTRevealedStateLeft)
        [topController toggleRevealState:JTRevealedStateLeft];
        
    if(appDelegate.rootViewSet)
        [topController presentViewController:StaticMapVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:StaticMapVC animated:YES completion:nil];
        
    }
    }
}

-(void) InControlView {
    
    
    
    if([self.sidebarDelegate isKindOfClass:[InControllerNewViewController class]])
    {
        InControllerNewViewController *tvc = (InControllerNewViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    else
    {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    InControllerNewViewController *InController = [storyboard instantiateViewControllerWithIdentifier:@"inControllerNewViewController"];
   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController revealedState]==JTRevealedStateLeft)
        [topController toggleRevealState:JTRevealedStateLeft];

    
   if(appDelegate.rootViewSet)
       [topController presentViewController:InController animated:YES completion:nil];
    
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:InController animated:YES completion:nil];
        
    }
    }
}
-(void) FacebookNoticeView {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FBCheckinController *facebookNoticeVC = [storyboard instantiateViewControllerWithIdentifier:@"fbCheckinController"];
    
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.rootViewSet)
    [self presentViewController:facebookNoticeVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:facebookNoticeVC animated:YES completion:nil];
        
    }
}

-(void) TransitNoticeView {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TravelNoticeViewController *transitNoticeVC = (TravelNoticeViewController*)[storyboard instantiateViewControllerWithIdentifier:@"transitNoticeVC"];
    
    
    if([self.sidebarDelegate isKindOfClass:[TravelNoticeViewController class]])
    {
        TravelNoticeViewController *tvc = (TravelNoticeViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    else
    {
    
   
     AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController revealedState]==JTRevealedStateLeft)
        [topController toggleRevealState:JTRevealedStateLeft];
    
    if(appDelegate.rootViewSet)
    [topController presentViewController:transitNoticeVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:transitNoticeVC animated:YES completion:nil];
        
    }
    }
}

-(void) showPriceLessCities {

    if([self.sidebarDelegate isKindOfClass:[SurpriseViewController class]])
    {
        SurpriseViewController *tvc = (SurpriseViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }
    
    else
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        
        SurpriseViewController *transitCtrl = [storyboard instantiateViewControllerWithIdentifier:@"SurpriseViewController"];
         AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if([topController revealedState]==JTRevealedStateLeft)
            [topController toggleRevealState:JTRevealedStateLeft];

        
    if(appDelegate.rootViewSet)
        [topController presentViewController:transitCtrl animated:YES completion:nil];
        else
        {
            
            self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
            appDelegate.rootViewSet = TRUE;
            [self.rootVc presentViewController:transitCtrl animated:YES completion:nil];
            
        }
   /* }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You are offline, Please check your network connection." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
    }*/

    }


}

-(void) showTimeTable {
    
    if([self.sidebarDelegate isKindOfClass:[TimeTableViewController class]])
    {
        TimeTableViewController *tvc = (TimeTableViewController*)self.sidebarDelegate;
        [tvc toggleRevealState:JTRevealedStateLeft];
    }

    else
    {
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TimeTableViewController *timeTableVC = [storyboard instantiateViewControllerWithIdentifier:@"timeTableViewController"];
        
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        if([topController revealedState]==JTRevealedStateLeft)
            [topController toggleRevealState:JTRevealedStateLeft];

        
    if(appDelegate.rootViewSet)
        [topController presentViewController:timeTableVC animated:YES completion:nil];
    else
    {
        self.rootVc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        appDelegate.rootViewSet = TRUE;
        [self.rootVc presentViewController:timeTableVC animated:YES completion:nil];
        
    }

    }
}

@end
