//
//  LostAndFoundViewController.m
//  MastercardFinal
//
//  Created by Prateek on 8/5/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "LostAndFoundViewController.h"

@interface LostAndFoundViewController ()

@end

@implementation LostAndFoundViewController
@synthesize myWebView, topView, indicator;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlString = @"http://web.mta.info/mta/lost_found.html";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:request];
    self.navigationItem.revealSidebarDelegate=self;
    myWebView.delegate =self;
    myWebView.scalesPageToFit = YES;
    myWebView.contentMode = UIViewContentModeScaleAspectFit;
    myWebView.scrollView.showsHorizontalScrollIndicator = NO;
    myWebView.scrollView.showsVerticalScrollIndicator = NO;
    [topView setFrame:CGRectMake(0,0,414,55)];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    indicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(screenRect.size.width/2-20, screenRect.size.height/2-20,50,50)];
    [indicator setColor:[UIColor blackColor]];
    [self.view addSubview: indicator];
    
    [indicator startAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIWebDelegate implementation


- (void) webViewDidStartLoad:(UIWebView*)theWebView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView*)theWebView
{
    [indicator stopAnimating];
}

- (void) webView:(UIWebView*)theWebView didFailLoadWithError:(NSError*)error
{
    
     [indicator stopAnimating];
    if ([error code]==-1009) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

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

- (IBAction)toggleView:(id)sender {
    
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

@end
