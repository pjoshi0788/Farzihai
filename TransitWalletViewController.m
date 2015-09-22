//
//  TransitWalletViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/3/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "TransitWalletViewController.h"
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
#import <AppDelegate.h>


@interface TransitWalletViewController ()

@end

@implementation TransitWalletViewController
@synthesize cardScrollView,selectedCard,isCalledFromFare;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.revealSidebarDelegate=self;
    [self setUpCardScroll];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setUpCardScroll
{
//    [cardScrollView setFrame:CGRectMake(50, 141, 349, 200)];
    [cardScrollView setContentSize:CGSizeMake(1050, 200)];
    [cardScrollView setScrollEnabled:YES];
    [cardScrollView setShowsVerticalScrollIndicator:NO];
    [cardScrollView setPagingEnabled:YES];
    cardScrollView.delegate=self;
    selectedCard.text = @"XXXX-XXXX-XXXX-0014";
    [selectedCard setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    
    //BLACK CARD
    UIButton *blackCardBtn = [[UIButton alloc] initWithFrame:CGRectMake(19,0,315,200)];
    [blackCardBtn setImage:[UIImage imageNamed:@"mastercard-black.png"] forState:UIControlStateNormal];
//    [blackCardBtn contentMode:UIViewContentModeCenter];
    
    UILabel *platCard = [[UILabel alloc] initWithFrame:CGRectMake(15,15,100,25)];
    [platCard setText:@"Platinum Card"];
    [platCard setTextColor:[UIColor whiteColor]];
    [platCard setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    blackCardBtn.tag=0;
    [blackCardBtn addTarget:self action:@selector(PayWithSelectedCard:) forControlEvents:UIControlEventTouchUpInside];
    
    
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
    

    [blackCardBtn addSubview:platCard];
    [blackCardBtn addSubview:cardNumLbl];
    [blackCardBtn addSubview:expiryLbl];
    [blackCardBtn addSubview:brillioLbl];
    
    //blue card
    UIButton *blueCardBtn = [[UIButton alloc] initWithFrame:CGRectMake(360,0,315,200)];
    blueCardBtn.tag=1;
    [blueCardBtn addTarget:self action:@selector(PayWithSelectedCard:) forControlEvents:UIControlEventTouchUpInside];
    
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
  
    
    [blueCardBtn addSubview:preferredCard];
    [blueCardBtn addSubview:cardNumLbl2];
    [blueCardBtn addSubview:expiryLbl2];
    [blueCardBtn addSubview:brillioLbl2];
    

    //yellow card
    [blueCardBtn setImage:[UIImage imageNamed:@"mastercard-blue.png"] forState:UIControlStateNormal];
    
    
    UIButton *yellowCardBtn = [[UIButton alloc] initWithFrame:CGRectMake(715,0,315,200)];
    [yellowCardBtn setImage:[UIImage imageNamed:@"mastercard-yellow.png"] forState:UIControlStateNormal];
    yellowCardBtn.tag=2;
    [yellowCardBtn addTarget:self action:@selector(PayWithSelectedCard:) forControlEvents:UIControlEventTouchUpInside];

    
    
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
    
    
    [yellowCardBtn addSubview:monthlyPassLbl];
    [yellowCardBtn addSubview:cardNumLbl3];
    [yellowCardBtn addSubview:expiryLbl3];
    [yellowCardBtn addSubview:brillioLbl3];

    
    [cardScrollView addSubview:blackCardBtn];
    [cardScrollView addSubview:blueCardBtn];
    [cardScrollView addSubview:yellowCardBtn];

    
}
-(void) PayWithSelectedCard:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    switch (btn.tag)
    {
        case 0:
        {
            
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                    bundle:nil];
            
            WalletPaymentViewController *paymentCtrl = [storyboard instantiateViewControllerWithIdentifier:@"walletPaymentController"];
            paymentCtrl.selectedCardIndex=0;
            paymentCtrl.rechargeVal=_rechargeVal;
            if (self.isCalledFromFare) {
                paymentCtrl.isCalledFromFare=YES;
            }
            [self presentViewController:paymentCtrl animated:YES completion:nil];
            
        }
            break;
        case 1:
        {
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:nil];
            
            WalletPaymentViewController *paymentCtrl = [storyboard instantiateViewControllerWithIdentifier:@"walletPaymentController"];
            paymentCtrl.selectedCardIndex=1;
            paymentCtrl.rechargeVal=_rechargeVal;
            [self presentViewController:paymentCtrl animated:YES completion:nil];
        }
            break;
        case 2:
        {
            
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle:nil];
            
            WalletPaymentViewController *paymentCtrl = [storyboard instantiateViewControllerWithIdentifier:@"walletPaymentController"];
            paymentCtrl.selectedCardIndex =2;
            paymentCtrl.rechargeVal=_rechargeVal;
            [self presentViewController:paymentCtrl animated:YES completion:nil];
        }
            break;
            
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    NSInteger page = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    switch (page)
    {
        case 0: selectedCard.text = @"XXXX-XXXX-XXXX-0014";
            break;
        case 1:selectedCard.text = @"XXXX-XXXX-XXXX-0010";
            break;
        case 2: selectedCard.text=@"XXXX-XXXX-XXXX-0006";
            break;
        default:
            break;
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)chooseOtherCard:(id)sender {
    
    float val = [_rechargeVal floatValue]/100;
    NSString *rchgStr = [NSString stringWithFormat:@"%.02f",val];
    PKPaymentSummaryItem *mposButtons = [[PKPaymentSummaryItem alloc] init];
    mposButtons.label = @"mPOS Buttons";
    mposButtons.amount = [[NSDecimalNumber alloc] initWithString:rchgStr];
    
    PKPaymentRequest* paymentRequest = [[PKPaymentRequest alloc] init];
    paymentRequest.supportedNetworks = @[PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];
    paymentRequest.countryCode = @"US";
    paymentRequest.currencyCode = @"USD";
    
    //2. SDKDemo.entitlements needs to be updated to use the new merchant id
    paymentRequest.merchantIdentifier = @"<#INSERT_YOUR_MERCHANT_ID_HERE#>";
    
    paymentRequest.merchantCapabilities = PKMerchantCapabilityEMV | PKMerchantCapability3DS;
    paymentRequest.paymentSummaryItems = @[mposButtons];
    paymentRequest.requiredBillingAddressFields = PKAddressFieldAll;
    paymentRequest.requiredShippingAddressFields = PKAddressFieldPostalAddress;
    
    //3. Create a SIMChargeViewController with your public api key
    
    SIMChargeCardViewController *chargeCont = [[SIMChargeCardViewController alloc] initWithPublicKey:@"sbpb_MjVlNGU1YWEtOTU5YS00ZjNlLWEwNzYtNGMwMDRiZThlM2M0" paymentRequest:paymentRequest primaryColor:self.primaryColor];
    
    //4. Assign your class as the delegate to the SIMChargeViewController class which takes the user input and requests a token
    chargeCont.delegate = self;
    chargeCont.amount = mposButtons.amount;
    chargeCont.isCVCRequired = NO;
    chargeCont.isZipRequired = YES;
    //chargeCont.cardNumberField.text = @"5204740009900014";
    self.chargeController = chargeCont;
    
    //5. Add SIMChargeViewController to your view hierarchy
    [self presentViewController:self.chargeController animated:YES completion:nil];

}

