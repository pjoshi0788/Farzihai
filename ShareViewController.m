//
//  ShareViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/6/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
@synthesize myWebView,topView, indicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [topView setFrame:CGRectMake(0, 0, 375, 55)];
    
    NSString *urlString = @"https://www.apple.com/in/itunes/";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    myWebView.delegate=self;
    self.navigationItem.revealSidebarDelegate=self;
}

- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (!indicator) {
        indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(screenRect.size.width/2-20, screenRect.size.height/2-20,50,50)];
        [indicator setColor:[UIColor blackColor]];
        [self.view addSubview: indicator];
        
        [indicator startAnimating];
    }
    
//    [indicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    [indicator stopAnimating];
    indicator.hidden = TRUE;
}

-(void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [indicator stopAnimating];
    if ([error code]==-1009) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
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
}


@end
