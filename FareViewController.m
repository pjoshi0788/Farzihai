//
//  FareViewController.m
//  MastercardFinal
//
//  Created by Brillio on 03/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//




#import "FareViewController.h"
#import <PassKit/PassKit.h>
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"
#import "SimplifyMerchantSDK/UIImage+Simplify.h"
#import "SimplifyMerchantSDK/UIColor+Simplify.h"
#import "SimplifyMerchantSDK/SIMResponseViewController.h"
#import "SimplifyMerchantSDK/SIMTokenProcessor.h"
#import "SimplifyMerchantSDK/SIMWaitingView.h"
#import "SimplifyMerchantSDK/SIMSimplify.h"
#import "TransitWalletViewController.h"
#import "TransitTicketsController.h"
@interface FareViewController ()
{
    
    NSInteger DropDownBtnTag;
     NSArray *transitType,*transitPassTypeForNYCB,*transitPassTypeForLIRR, *transitCardArray,
     *frStationArray,*toStationarray;
}
@end


@implementation FareViewController
@synthesize fareScrollView,valueSelectionTableView,rechargeCardView;
@synthesize transitTypeLbl,transitPassTypeLbl,transitCardLbl,transitCardView,LIRRView,toStationLbl,fromStationLbl;
@synthesize sevenDayExpressSwitch,sevenDayUnlimitedSwitch,thirtyDaysUnlimitedSwitch,departAtTimeSwitch,arriveByTimeSwitch,mtaAddTotalValue,mtaTicketLbl,mtaticketRechargeValue,mtaTotalRechagreValue,lirrTotalValue;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.fareScrollView.scrollEnabled = YES;
    self.fareScrollView.contentSize = CGSizeMake(375, 700);
    [self.fareScrollView setDelegate:self];
    self.navigationItem.revealSidebarDelegate = self;
    transitType=[[NSArray alloc]initWithObjects:@"New York City Transit", @"Long Island Rail Road",nil];
    transitPassTypeForNYCB=[[NSArray alloc]initWithObjects:@"Add value to MTA card",@"MTA NY City Bus Pass",nil];
    transitPassTypeForLIRR=[[NSArray alloc] initWithObjects:@"Round Trip Ticket", nil];
    transitCardArray=[[NSArray alloc] initWithObjects:@"MTA Card Nickname (..3567)", nil];
    frStationArray=[[NSArray alloc] initWithObjects:@"PENN STATION", nil];
    toStationarray=[[NSArray alloc] initWithObjects:@"HICKSVILLE STATION", nil];
    self.valueSelectionTableView.delegate = self;
    self.valueSelectionTableView.dataSource = self;
    [self.LIRRView setHidden:YES];
    [self.rechargeCardView setHidden:YES];
    [self.transitCardView setHidden:NO];
    rechareVal=@"20.00";
    
    [self.departAtTimeSwitch addTarget:self action:@selector(departAtTimeSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.arriveByTimeSwitch addTarget:self action:@selector(arriveByTimeSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.sevenDayUnlimitedSwitch addTarget:self action:@selector(sevenDayUnlimitedSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.sevenDayExpressSwitch addTarget:self action:@selector(sevenDayExpressSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [self.thirtyDaysUnlimitedSwitch addTarget:self action:@selector(thirtyDaysUnlimitedSwitchChange:) forControlEvents:UIControlEventValueChanged];
     //self.valueSelectionTableView.backgroundColor = [UIColor lightGrayColor];
    
    }

-(void) departAtTimeSwitchChange:(id)sender{
    if([sender isOn]){
        
        [self.arriveByTimeSwitch setOn:NO animated:YES];
    } else{
        [self.arriveByTimeSwitch setOn:YES animated:YES];
    }
}

-(void) arriveByTimeSwitchChange:(id)sender{
    if([sender isOn]){
        
        [self.departAtTimeSwitch setOn:NO animated:YES];
    } else{
        [self.departAtTimeSwitch setOn:YES animated:YES];
    }
}
-(void) sevenDayUnlimitedSwitchChange:(id)sender{
    if([sender isOn]){
        
        [self.sevenDayExpressSwitch setOn:NO animated:YES];
         [self.thirtyDaysUnlimitedSwitch setOn:NO animated:YES];
         mtaTicketLbl.text=@"7-Days Unlimited Bus Pass";
         mtaticketRechargeValue.text=@"$31.00";
         mtaTotalRechagreValue.text=@"$31.00";
        rechareVal=@"31.00";
    }
}
-(void) sevenDayExpressSwitchChange:(id)sender{
    if([sender isOn]){
        
        [self.sevenDayUnlimitedSwitch setOn:NO animated:YES];
        [self.thirtyDaysUnlimitedSwitch setOn:NO animated:YES];
        mtaTicketLbl.text=@"7-Days Express Bus Pass";
        mtaticketRechargeValue.text=@"$57.25";
        mtaTotalRechagreValue.text=@"$57.25";
        rechareVal=@"57.25";

    }
}
-(void) thirtyDaysUnlimitedSwitchChange:(id)sender{
    if([sender isOn]){
    
        [self.sevenDayUnlimitedSwitch setOn:NO animated:YES];
        [self.sevenDayExpressSwitch setOn:NO animated:YES];
        mtaTicketLbl.text=@"30-Days Unlimited Bus Pass";
        mtaticketRechargeValue.text=@"$116.50";
        mtaTotalRechagreValue.text=@"$116.50";
        rechareVal=@"116.50";
    }
}


- (IBAction)pickerSelector:(id)sender {
    
    UIButton *btn = (UIButton *) sender;
     self.valueSelectionTableView.dataSource = nil;
    if (btn.tag == 10) {
         // self.valueSelectionTableView.dataSource = nil;
        DropDownBtnTag = btn.tag;
          self.valueSelectionTableView.dataSource = self;
        self.valueSelectionTableView.frame = CGRectMake(10, 65, 355, 70);
        self.valueSelectionTableView.hidden = FALSE;
        [self.fareScrollView addSubview:self.valueSelectionTableView];
        
    } else if (btn.tag == 20) {
        
        DropDownBtnTag = btn.tag;
        self.valueSelectionTableView.dataSource = self;
        self.valueSelectionTableView.frame = CGRectMake(10, 135, 355, 70);
        self.valueSelectionTableView.hidden = FALSE;
        [self.fareScrollView addSubview:self.valueSelectionTableView];
    }else if(btn.tag == 30){
        
        DropDownBtnTag = btn.tag;
        self.valueSelectionTableView.dataSource = self;
        self.valueSelectionTableView.frame = CGRectMake(10, 205, 355, 70);
        self.valueSelectionTableView.hidden = FALSE;
        [self.fareScrollView addSubview:self.valueSelectionTableView];
    }else if(btn.tag == 40){
        
        DropDownBtnTag = btn.tag;
        self.valueSelectionTableView.dataSource = self;
        self.valueSelectionTableView.frame = CGRectMake(10, 205, 355, 70);
        self.valueSelectionTableView.hidden = FALSE;
        [self.fareScrollView addSubview:self.valueSelectionTableView];
    }else if(btn.tag == 50){
        
        DropDownBtnTag = btn.tag;
        self.valueSelectionTableView.dataSource = self;
        self.valueSelectionTableView.frame = CGRectMake(10, 275, 355, 70);
        self.valueSelectionTableView.hidden = FALSE;
        [self.fareScrollView addSubview:self.valueSelectionTableView];
    }
    
}

- (IBAction)makePayment:(id)sender {
    if ([self.MasterPassSwitch isOn]) {
    if (![rechargeCardView isHidden]) {
        if ([sevenDayExpressSwitch isOn]||[sevenDayUnlimitedSwitch isOn]||[thirtyDaysUnlimitedSwitch isOn]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            TransitWalletViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
            float val = [[self getRechargeValue] floatValue]*100;
            transitVC.rechargeVal=[NSString stringWithFormat:@"%f",val];
            transitVC.isCalledFromFare= YES;
            [self presentViewController:transitVC animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Master Card"
                                                            message:@"Please Select Trasit Pass Type."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }else{
         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        TransitWalletViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
        float val = [[self getRechargeValue] floatValue]*100;
        transitVC.rechargeVal=[NSString stringWithFormat:@"%f",val];
        transitVC.isCalledFromFare= YES;
        [self presentViewController:transitVC animated:YES completion:nil];
    }
}
   
    
}

-(NSString *) getRechargeValue
{
    
    return rechareVal;
}

-(IBAction)cancelPayment:(id)sender{
    
    if([self.presentingViewController revealedState] == JTRevealedStateLeft)
        [self.presentingViewController toggleRevealState:JTRevealedStateLeft];
    
       
      [self dismissViewControllerAnimated:YES completion:nil];

}

//*************Table View delegate and DataSource Methods***************//

//delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.valueSelectionTableView.hidden = true;
   // [self.valueSelectionTableView]
    
    // self.valueSelectionTableView.dataSource = nil;
     [ self.valueSelectionTableView reloadData];
    
    if (DropDownBtnTag == 10) {
        
        self.transitTypeLbl.text = [transitType objectAtIndex:indexPath.row];
        
    } else if(DropDownBtnTag == 20){
        if( [self.transitTypeLbl.text isEqualToString:@"New York City Transit"]){
             self.transitPassTypeLbl.text = [transitPassTypeForNYCB objectAtIndex:indexPath.row];
            if ([self.transitPassTypeLbl.text isEqualToString:@"MTA NY City Bus Pass"]) {
                [self.transitCardView setHidden:YES];
                [self.LIRRView setHidden:YES];
                [self.rechargeCardView setHidden:NO];
                rechareVal=@"31.00";
            }else{
            [self.transitCardView setHidden:NO];
            [self.LIRRView setHidden:YES];
            [self.rechargeCardView setHidden:YES];
            rechareVal=@"20.00";
            }
        }
        else{
            self.transitPassTypeLbl.text = [transitPassTypeForLIRR objectAtIndex:indexPath.row];
            [self.transitCardView setHidden:YES];
            [self.LIRRView setHidden:NO];
            [self.rechargeCardView setHidden:YES];
            rechareVal=@"10.32";
        }
        
    } else if(DropDownBtnTag == 30){
        
        self.transitCardLbl.text = [transitCardArray objectAtIndex:indexPath.row];
        
    }else if(DropDownBtnTag == 40){
        
        self.fromStationLbl.text = [frStationArray objectAtIndex:indexPath.row];
        
    }else if(DropDownBtnTag == 50){
        
        self.toStationLbl.text = [toStationarray objectAtIndex:indexPath.row];
        
    }else{
        self.transitTypeLbl.text = [transitType objectAtIndex:indexPath.row];
    }
    
}


////datasource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (DropDownBtnTag == 10) {
        
        return 2;
        
    }
    else if (DropDownBtnTag == 30) {
        
        return 1;
        
    } else if (DropDownBtnTag == 40) {
        
        return 1;
        
    }else if (DropDownBtnTag == 50) {
        
        return 1;
        
    }else {
        if( [self.transitTypeLbl.text isEqualToString:@"New York City Transit"]){
            return 2;
        }else
        return 1;
    }
    //return 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    static NSString *fareListIdentifer = @"fareListIdentifer";
    
    UITableViewCell *cell = [ self.valueSelectionTableView dequeueReusableCellWithIdentifier:nil];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:fareListIdentifer];
    }
    
    
    if (DropDownBtnTag == 10) {
        
       cell.textLabel.text = [transitType objectAtIndex:indexPath.row];
    } else if(DropDownBtnTag == 20){
        if([self.transitTypeLbl.text isEqualToString:@"New York City Transit"])
        cell.textLabel.text = [transitPassTypeForNYCB objectAtIndex:indexPath.row];
        else
        cell.textLabel.text = [transitPassTypeForLIRR objectAtIndex:indexPath.row];
    }else if(DropDownBtnTag == 30){
       
            cell.textLabel.text = [transitCardArray objectAtIndex:indexPath.row];
    }else if(DropDownBtnTag == 40){
        
        cell.textLabel.text = [frStationArray objectAtIndex:indexPath.row];
    }else if(DropDownBtnTag == 50){
        
        cell.textLabel.text = [toStationarray objectAtIndex:indexPath.row];
    }
    else{
         cell.textLabel.text = [transitType objectAtIndex:indexPath.row];
    }

    //cell.textLabel.text = [transitType objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}


- (IBAction)SideBarControllerBtn:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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

- (IBAction)btnTrainTicketCtrl:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TransitTicketsController *transitTicketsVC = [storyboard instantiateViewControllerWithIdentifier:@"transitTicketsController"];
    transitTicketsVC.isFare=YES;
    
    [self presentViewController:transitTicketsVC animated:YES completion:nil];
    

    

}
@end
