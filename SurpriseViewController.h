//
//  SurpriseViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/10/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface SurpriseViewController : UIViewController<UIWebViewDelegate,JTRevealSidebarV2Delegate,SidebarViewControllerDelegate, UIWebViewDelegate>
{
    UIButton *letsGoBtn;
    BOOL btnTapped;
}
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
@property (nonatomic, retain) UIActivityIndicatorView *indicator;
- (IBAction)toggleView:(id)sender;

@end
