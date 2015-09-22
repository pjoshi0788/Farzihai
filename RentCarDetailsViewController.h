//
//  RentCarDetailsViewController.h
//  MastercardFinal
//
//  Created by administrator on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"
#import "TransitViewController.h"


@interface RentCarDetailsViewController : UIViewController<JTRevealSidebarV2Delegate, SidebarViewControllerDelegate, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>


{
    MenuView *transitMenuView;
}


@property (strong, nonatomic) SidebarViewController *sideBarViewController;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;


@property (weak, nonatomic) IBOutlet UISwitch *MasterPassSwitchReference;
@property (weak, nonatomic) IBOutlet UISwitch *PayAtRentalSwitchReference;

- (IBAction)SideBarControllerBtn:(id)sender;

- (IBAction)DatePickerBtn:(id)sender;

- (IBAction)TimeDropDown:(id)sender;

- (IBAction)AgeDropDown:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *pickUpDateReference;
@property (weak, nonatomic) IBOutlet UIButton *returnDateReference;

@property (weak, nonatomic) IBOutlet UIButton *PickUpTimeDropDownReference;
@property (weak, nonatomic) IBOutlet UIButton *ReturnTimeDropDownReference;
@property (weak, nonatomic) IBOutlet UIButton *AgeDropDownReference;

@property (weak, nonatomic) IBOutlet UILabel *PricePerDayLabel;

@property (strong, nonatomic) NSString *PricePerDayString;

- (IBAction)MasterPassSwitch:(id)sender;
- (IBAction)PayAtRentalSwitch:(id)sender;

- (IBAction)CancelBtn:(id)sender;
- (IBAction)ContinueBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *FirstNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *LastNameTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *EmailAddrsTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNmbrTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *AirlineTxtFld;
@property (weak, nonatomic) IBOutlet UITextField *FlightNmbrTxtFld;

- (IBAction)ShowMenuView:(id)sender;

@end
