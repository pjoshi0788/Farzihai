//
//  TravelNoticeViewController.h
//  MastercardFinal
//
//  Created by administrator on 14/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "LocationPickerViewController.h"



@interface TravelNoticeViewController : UIViewController<JTRevealSidebarV2Delegate,SidebarViewControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,SidebarViewControllerDelegate>


@property (strong, nonatomic) SidebarViewController *sideBarViewController;

- (IBAction)SideBarButton:(id)sender;
- (IBAction)CancelButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


@property (weak, nonatomic) IBOutlet UITextField *ContactNmbrTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *ContactNmbrDestinationTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *LocationDestinationTxtFld;

@property (weak, nonatomic) IBOutlet UITextField *EmergencyContactName;
@property (weak, nonatomic) IBOutlet UITextField *EmergencyContactNmbr;

@property (weak, nonatomic) IBOutlet UITextField *AdditionalEmergencyContactName;
@property (weak, nonatomic) IBOutlet UITextField *AdditionalEmergencyContactNmbr;
@property (weak, nonatomic) IBOutlet UITextField *AdditionalTravelInfo;



- (IBAction)AddDestinationBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *MiddleView;
@property (weak, nonatomic) IBOutlet UIView *LowerView;

- (IBAction)SetNoticeBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *CreditCardNNmbrTxtFld;

- (IBAction)AddCreditCardNmbrBtn:(id)sender;

- (IBAction)SetDateBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *TravelStartDateBtn;
@property (weak, nonatomic) IBOutlet UIButton *TravelEnDateBtn;

- (IBAction)LocationPickerbtn:(id)sender;


@end
