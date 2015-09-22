//
//  SurpriseViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/10/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "SurpriseViewController.h"
#import "TransitViewController.h"

@implementation SurpriseViewController
@synthesize myWebView,sideBarViewController, indicator;

- (void)viewDidLoad {
    [super viewDidLoad];

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(screenRect.size.width/2-20, screenRect.size.height/2-20,50,50)];
    [indicator setColor:[UIColor blackColor]];
    [self.view addSubview: indicator];
    
    [indicator startAnimating];

    NSString *urlString = @"https://www.priceless.com/ny";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    myWebView.delegate=self;
    self.navigationItem.revealSidebarDelegate=self;
    btnTapped = FALSE;
    [self addButton];
    
   // [self performSelector:@selector(hideButton) withObject:nil afterDelay:3.0];
    
    
    
}

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
}
- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    
    indicator.hidden =YES;
    [indicator removeFromSuperview];
    
    
}

-(void) addButton
{
    letsGoBtn = [[UIButton alloc] initWithFrame:CGRectMake(405, 300, 63, 100)];
    
    [letsGoBtn setBackgroundImage:[UIImage imageNamed:@"lets-go_rev.png"] forState:UIControlStateNormal];
    [letsGoBtn addTarget:self action:@selector(showTransitView) forControlEvents:UIControlEventTouchUpInside];
    [myWebView addSubview:letsGoBtn];
    
    
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [indicator stopAnimating];
    NSLog(@"error %ld",(long)[error code]);
    if ([error code]==-1009) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

-(void) showTransitView
{
    if(!btnTapped)
    {
        [self hideButton];
        btnTapped = TRUE;
    }
    else
    {
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                         bundle:nil];
    
    TransitViewController *transitCtrl = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
    [self presentViewController:transitCtrl animated:YES completion:nil];
    }

}
-(void) hideButton
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    letsGoBtn.frame = CGRectMake(360,letsGoBtn.frame.origin.y,letsGoBtn.frame.size.width,letsGoBtn.frame.size.height);
   
    [UIView commitAnimations];
}
- (IBAction)toggleView:(id)sender {
    [self toggleRevealState:JTRevealedStateLeft];
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
