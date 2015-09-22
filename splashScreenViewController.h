//
//  splashScreenViewController.h
//  MastercardDemo
//
//  Created by Prateek on 6/3/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "TransitViewController.h"

@interface splashScreenViewController : UIViewController<UIAlertViewDelegate>
{
    UIActivityIndicatorView *activity;
    TransitViewController *transitVc;
}
@property (weak, nonatomic) IBOutlet UIImageView *footerSplashScreen;
@property (weak, nonatomic) IBOutlet UIImageView *imgYellowBuuble;
@property (weak, nonatomic) IBOutlet UIImageView *imgRedBubble;
@property (weak, nonatomic) IBOutlet UIImageView *imgMCLogo;
@property (weak, nonatomic) IBOutlet UIImageView *imgMCText;
@property (weak, nonatomic) IBOutlet UIImageView *imgMTALogo;
@property (weak, nonatomic) IBOutlet UILabel *imgPoweredBy;
@property (weak, nonatomic) IBOutlet UILabel *imgVersion;

@end
