//
//  splashScreenViewController.m
//  MastercardDemo
//
//  Created by Prateek on 6/3/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "splashScreenViewController.h"
#import "SubscriberViewCOntroller.h"
#import "AppDelegate.h"
#import "TransitViewController.h"


@interface splashScreenViewController ()

@end
@implementation splashScreenViewController
@synthesize footerSplashScreen;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.imgYellowBuuble setFrame:CGRectMake(350.0f, 234.0f, 105.0f, 94.0f)]; //350 to 180 (right to left)
    [self.imgRedBubble setFrame:CGRectMake(-100.0f, 234.0f, 105.0f, 94.0f)]; //-100 to 67  (left to right)
    [self.footerSplashScreen setFrame:CGRectMake(-100 , 72, 466, 422)];
    
    [UIView animateWithDuration:3.0f
     
                     animations:^{
                         
                         [self.footerSplashScreen setFrame:CGRectMake(0 , 72, 466, 422)];
                         //[self playAudio];
                         
                     }
     
                     completion:^(BOOL finished){
                         
                         AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
                         [appDelegate NetworkStatus];
                         NSDictionary *userinfo_dic= [NSDictionary dictionary];
                         userinfo_dic=[appDelegate UserinfoplistContent:NO];
                         NSString *status=[userinfo_dic objectForKey:@"setupDone"];
                         if([status isEqualToString:@"Success"])
                         {
                             if(appDelegate.nwStatus ==YES)
                             {
                                 
                                 UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle:nil];
                                 
                                 transitVc = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
                                 [self presentViewController:transitVc animated:YES completion:nil];
                             }
                             else
                             {
                                 
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                 alert.delegate=self;
                                 [alert show];
                                 
                             }
                             
                         }else
                         {
                             
                             if(appDelegate.NetworkStatus ==YES)
                             {
                                 
                                 UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                                                      bundle:nil];
                                 
                                 SubscriberViewController *transitCtrl = [storyboard instantiateViewControllerWithIdentifier:@"subscribeViewController"];
                                 
                                 
                                 [self presentViewController:transitCtrl animated:YES completion:nil];
                                 
                             }
                             else
                             {
                                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
                                 alert.delegate=self;
                                 [alert show];
                             }
                             
                             
                         }
                         
        }];
    
    
    self.footerSplashScreen.hidden=NO;
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activity setCenter:self.view.center];
    [self.view addSubview:activity];
    
    [UIView animateWithDuration:3.0f
                     animations:^{
//                         [self.imgRedBubble setFrame:CGRectMake((self.view.bounds.size.width)/2-100, 234.0f, 105.0f, 94.0f)];
//                         [self.imgYellowBuuble setFrame:CGRectMake((self.view.bounds.size.width)/2-30, 234.0f, 105.0f, 94.0f)];
                         [self.imgRedBubble setFrame:CGRectMake(105.0f, 234.0f, 95.0f, 85.0f)];
                         [self.imgYellowBuuble setFrame:CGRectMake(164.0f, 234.0f, 95.0f, 85.0f)];
                         [self performSelector:@selector(animateWheel) withObject:nil afterDelay:3.0];
                     }
                     completion:^(BOOL finished){
                         
                         
                         
                         
                         //goto next screen
                         [UIView animateWithDuration:3.0f
                                          animations:^{
                                              // [self playAudio];
                                              
                                              [self fadeInImage:self.imgMCLogo];
                                              [self fadeInImage:self.imgMCText];
                                              [self fadeInImage:self.imgMTALogo];
                                              [self fadeInImage:(UIImageView*)self.imgPoweredBy];
                                              [self fadeInImage:(UIImageView *)self.imgVersion];
                                              
                                          }
                                          completion:^(BOOL finished){
                                              
                                              self.imgRedBubble.hidden=YES;
                                              self.imgYellowBuuble.hidden=YES;
                                              
                                          }];
                         
                         
                         
                     }
     
     ];
    
    
}
//************************************* Audio Effect ***************************//

//- (void)playAudio {
//    [self playSound:@"sf_bay" :@"wav"];
//}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    exit(0);
}

-(void) animateWheel
{
    [activity startAnimating];
    [self.imgMCLogo setHidden:NO];
}

- (void)playSound :(NSString *)fName :(NSString *) ext{
    SystemSoundID audioEffect;
    NSString *path = [[NSBundle mainBundle] pathForResource : fName ofType :ext];
    if ([[NSFileManager defaultManager] fileExistsAtPath : path]) {
        NSURL *pathURL = [NSURL fileURLWithPath: path];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
        AudioServicesPlaySystemSound(audioEffect);
    }
    else {
        NSLog(@"error, file not found: %@", path);
    }
}


- (void)fadeInImage: (UIImageView *)imageView
{   imageView.hidden = NO;
    [UIView beginAnimations:@"fade in" context:nil];
    [UIView setAnimationDuration:1.0];
    imageView.alpha = 1.0;
    [UIView commitAnimations];
   
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

@end
