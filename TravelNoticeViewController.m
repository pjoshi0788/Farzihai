//
//  TravelNoticeViewController.m
//  MastercardFinal
//
//  Created by administrator on 14/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#define DeviceWidth self.view.bounds.size.width
#define DeviceHeight self.view.bounds.size.height

#import "TravelNoticeViewController.h"
#import "constant.h"
#import <EventKit/EventKit.h>
#import "TransitViewController.h"
#import "AppDelegate.h"

@interface TravelNoticeViewController ()
{
    NSString *Destination;
    NSString *CreditCardNmbr;
    UIView *timePickerView;
    UILabel *timelabel;
    UIDatePicker *timePicker;
    
//    NSMutableArray *destinationArray;
//    NSMutableArray *creditCardArray;
    
    BOOL TravelStartDateBtnTapped;
}
@end

@implementation TravelNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.myScrollView.frame = CGRectMake(0, 45, DeviceWidth, DeviceHeight);
    self.myScrollView.contentSize = CGSizeMake(DeviceWidth, 900);
    self.myScrollView.backgroundColor = [UIColor clearColor];
    
    self.myScrollView.delegate = self;
    self.navigationItem.revealSidebarDelegate = self;
    
    UIColor *color = [UIColor lightGrayColor];
        
    _ContactNmbrTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Contact Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
    _ContactNmbrDestinationTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Destination Phone Number" attributes:@{NSForegroundColorAttributeName: color}];
    _LocationDestinationTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Destination Location" attributes:@{NSForegroundColorAttributeName: color}];
    _EmergencyContactName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Emergency Contact Name" attributes:@{NSForegroundColorAttributeName: color}];
    _EmergencyContactNmbr.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Emergency Contact Number" attributes:@{NSForegroundColorAttributeName: color}];
    _AdditionalEmergencyContactName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Emergency Contact Name" attributes:@{NSForegroundColorAttributeName: color}];
    _AdditionalEmergencyContactNmbr.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Emergency Contact Number" attributes:@{NSForegroundColorAttributeName: color}];
    _AdditionalTravelInfo.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Additional Travel Information(ie. cruise line)" attributes:@{NSForegroundColorAttributeName: color}];
    _CreditCardNNmbrTxtFld.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Credit Card Number" attributes:@{NSForegroundColorAttributeName: color}];
    
    self.ContactNmbrTxtFld.delegate=self;
    self.ContactNmbrDestinationTxtFld.delegate=self;
    self.LocationDestinationTxtFld.delegate=self;
    self.CreditCardNNmbrTxtFld.delegate=self;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(checkKeyPadState)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y > self.view.bounds.size.width) {
        [scrollView setContentOffset:CGPointMake(0, self.view.bounds.size.width)];
    }
}
-(void) checkKeyPadState
{
    if([_ContactNmbrDestinationTxtFld isFirstResponder])
        [_ContactNmbrDestinationTxtFld resignFirstResponder];
    if([_ContactNmbrTxtFld isFirstResponder])
        [_ContactNmbrTxtFld resignFirstResponder];
    if([_CreditCardNNmbrTxtFld isFirstResponder])
        [_CreditCardNNmbrTxtFld resignFirstResponder];
    if([_EmergencyContactName isFirstResponder])
        [_EmergencyContactName resignFirstResponder];
    if([_EmergencyContactNmbr isFirstResponder])
        [_EmergencyContactNmbr resignFirstResponder];
    if([_AdditionalEmergencyContactName isFirstResponder])
        [_AdditionalEmergencyContactName resignFirstResponder];
    if([_AdditionalEmergencyContactNmbr isFirstResponder])
        [_AdditionalEmergencyContactNmbr resignFirstResponder];
    if([_AdditionalTravelInfo isFirstResponder])
        [_AdditionalTravelInfo resignFirstResponder];
    if([_CreditCardNNmbrTxtFld isFirstResponder])
        [_CreditCardNNmbrTxtFld resignFirstResponder];
    
}

#pragma mark JTRevealSidebarDelegate
// This is an example to configure your sidebar view without a UIViewController
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


