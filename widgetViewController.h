//
//  widgetViewController.h
//  mtaWidget
//
//  Created by Prateek on 6/8/15.
//  Copyright (c) 2015 matrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <Accounts/Accounts.h>

@interface widgetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UIScrollViewDelegate,UITextViewDelegate>

{
    UITabBarController *tabBarController;
    NSMutableDictionary *busDict;
    NSMutableDictionary *subwayDict;
    NSMutableDictionary *btDict,*metroNorth;
    NSMutableDictionary *currDict,*tempDictTrainAndMetroNorth;
    NSString *currLineName;
    NSDictionary *assetDict;
       NSMutableArray *tempArrayTrainAndMetroNoth;
    NSMutableArray *busArray;
    NSMutableArray *subwayArray;
     NSMutableArray *socialFeedArray;
     NSMutableArray *newsFeedArray;
    NSMutableArray *trainArray,*metroArray;
    UITableView *tblMtaInfo;
    UITableView *tblSocialFeedInfo;
     UITableView *tblNewsFeedInfo;
    CGPoint pointNow;
    NSMutableDictionary *myRouteDict;
    NSMutableArray *myRouteArr;
    NSArray *finalRouteArray ;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentBar;

@property (weak, nonatomic) IBOutlet UIView *mtaSelectionView;
@property (weak, nonatomic) IBOutlet UIView *socialFeedSelectionView;
@property (weak, nonatomic) IBOutlet UIView *newsFeedSelectionView;
@property (nonatomic, retain) TWTRLogInButton* socialLogInButton;
@property (nonatomic, retain) TWTRLogInButton* newsLogInButton;


- (IBAction)segmentBarClicked:(id)sender;
@property (nonatomic, strong) NSMutableDictionary *dictLine;
@property (nonatomic,retain) NSMutableArray *arrLineData,*arrBus,*arrSubway,*arrLirr,*arrMetronorth,*arrBt,*arrTableData;

- (IBAction)segmentIndexChanged:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewNotificationFeed;

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic,strong) NSMutableString *mstrXMLString;
@property (strong, nonatomic) SidebarViewController *sideBarViewController;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewNotifyFeed;

@property (weak, nonatomic) IBOutlet UIButton *btnCrowdSpeak;
//- (IBAction)btnWidgetOption:(id)sender;
- (IBAction)btnToggleView:(id)sender;

//@property (weak,nonatomic) UILabel *lblName,*lblStatus;
@property (weak,nonatomic) UIImageView *imgRoute;

@end