- (IBAction)toggleView:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
}

- (IBAction)cancelBtnTapped:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void) chargeCardCancelled
{
    
}

-(void) creditCardTokenProcessed:(SIMCreditCardToken *)token
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        NSData *returnData = [[NSData alloc]init];
        NSError *error=nil;
        NSURLResponse  *response = nil;
        
        NSURL *url= [NSURL URLWithString:
                     [NSString stringWithFormat:@"http://bcmapi.herokuapp.com/paywithtoken?authid=987654321&token=%@&amount=%@&desc=CardRecharge",token.token,_rechargeVal]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setHTTPMethod:@"GET"];
        [request setURL:url];
        
        //Send the Request
        returnData = [NSURLConnection sendSynchronousRequest: request returningResponse: &response error: &error];
        if (error) {
            NSLog(@"error:%@", error);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            //Handle your server error
            
        } else {
            
            //Handle your server's response
            //  NSString *returnStr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Card Recharge" message:@"Payment Successfull" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            
            //[self performSelector:@selector(dismissView) withObject:self afterDelay:2.0];
            
        }
        
        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
   // UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
   // RechargeViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"rechargeViewController"];
    
   // [self presentViewController:transitVC animated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void) dismissView
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    RechargeViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"rechargeViewController"];
    
    [self presentViewController:transitVC animated:YES completion:nil];
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