- (void)textFieldDidEndEditing:(UITextField *)textField {             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    
    if (!Destination) {
        Destination = [[NSString alloc] init];
    }
    if (!CreditCardNmbr) {
        CreditCardNmbr = [[NSString alloc]init];
    }
    NSLog(@"%@",_LocationDestinationTxtFld.text);
    NSLog(@"%@",_CreditCardNNmbrTxtFld.text);
    
    UITextField *localText = (UITextField *)textField;
    if (textField == _LocationDestinationTxtFld && textField.text.length != 0 && Destination.length == 0) {
        Destination = [NSString stringWithFormat:@"Address: %@", localText.text];
    }else if (textField == _ContactNmbrDestinationTxtFld && textField.text.length != 0 && Destination.length == 0) {
        Destination = [NSString stringWithFormat:@"Phone No: %@",localText.text];
    }else if(textField == _LocationDestinationTxtFld  && _LocationDestinationTxtFld.text.length != 0){
        Destination = [NSString stringWithFormat:@"Address: %@, %@",localText.text, Destination];
    }else if (localText.tag == 10 && Destination.length != 0){
            Destination = [NSString stringWithFormat:@"%@, Phone No: %@",Destination,localText.text];
    }
    
    if (textField == _CreditCardNNmbrTxtFld && _CreditCardNNmbrTxtFld.text.length != 0) {
        CreditCardNmbr = [NSString stringWithFormat:@"Saved Card: %@", localText.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *searchText;
    
    if (textField == _LocationDestinationTxtFld) {
        searchText=[textField.text stringByAppendingString:string];
        Destination = [NSString stringWithFormat:@"Address: %@", searchText];
    }
    if (textField == _CreditCardNNmbrTxtFld) {
        searchText=[textField.text stringByAppendingString:string];
        CreditCardNmbr = [NSString stringWithFormat:@"Saved Card: %@", searchText];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)SideBarButton:(id)sender {
    
    if([_ContactNmbrDestinationTxtFld isFirstResponder])
        [_ContactNmbrDestinationTxtFld resignFirstResponder];
    if([_ContactNmbrTxtFld isFirstResponder])
        [_ContactNmbrTxtFld resignFirstResponder];
    if([_CreditCardNNmbrTxtFld isFirstResponder])
        [_CreditCardNNmbrTxtFld resignFirstResponder];
    if([_EmergencyContactName isFirstResponder])
        [_EmergencyContactName resignFirstResponder];
    if([_EmergencyContactNmbr isFirstResponder])
        [_EmergencyContactNmbr resignFirstResponder];
    if([_AdditionalEmergencyContactName isFirstResponder])
        [_AdditionalEmergencyContactName resignFirstResponder];
    if([_AdditionalEmergencyContactNmbr isFirstResponder])
        [_AdditionalEmergencyContactNmbr resignFirstResponder];
    if([_AdditionalTravelInfo isFirstResponder])
        [_AdditionalTravelInfo resignFirstResponder];
    if([_CreditCardNNmbrTxtFld isFirstResponder])
        [_CreditCardNNmbrTxtFld resignFirstResponder];

    
    [self toggleRevealState:JTRevealedStateLeft];
    
}

- (IBAction)CancelButton:(id)sender {
   
    if([self.presentingViewController revealedState] == JTRevealedStateLeft)
    [self.presentingViewController toggleRevealState:JTRevealedStateLeft];
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
   [self dismissViewControllerAnimated:YES completion:nil];
   
    appDelegate.setnotice = NO;
    appDelegate.noticeRepeat = YES;
}

- (IBAction)AddCreditCardNmbrBtn:(id)sender {
    int i;
    for (i = 0; i < [[self.self.MiddleView subviews] count]; i++ ) {
    }
    NSLog(@"middleviews: %d",i);
        
    if (CreditCardNmbr != 0 && ![CreditCardNmbr isEqualToString:@""]) {
        self.myScrollView.delegate = nil;
        if (i <= 16 ) {
            UILabel *SavedCreditCardLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, self.LowerView.frame.origin.y, 350, 40)];
            SavedCreditCardLabel.text = CreditCardNmbr;
            SavedCreditCardLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
            SavedCreditCardLabel.textColor = [UIColor darkGrayColor];
            [self.MiddleView addSubview:SavedCreditCardLabel];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(19, self.LowerView.frame.origin.y + 41, 350, 1)];
            lineView.backgroundColor = [UIColor lightGrayColor];
            [self.MiddleView addSubview:lineView];
            
            self.LowerView.frame = CGRectMake(0, self.LowerView.frame.origin.y + 42.0f, 350, self.LowerView.frame.size.height);
            self.MiddleView.frame = CGRectMake(0, self.MiddleView.frame.origin.y, 350, self.MiddleView.frame.size.height + 42.0f);
            self.myScrollView.contentSize = CGSizeMake(DeviceWidth,self.myScrollView.contentSize.height + 45);
            self.myScrollView.delegate = self;

        [_CreditCardNNmbrTxtFld setText:@""];
        CreditCardNmbr = NULL;
        }else {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Credit Card" message:@"You can add only upto 2 cards." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [_CreditCardNNmbrTxtFld setText:@""];
            CreditCardNmbr = NULL;
        }
    }else {
        UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Credit Card" message:@"Fill Card details first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)AddDestinationBtn:(id)sender {
    int i;
    for (i = 0; i < [[self.myScrollView subviews] count]; i++ ) {
    }
    NSLog(@"subviews: %d",i);

        if ( (_ContactNmbrDestinationTxtFld.text.length != 0 || _LocationDestinationTxtFld.text.length != 0) && ![Destination isEqualToString:@""]) {
            self.myScrollView.delegate = nil;
            if (i <= 15 ) {
                UILabel *SavedDestination = [[UILabel alloc] initWithFrame:CGRectMake(21, self.MiddleView.frame.origin.y, 350, 40)];
                SavedDestination.text = [NSString stringWithFormat:@"Destination %@",Destination];
                SavedDestination.numberOfLines = 0;
                SavedDestination.lineBreakMode = NSLineBreakByWordWrapping;
                SavedDestination.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
                SavedDestination.textColor = [UIColor darkGrayColor];
                [self.myScrollView addSubview:SavedDestination];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20, self.MiddleView.frame.origin.y + 41, 350, 1)];
                lineView.backgroundColor = [UIColor lightGrayColor];
                [self.myScrollView addSubview:lineView];
                
                self.MiddleView.frame = CGRectMake(0, self.MiddleView.frame.origin.y + 42.0f, 350, self.MiddleView.frame.size.height);
            
                self.myScrollView.contentSize = CGSizeMake(DeviceWidth,self.myScrollView.contentSize.height + 45);
            self.myScrollView.scrollEnabled = YES;
                self.myScrollView.delegate = self;

            NSLog(@"middle view origin: %f, height:%f",self.MiddleView.frame.origin.y,self.MiddleView.frame.size.height);
            NSLog(@"scroll view content height: %f",self.myScrollView.contentSize.height);

            Destination = NULL;
            [_LocationDestinationTxtFld setText:@""];
            [_ContactNmbrDestinationTxtFld setText:@""];
            }else {
                UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Destination Place" message:@"You can add only upto 2 destination." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
                
                Destination = NULL;
                [_LocationDestinationTxtFld setText:@""];
                [_ContactNmbrDestinationTxtFld setText:@""];

            }
        }else {
            UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"Destination Place" message:@"Fill the Destination Details first" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
       
        }
}

