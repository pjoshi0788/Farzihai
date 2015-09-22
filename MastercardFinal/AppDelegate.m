//
//  AppDelegate.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/4/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Reachability.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "TransitViewController.h"
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>
#import "splashScreenViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize setnotice,rentcar_cab,  currLat, currLong,noticeRepeat;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //[GMSServices provideAPIKey:@"AIzaSyBJeExgtie4qNXU2wyFN442CNV3sU1YusA"];
    
    noticeRepeat=FALSE;
    setnotice =NO;
    [GMSServices provideAPIKey:@"AIzaSyCBBzuSsJcuA0f2oOO-qCB-OVHHoQJrnNw"];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    if (screenBounds.size.width > 375) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compatibility Issue" message:@"This app is not compatible with iPhone 6+ " delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }else if (screenBounds.size.width < 375) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Compatibility Issue" message:@"This app is not compatible with iPhone 5s " delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
//    else
//    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
//        splashScreenViewController *splashVC = [storyboard instantiateViewControllerWithIdentifier:@"splashVc"];
//        
//        [self.window.rootViewController presentViewController:splashVC animated:YES completion:nil];;
//        [self.window makeKeyAndVisible];
//
//    }
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    
    //[[Twitter sharedInstance] startWithConsumerKey:@"1rWMXxqNYRIxzB9A7FxMkMw8W" consumerSecret:@"v2a8QVTec4OsJKt1YrcUwHawbG7ccuwjK2IhXkMizCN9A21B0W"];
   // [Fabric with:@[[Twitter sharedInstance]]];
      [Fabric with:@[TwitterKit]];
   // return YES;
    

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    exit(0);
    
}

-(BOOL)NetworkStatus
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        self.nwStatus = NO;
        return NO;
    }else
    {
        self.nwStatus = YES;
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    //Place your code to handle the notification here.
    
    NSLog(@"Notification message = %@", notification.alertBody);
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
-(NSDictionary*)UserinfoplistContent :(BOOL)isHelpView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSFileManager *fileMgr = [[NSFileManager alloc] init];
    NSError *error = nil;
    NSDictionary *plistcontent =[NSDictionary dictionary];
    NSArray *directoryContents = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error];
    if([directoryContents count] > 0)
    {
        if (error == nil)
        {
            for (NSString *path in directoryContents)
            {
                NSString *localPlistString =@"UserInfo.plist";
                
                if (isHelpView == YES) {
                    localPlistString =@"UserInfo1.plist";
                }
                
                if([path isEqualToString:localPlistString])
                {
                    NSString *plistPath = [documentsDirectory stringByAppendingPathComponent:path];
                
                    NSFileManager* fileManager = [NSFileManager defaultManager];
                
                    if ([fileManager fileExistsAtPath:plistPath]) 
                        plistcontent = [NSDictionary dictionaryWithContentsOfFile:plistPath];
                
                   return  plistcontent;
                }
            }
        }
    }
    
    return plistcontent;
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}



@end
