//
//  RechargeViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/16/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "RechargeViewController.h"
#import "MenuView.h"
#import <PassKit/PassKit.h>
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"
#import "SimplifyMerchantSDK/UIImage+Simplify.h"
#import "SimplifyMerchantSDK/UIColor+Simplify.h"
#import "SimplifyMerchantSDK/SIMResponseViewController.h"
#import "SimplifyMerchantSDK/SIMTokenProcessor.h"
#import "SimplifyMerchantSDK/SIMWaitingView.h"
#import "SimplifyMerchantSDK/SIMSimplify.h"
#import "TransitWalletViewController.h"
#import "AppDelegate.h"


@implementation RechargeViewController
@synthesize chargeController, primaryColor, sevenDayExpSwitch,sevenDayUnlSwitch,thirtyDayUnlSwitch;

-(void) viewDidLoad
{
    
    self.navigationItem.revealSidebarDelegate=self;
   [sevenDayUnlSwitch addTarget:self action:@selector(sevenDayUnlSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [sevenDayExpSwitch addTarget:self action:@selector(sevenDayExpSwitchChange:) forControlEvents:UIControlEventValueChanged];
    [thirtyDayUnlSwitch addTarget:self action:@selector(thirtyDayUnlSwitchChange:) forControlEvents:UIControlEventValueChanged];
}

-(void) sevenDayUnlSwitchChange:(id)sender{
    if([sender isOn]){
        [thirtyDayUnlSwitch setOn:NO animated:YES];
        [sevenDayExpSwitch setOn:NO animated:YES];
    }
}
-(void) sevenDayExpSwitchChange:(id)sender{
    if([sender isOn]){
        [thirtyDayUnlSwitch setOn:NO animated:YES];
        [sevenDayUnlSwitch setOn:NO animated:YES];
    }
}
-(void) thirtyDayUnlSwitchChange:(id)sender{
    if([sender isOn]){
        [sevenDayUnlSwitch setOn:NO animated:YES];
        [sevenDayExpSwitch setOn:NO animated:YES];
    }}

- (IBAction)showMenu:(id)sender {
  
    if(rechgMenuView == nil)
    {
    rechgMenuView = [[MenuView alloc] initWithFrame:CGRectMake(200, 20, 150, 245)];
    [rechgMenuView setBackgroundColor:[UIColor colorWithRed:14/255.0 green:14/255.0 blue:14/255.0 alpha:1.0]];
    [self.view addSubview:rechgMenuView];
    }
}


-(NSString *) getRechargeValue
{
   if([sevenDayUnlSwitch isOn])
       return @"31";
    else if([sevenDayExpSwitch isOn])
        return @"57.25";
    else if([thirtyDayUnlSwitch isOn])
        return @"116.5";
    
    return @"1";
}
- (IBAction)makePayment:(id)sender {
    
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            TransitWalletViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
    float val = [[self getRechargeValue] intValue]*100;
    transitVC.rechargeVal=[NSString stringWithFormat:@"%f",val];
            [self presentViewController:transitVC animated:YES completion:nil];
    
}

- (IBAction)toggleView:(id)sender {
    [self toggleRevealState:JTRevealedStateLeft];

}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    
    CGPoint location = [touch locationInView:rechgMenuView];
    
    
    if (location.x < rechgMenuView.frame.origin.x || location.x <0 || location.y > rechgMenuView.frame.size.height || location.x > rechgMenuView.frame.size.width) {
        // your code here...
        
        //rechgMenuView =nil;
        [rechgMenuView removeFromSuperview];
        rechgMenuView=nil;
    }
    
    
}
//delegate callback for Cancel Recharge
-(void) chargeCardCancelled
{
    
}

-(void) creditCardTokenProcessed:(SIMCreditCardToken *)token
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        NSString *rechgVal = [self getRechargeValue];
        NSData *returnData = [[NSData alloc]init];
        NSError *error=nil;
        NSURLResponse  *response = nil;
        
        NSURL *url= [NSURL URLWithString:
                     [NSString stringWithFormat:@"https://bcmapi.herokuapp.com/paywithtoken?authid=987654321&token=%@&amount=%@&desc=CardRecharge",token.token,rechgVal]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:url];
        
        //Send the Request
        returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
        if (error) {
            NSLog(@"error:%@", error);
            //Handle your server error
            
        } else {
            
            //Handle your server's response
            // NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Card Recharge" message:@"Payment Successfull" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }

    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
   
    
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
    
    return controller.view;}

#pragma mark SidebarViewControllerDelegate
- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    [self toggleRevealState:JTRevealedStateLeft];
    //
    //    if(indexPath.row == 0)
    //    {
    //        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    //        firstNameViewController *firstNameVC = [storyboard instantiateViewControllerWithIdentifier:@"FirstName"];
    //        [self.navigationController pushViewController:firstNameVC animated:YES];
    //    }
    //    if(indexPath.row ==1)
    //    {
    //        TweetViewController *twtVc =
    //        [self.storyboard instantiateViewControllerWithIdentifier:@"tweetview"];
    //        [self.navigationController pushViewController:twtVc animated:YES];
    //
    //    }
}

@end