-(IBAction)SetDateBtn:(id)sender {
    
    UIButton *btn = (UIButton *) sender;
    
    if (btn.tag == 10)
        TravelStartDateBtnTapped = TRUE;
    else
        TravelStartDateBtnTapped = FALSE;
    
    timePickerView = [[UIView alloc] initWithFrame:CGRectMake(0,180,414,320)];
//    [timePickerView setBackgroundColor:[UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0]];
    [timePickerView setBackgroundColor:[UIColor whiteColor]];
    
    timelabel = [[UILabel alloc] init];
    timelabel.frame = CGRectMake(0, 10, 414, 40);
//    timelabel.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1.0];
    timelabel.backgroundColor = [UIColor whiteColor];
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

-(void) timeLabelChange
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.timeStyle = NSDateFormatterNoStyle;
    df.dateStyle = NSDateFormatterMediumStyle;
    
    timelabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:timePicker.date]];
}

-(void) removeTimeView
{
    if(timePickerView.isHidden == NO)
        [timePickerView removeFromSuperview];
}

-(void) addTime
{
    if(TravelStartDateBtnTapped)
    {
        [_TravelStartDateBtn setTitle:timelabel.text forState:UIControlStateNormal];
        TravelStartDateBtnTapped = FALSE;
    }
    else {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
       [df setDateFormat:@"MMM dd yyyy"];
        NSString *tempString = [_TravelStartDateBtn titleForState:UIControlStateNormal];
        //            NSDate *setDate = [[NSDate alloc] init];
//        [df setLocale:[NSLocale systemLocale]];
//        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        df.timeStyle = NSDateFormatterNoStyle;
        df.dateStyle = NSDateFormatterMediumStyle;
        [df setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDate *setDate = [df dateFromString:tempString];
        
        NSTimeInterval inter1 = [setDate timeIntervalSince1970];
        NSTimeInterval inter2 = [timePicker.date timeIntervalSince1970];
        if (inter1 < inter2) {
            [_TravelEnDateBtn setTitle:timelabel.text forState:UIControlStateNormal];
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End Date" message:@"Please select date which is greater than Start Date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    [timePickerView removeFromSuperview];
}


- (IBAction)SetNoticeBtn:(id)sender {
   
    if (![[[_TravelEnDateBtn titleLabel] text] isEqualToString:@"Set Date"] &&  ![[[_TravelStartDateBtn titleLabel] text] isEqualToString:@"Set Date"]) {
       // NSLog(@" set date entered");
        UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (topController.presentedViewController) {
            topController = topController.presentedViewController;
        }
        [self dismissViewControllerAnimated:topController completion:nil];
        AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.setnotice = YES;
        
    }else{
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Set Date" message:@"Please select proper start and end date" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
   
}

- (IBAction)LocationPickerbtn:(id)sender {
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    LocationPickerViewController *locationVc = [storyboard instantiateViewControllerWithIdentifier:@"locnPkrVireConrtoller"];
    [self presentViewController:locationVc animated:YES completion:nil];
    
    locationVc.delegate=self;
    locationVc.TravelNoticeDestinationLocation = TRUE;
}

-(void)sendDataToTransitNoticePage:(NSString *)address forAddress:(BOOL) TransitNoticePage {
    
    _LocationDestinationTxtFld.text = address;
    Destination = address;
}

@end
