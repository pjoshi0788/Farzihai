//
//  WalletPaymentViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/3/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "WalletPaymentViewController.h"
#import <PassKit/PassKit.h>
#import "SimplifyMerchantSDK/SIMChargeCardViewController.h"
#import "SimplifyMerchantSDK/UIImage+Simplify.h"
#import "SimplifyMerchantSDK/UIColor+Simplify.h"
#import "SimplifyMerchantSDK/SIMResponseViewController.h"
#import "SimplifyMerchantSDK/SIMTokenProcessor.h"
#import "SimplifyMerchantSDK/SIMWaitingView.h"
#import "SimplifyMerchantSDK/SIMSimplify.h"
#import "RechargeViewController.h"
#import "TransitViewController.h"
#import "AppDelegate.h"
#import "TransitTicketsController.h"
#import "RentCarDetailsViewController.h"
#import "ParkingViewController.h"
#import "QkrViewController.h"

@interface WalletPaymentViewController ()

@end

@implementation WalletPaymentViewController
@synthesize selectedCardIndex,selectedCardView,cardTypeLbl,primaryColor,rechargeVal,isCalledFromFare;
@synthesize payBtn;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
     self.navigationItem.revealSidebarDelegate=self;
    [self setCardImage];
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
-(void) setCardImage
{
//    [cardTypeLbl setFrame:CGRectMake(50,220,240,20)];
    switch (selectedCardIndex)
    {
        case 0:{
            selectedCardView.image = [UIImage imageNamed:@"mastercard-black.png"];
            UILabel *platCard = [[UILabel alloc] initWithFrame:CGRectMake(15,15,100,25)];
            [platCard setText:@"Platinum Card"];
            [platCard setTextColor:[UIColor whiteColor]];
            [platCard setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
          
            
            
            
            UILabel *brillioLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,45,  50, 25)];
            [brillioLbl setText:@"brillio"];
            [brillioLbl setTextColor:[UIColor whiteColor]];
            [brillioLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            UILabel *cardNumLbl =[[UILabel alloc] initWithFrame:CGRectMake(15,80, 200, 25)];
            [cardNumLbl setText:@"XXXX-XXXX-XXXX-0014"];
            [cardNumLbl setTextColor:[UIColor whiteColor]];
            [cardNumLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            UILabel *expiryLbl =[[UILabel alloc] initWithFrame:CGRectMake(15,115,  150, 25)];
            [expiryLbl setText:@"Expires 01/2025"];
            [expiryLbl setTextColor:[UIColor whiteColor]];
            [expiryLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [selectedCardView addSubview:platCard];
            [selectedCardView addSubview:brillioLbl];
            [selectedCardView addSubview:cardNumLbl];
            [selectedCardView addSubview:expiryLbl];

            cardTypeLbl.text = @"Platinum Card XXXX-XXXX-XXXX-0014";
            }
            break;
        case 1:{
            selectedCardView.image = [UIImage imageNamed:@"mastercard-blue.png"];
         
            UILabel *preferredCard = [[UILabel alloc] initWithFrame:CGRectMake(15,15,100,25)];
            [preferredCard setText:@"Preferred Card"];
            [preferredCard setTextColor:[UIColor whiteColor]];
            [preferredCard setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            
            UILabel *brillioLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(15,45,  50, 25)];
            [brillioLbl2 setText:@"brillio"];
            [brillioLbl2 setTextColor:[UIColor whiteColor]];
            [brillioLbl2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            UILabel *cardNumLbl2 =[[UILabel alloc] initWithFrame:CGRectMake(15,80, 200, 25)];
            [cardNumLbl2 setText:@"XXXX-XXXX-XXXX-0010"];
            [cardNumLbl2 setTextColor:[UIColor whiteColor]];
            [cardNumLbl2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            UILabel *expiryLbl2 =[[UILabel alloc] initWithFrame:CGRectMake(15,115,  150, 25)];
            [expiryLbl2 setText:@"Expires 01/2025"];
            [expiryLbl2 setTextColor:[UIColor whiteColor]];
            [expiryLbl2 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            [selectedCardView addSubview:preferredCard];
            [selectedCardView addSubview:brillioLbl2];
            [selectedCardView addSubview:cardNumLbl2];
            [selectedCardView addSubview:expiryLbl2];
            
            cardTypeLbl.text = @"Preferred Card XXXX-XXXX-XXXX-0010";
        }
            break;
        case 2: {
            
        selectedCardView.image = [UIImage imageNamed:@"mastercard-yellow.png"];
            UILabel *monthlyPassLbl = [[UILabel alloc] initWithFrame:CGRectMake(15,15,100,25)];
            [monthlyPassLbl setText:@"Monthly Pass"];
            [monthlyPassLbl setTextColor:[UIColor whiteColor]];
            [monthlyPassLbl setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            
            UILabel *brillioLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(15,45,  50, 25)];
            [brillioLbl3 setText:@"brillio"];
            [brillioLbl3 setTextColor:[UIColor whiteColor]];
            [brillioLbl3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            UILabel *cardNumLbl3 =[[UILabel alloc] initWithFrame:CGRectMake(15,80, 200, 25)];
            [cardNumLbl3 setText:@"XXXX-XXXX-XXXX-0006"];
            [cardNumLbl3 setTextColor:[UIColor whiteColor]];
            [cardNumLbl3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
            
            
            UILabel *expiryLbl3 =[[UILabel alloc] initWithFrame:CGRectMake(15,115,  150, 25)];
            [expiryLbl3 setText:@"Expires 11/31/15"];
            [expiryLbl3 setTextColor:[UIColor whiteColor]];
            [expiryLbl3 setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
        
            [selectedCardView addSubview:monthlyPassLbl];
             [selectedCardView addSubview:brillioLbl3];
             [selectedCardView addSubview:cardNumLbl3];
             [selectedCardView addSubview:expiryLbl3];
            
            cardTypeLbl.text = @"Monthly Pass XXXX-XXXX-XXXX-0006";
        
        }    break;
    }
}
- (IBAction)payWithCard:(id)sender {
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        NSData *returnData = [[NSData alloc]init];
        NSError *error=nil;
        NSURLResponse  *response = nil;
        

        //Handle your server's response
       // NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        UILabel *successLbl = [[UILabel alloc] initWithFrame:CGRectMake(80,330,200,70)];
        [successLbl setTextAlignment:NSTextAlignmentCenter];
        
        NSLog(@"recharge val %@",rechargeVal);
        float val = [rechargeVal floatValue]/100;
        if (val!= 0) {
            successLbl.text = [NSString stringWithFormat:@"Payment Successful $%.02f",val];
            [successLbl setNumberOfLines:2];
        }else {
            successLbl.text = [NSString stringWithFormat:@"Payment Successful %@",_RechargeValueDemoTime];
            [successLbl setNumberOfLines:2];
        }
        
        NSArray *localPriceArray = [rechargeVal componentsSeparatedByString:@" "];
        NSString *localPriceVal = [localPriceArray objectAtIndex:0];
        
        NSURL *url= [NSURL URLWithString:
                     [NSString stringWithFormat:@"http://bcmapi.herokuapp.com/paywithcardextra?desc=recharge&amount=%@", localPriceVal]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:url];
        
        //Send the Request
        returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
        if (error) {
            NSLog(@"error:%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            //Handle your server error
            
        } else {
            
            //Handle your server's response
            // NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            UILabel *successLbl = [[UILabel alloc] initWithFrame:CGRectMake(80,330,200,70)];
            [successLbl setTextAlignment:NSTextAlignmentCenter];
            float val = [rechargeVal floatValue]/100;
            
            if (val!= 0) {
                successLbl.text = [NSString stringWithFormat:@"Payment Successful $%.02f",val];
                [successLbl setNumberOfLines:2];
            }else {
                successLbl.text = [NSString stringWithFormat:@"Payment Successful $%@",localPriceVal];
                [successLbl setNumberOfLines:2];
            }
            
            [self.view addSubview:successLbl];
            [self.payBtn setImage:[UIImage imageNamed:@"payment-successful.png"] forState:UIControlStateNormal];
            // [self.payBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchDown];
            
            if(self.isCalledFromFare){
                [self performSelector:@selector(openTransitTicket) withObject:self afterDelay:2.0];

                
            }else{
                [self performSelector:@selector(dismissView) withObject:self afterDelay:2.0];
            }
            
            
        }
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
  }

-(void)openTransitTicket{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TransitTicketsController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitTicketsController"];
    [self presentViewController:transitVC animated:YES completion:nil];
}

- (IBAction)toggleView:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
}

-(void) dismissView
{
 //   UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//    RechargeViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"rechargeViewController"];
//    
//    [self presentViewController:transitVC animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(![self.presentingViewController.presentingViewController isKindOfClass:[RentCarDetailsViewController class]] && ![self.presentingViewController.presentingViewController isKindOfClass:[ParkingViewController class]] &&  ![self.presentingViewController.presentingViewController isKindOfClass:[QkrViewController class]])
    {
        TransitViewController *tvc = (TransitViewController*)appDelegate.window.rootViewController;
        [tvc.scrollViewTransit setContentOffset:CGPointMake(760, 0) animated:YES];
    }
    
    if([self.presentingViewController.presentingViewController isKindOfClass:[QkrViewController class]])
    {
        QkrViewController *qVc = (QkrViewController*)self.presentingViewController.presentingViewController;
        if(!qVc.isDemoModeOn)
        {
            TransitViewController *tvc = (TransitViewController*)appDelegate.window.rootViewController;
            [tvc.scrollViewTransit setContentOffset:CGPointMake(760, 0) animated:YES];
            
        }
        else
        qVc.isDemoModeOn = FALSE;
    }
    
    [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    // [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
   //[self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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
   }

@end
