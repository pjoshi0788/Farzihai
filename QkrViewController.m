//
//  QkrViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/6/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "QkrViewController.h"
#import "TransitWalletViewController.h"
#import "AppDelegate.h"

@interface QkrViewController ()

@end

@implementation QkrViewController
@synthesize qkrScrollView,topView,countLbl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   // [topView setBackgroundColor:[UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1.0]];
    
   // [topView setBackgroundColor:[UIColor blackColor]];
    [topView setFrame:CGRectMake(0,0,375,55)];
    [qkrScrollView setFrame:CGRectMake(0,53,375,663)];
    [qkrScrollView setContentSize:CGSizeMake(375,1000)];
     self.navigationItem.revealSidebarDelegate=self;
    
    
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




- (IBAction)makePayment:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    TransitWalletViewController *transitVC = [storyboard instantiateViewControllerWithIdentifier:@"transitWalletViewController"];
    float val = 6.5*100;
    transitVC.rechargeVal=[NSString stringWithFormat:@"%f",val];
    [self presentViewController:transitVC animated:YES completion:nil];
}
- (IBAction)toggleView:(id)sender {
    
     [self toggleRevealState:JTRevealedStateLeft];
}

- (IBAction)decreaseCount:(id)sender {
    
    if(![countLbl.text isEqualToString:@"0"])
    {
        countLbl.text = [NSString stringWithFormat:@"%d",[countLbl.text intValue]-1];
    }
}

- (IBAction)increaseCount:(id)sender {
    countLbl.text = [NSString stringWithFormat:@"%d",[countLbl.text intValue]+1];
}

- (IBAction)cancelBtn:(id)sender {
    UIViewController* topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    //[self dismissViewControllerAnimated:topController completion:nil];
    if([self.presentingViewController revealedState] == JTRevealedStateLeft)
       [self.presentingViewController toggleRevealState:JTRevealedStateLeft];
    
//    if([self.presentingViewController isKindOfClass:[TransitViewController class]])
//    {
//        TransitViewController *tvc = (TransitViewController*)self.presentingViewController;
//        [tvc.scrollViewTransit setContentOffset:CGPointMake(760, 0) animated:YES];
//    }
   
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [appDelegate.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
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
