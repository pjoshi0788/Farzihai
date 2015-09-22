//
//  AppDelegate.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/4/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplashScreenViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UIAlertViewDelegate>
{
    float currLong;
    float currLat;
    
}
@property (strong, nonatomic) UIWindow *window;
@property (retain,nonatomic) NSString *origin1;
@property (retain,nonatomic) NSString *destination1;
@property (retain,nonatomic) NSString *appOriginFromSubscriber;
@property (retain,nonatomic) NSString *appDestFromSubscriber;
@property (strong,nonatomic) NSString *currentLocationLatLong;
@property (retain,nonatomic) NSString *transitMode;

@property (retain,nonatomic) NSString *strLatOAP;
@property (retain,nonatomic) NSString *strLongOAP;
@property (atomic) BOOL nwStatus;
-(BOOL)NetworkStatus;
@property (retain,nonatomic) NSString *strEncodedPath;
@property(nonatomic, assign) BOOL setnotice;
@property(nonatomic, assign) BOOL rentcar_cab;
@property(nonatomic, assign) BOOL rootViewSet;
@property (assign,nonatomic) NSInteger count;
-(NSDictionary*)UserinfoplistContent:(BOOL)isHelpView;
@property float currLong;
@property float currLat;
@property(nonatomic, assign) BOOL noticeRepeat;
@end

