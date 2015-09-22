//
//  SubscriberViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/9/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"

@interface SubscriberViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource,CustomTextFieldDelegate, UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate>
{
    CustomTextField *nameFld;
    NSArray *hourArray;
    NSArray *minuteArray;
    NSArray *timeZoneArray;
  
    UIDatePicker *timePicker;
    UILabel *timelabel;
    UIView *timePickerView;
    UITableView *tableViewhomeAddr,*tableViewworkAddr;
    NSMutableArray *tableData;
    BOOL leaveHomeBtnTapd;
    UIActivityIndicatorView *activity;
}
@property (nonatomic, retain) NSMutableDictionary *data;
@property (weak, nonatomic) IBOutlet UIScrollView *subscriberScrollView;
@property (weak, nonatomic) IBOutlet UIView *aboutYouView;
@property (weak, nonatomic) IBOutlet UIView *transitInfoView;
@property (weak, nonatomic) IBOutlet UIView *preferencesView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTxtFld;

@property (weak, nonatomic) IBOutlet UIView *livingTypeView;
@property (weak, nonatomic) IBOutlet UIView *livingStatusView;

@property (weak, nonatomic) IBOutlet UILabel *visitingNyLbl;
@property (weak, nonatomic) IBOutlet UILabel *livingInNyLbl;
- (IBAction)tabBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *appUsageView;
@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIView *commuteTimeView;
@property (weak, nonatomic) IBOutlet UIView *nearView;

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UISwitch *liveinNY;

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UISwitch *visitingNY;
@property (weak, nonatomic) IBOutlet UISwitch *cityLivingSwitch;
@property (weak, nonatomic) IBOutlet CustomTextField *workAddrFld;
@property (weak, nonatomic) IBOutlet UIButton *leaveHomeTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *workAddrBtn;

@property (weak, nonatomic) IBOutlet UIButton *homeAddrBtn;
@property (weak, nonatomic) IBOutlet CustomTextField *homeAddrFld;
@property (weak, nonatomic) IBOutlet UISwitch *suburbLivingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *commuteSwitch;
@property (weak, nonatomic) IBOutlet UIButton *leaveWorkBtn;


- (IBAction)letsGoBtnTapped:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *TapToPaySwitch;
@property (weak, nonatomic) IBOutlet UISwitch *ATMswitch;
@property (weak, nonatomic) IBOutlet UISwitch *EntertainmentSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *FoodAndBeveragesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *ConcertsSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *SportsSwitch;


- (IBAction)backBtnTapped:(id)sender;

- (IBAction)skipSetupTapped:(id)sender;
- (IBAction)continueTapped:(id)sender;
- (IBAction)getTime:(id)sender;
- (IBAction)showLocationPicker:(id)sender;
-(BOOL) isAboutYoudetailsFilled;
-(BOOL) istransitPageDetailsFilled;
@property (weak, nonatomic) IBOutlet UIView *visitingTypeView;
@property (weak, nonatomic) IBOutlet UILabel *visitingTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *livingTypeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *businessNYSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *touristNYSwitch;

//@property (weak, nonatomic) IBOutlet UITableView *AddrsTableView;


-(void) animateActivityWheel;
@end
