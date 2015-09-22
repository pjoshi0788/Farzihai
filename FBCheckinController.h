//
//  FBCheckinController.h
//  MastercardFinal
//
//  Created by Brillio on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SidebarViewController.h"

@interface FBCheckinController : UIViewController<SidebarViewControllerDelegate,JTRevealSidebarV2Delegate,UITableViewDataSource, UITableViewDelegate,FBSDKLoginButtonDelegate,UIAlertViewDelegate,UITextViewDelegate>
{
   
}

@property (strong, nonatomic) SidebarViewController *sideBarViewController;
@property (nonatomic, retain) UITableView *placesTableView;
@property (nonatomic, retain)  UIView *placeListView;
@property (nonatomic, retain)   NSArray* placesData;
@property (nonatomic, retain)   NSString *postImageUrl;
@property (nonatomic, retain)   NSString *postPlaceId;
@property (nonatomic, retain)  UIView *greyedView;
@property (nonatomic, retain) IBOutlet UIButton *activityBtn;
@property (nonatomic, retain)  IBOutlet UIButton *infoBtn;
@property (nonatomic, retain)  IBOutlet UIButton *selectAPlaceBtn;
@property (nonatomic, retain)  IBOutlet UIButton *tagWithFriends;
@property (nonatomic, retain)  IBOutlet UIButton *checkinBtn;

- (IBAction)selectAPlaceClicked:(id)sender;
- (IBAction)activityBtnClicked:(id)sender;
- (IBAction)infoBtnClicked:(id)sender;
- (IBAction)checkInBtnClicked:(id)sender;
-(IBAction)toggleView:(id)sender ;

- (IBAction)cancelCheckIn:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *placeImageView;
@property (strong, nonatomic) IBOutlet UILabel *placeNameLabel;

@property (strong, nonatomic) IBOutlet UITextView *checkinText;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;

@property (strong, nonatomic) IBOutlet UIView *placesSuperView;

- (IBAction)btnCancel:(id)sender;

@end
