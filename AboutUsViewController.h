//
//  AboutUsViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/18/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface AboutUsViewController : UIViewController<UIWebViewDelegate,JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property(nonatomic,retain) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
- (IBAction)toggleView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;




@end
