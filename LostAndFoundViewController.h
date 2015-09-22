//
//  LostAndFoundViewController.h
//  MastercardFinal
//
//  Created by Prateek on 8/5/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface LostAndFoundViewController : UIViewController<UIWebViewDelegate,JTRevealSidebarV2Delegate,SidebarViewControllerDelegate>



@property (weak, nonatomic) IBOutlet UIWebView *myWebView;
@property(nonatomic,retain) UIActivityIndicatorView *indicator;
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
- (IBAction)toggleView:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *topView;

@end
