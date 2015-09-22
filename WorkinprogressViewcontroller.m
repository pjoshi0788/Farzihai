//
//  widgetViewController.m
//  mtaWidget
//
//  Created by Prateek on 6/8/15.
//  Copyright (c) 2015 matrix. All rights reserved.
//

#import "WorkinprogressViewcontroller.h"
#import "JTRevealSidebarV2Delegate.h"
#import "UINavigationItem+JTRevealSidebarV2.h"
#import "UIViewController+JTRevealSidebarV2.h"
#import "SidebarViewController.h"

@interface WorkinprogressViewcontroller () <SidebarViewControllerDelegate,JTRevealSidebarV2Delegate>
@property (strong, nonatomic) SidebarViewController *sideBarViewController;
@end


@implementation WorkinprogressViewcontroller
@synthesize sideBarViewController;

- (void)viewDidLoad {
    
    
    self.navigationItem.revealSidebarDelegate=self;
}

- (IBAction)toggleView:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
}

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
    
    return controller.view;
}

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