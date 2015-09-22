//
//  PricelessCitiesViewController.m
//  MastercardFinal
//
//  Created by administrator on 11/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "PricelessCitiesViewController.h"
#import "AppDelegate.h"
#import "TransitViewController.h"

@interface PricelessCitiesViewController ()

@end

@implementation PricelessCitiesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.revealSidebarDelegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark SidebarViewControllerDelegate
- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    [self toggleRevealState:JTRevealedStateLeft];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)RSVPBtn:(id)sender {
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    NSDictionary *userinfo_dic= [NSDictionary dictionary];
    userinfo_dic = [appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"RSVP Successful" message:[NSString stringWithFormat:@"%@, your RSVP for the Foo Fighters VIP Concert Experience at Citi Field has been submitted.",name] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        _BookRSVPBtnView.hidden = TRUE;
        _ShareAndCancelRSVPBtnView.hidden = FALSE;
    }
}

- (IBAction)NotAttendingBtn:(id)sender {
    
//    TransitViewController *transitVC = [[TransitViewController alloc] init];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)CancelRSVPBtn:(id)sender {
    
    _BookRSVPBtnView.hidden = FALSE;
    _ShareAndCancelRSVPBtnView.hidden = TRUE;
    
}

- (IBAction)ShareBtn:(id)sender {
    
    NSString *Description = @"";
    
    NSArray *objectsToShare = [[NSArray alloc] initWithObjects:Description, nil];
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
        shareController.excludedActivityTypes = @[UIActivityTypeMessage, UIActivityTypePrint, UIActivityTypePostToWeibo,UIActivityTypePostToFlickr, UIActivityTypePostToVimeo,UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypePostToTencentWeibo, UIActivityTypeSaveToCameraRoll, UIActivityTypeAddToReadingList];
    
        shareController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if([topController isKindOfClass:[PricelessCitiesViewController class]])
    {
        [topController presentViewController:shareController animated:YES completion:nil];
    }

}

- (IBAction)SideBarBtn:(id)sender {
    [self toggleRevealState:JTRevealedStateLeft];

    
}
@end
