//
//  FBCheckinController.m
//  MastercardFinal
//
//  Created by Brillio on 21/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "FBCheckinController.h"
#import "AppDelegate.h"


@interface FBCheckinController ()
{
    UIAlertView *messageAlert;
}
@end

@implementation FBCheckinController
@synthesize placeImageView,placeNameLabel,checkinText,loginButton,placesTableView,placeListView,placesData;
@synthesize placesSuperView,postImageUrl,postPlaceId,greyedView,activityBtn,infoBtn,checkinBtn,selectAPlaceBtn,tagWithFriends;
@synthesize sideBarViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.revealSidebarDelegate=self;
    self.loginButton.delegate=self;
    
    self.checkinText.delegate=self;
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    if ([FBSDKAccessToken currentAccessToken]) {
        [self afterLogoutSuccess];
        
    }else{
        
         [self.loginButton setHidden:NO];
        [self.tagWithFriends setHidden:YES];
        [self.selectAPlaceBtn setHidden:YES];
        [self.checkinBtn setHidden:YES];
        [self.checkinText setHidden:YES];
        [self.placeNameLabel setHidden:YES];
        [self.placeImageView setHidden:YES];
        [self.activityBtn setHidden:YES];
        [self.infoBtn setHidden:YES];
        
        
    }
   
}


-(void) afterLogoutSuccess{
    [self.loginButton setHidden:YES];
    [self.tagWithFriends setHidden:NO];
    [self.selectAPlaceBtn setHidden:NO];
    [self.checkinBtn setHidden:NO];
    [self.checkinText setHidden:NO];
    
    
    [self.placeNameLabel setHidden:NO];
    [self.placeImageView setHidden:NO];
    [self.activityBtn setHidden:NO];
    [self.infoBtn setHidden:NO];
    
    postPlaceId=@"42687942077";
    postImageUrl= @"https://maps.googleapis.com/maps/api/staticmap?center=40.714728,-73.998672&zoom=12&size=200x200&maptype=roadmap";
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:postImageUrl]];
    placeImageView.image = [UIImage imageWithData:imageData];
    
    self.activityBtn.backgroundColor=[UIColor whiteColor];
    self.infoBtn.backgroundColor=[UIColor lightGrayColor];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

- (IBAction)toggleView:(id)sender {
    
    [self toggleRevealState:JTRevealedStateLeft];
}

- (IBAction)cancelCheckIn:(id)sender {
    [self dismissViewControllerAnimated:YES  completion:nil];
}

- (IBAction)activityBtnClicked:(id)sender {
    
    self.activityBtn.backgroundColor=[UIColor whiteColor];
    self.infoBtn.backgroundColor=[UIColor lightGrayColor];
}

- (IBAction)infoBtnClicked:(id)sender{
    
    self.activityBtn.backgroundColor=[UIColor lightGrayColor];
    self.infoBtn.backgroundColor=[UIColor whiteColor];
}

-(IBAction)selectAPlaceClicked:(id)sender{

    double placeLatitude=40.714728;
    double placeLognitude=-73.998672;
    
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"search?q=restaurant&type=place&center=%f,%f&distance=500&limit=50&offset=0", placeLatitude, placeLognitude] parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     self.placesData = result[@"data"];
                     [self loadPlacesList];
                     
                     
                 }else{
                     NSLog(@"error: %@", [error localizedDescription]);
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert show];}
             }];
        }
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    
   

   }

-(void)loadPlacesList{
    self.greyedView=[[UIView alloc] initWithFrame:CGRectMake(0 , 0 , 415 , 800)];
    self.greyedView.backgroundColor=[[UIColor lightGrayColor] colorWithAlphaComponent:.5];
    self.placeListView=[[UIView alloc] initWithFrame:CGRectMake(50 , 150 , 320 , 300)];
    self.placeListView.backgroundColor=[UIColor redColor];
    
   placesTableView= [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 300.0) style:UITableViewStylePlain];
    
    placesTableView.rowHeight=44;
    placesTableView.sectionHeaderHeight=45;
    placesTableView.showsVerticalScrollIndicator = YES;
    placesTableView.userInteractionEnabled = YES;
  
    placesTableView.delegate=self;
    placesTableView.dataSource=self;
    
   [self.placeListView addSubview:placesTableView];
  [self.placesSuperView addSubview:greyedView];
    
  [self.placesSuperView addSubview:self.placeListView];
}


-(IBAction)checkInBtnClicked:(id)sender{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
            [[[FBSDKGraphRequest alloc]
              
              initWithGraphPath:@"me/photos"
              parameters: @{ @"message" : self.checkinText.text,
                             @"url": self.postImageUrl,
                             @"place":self.postPlaceId}
              HTTPMethod:@"POST"]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     messageAlert = [[UIAlertView alloc]
                                                  initWithTitle:@"" message:@"Posted successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     
                     
                     // Display Alert Message
                     [messageAlert show];
                    
                     
                     

                     
                 }else{
                     NSLog(@"error: %@", [error localizedDescription]);
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                     [alert show];
                 }
             }];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"You are not authorized to post on this page" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];

        }

        
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView==messageAlert)
    {
        if(buttonIndex == 0)
        {
            [self dismissViewControllerAnimated:YES completion:Nil];
        }
        
    }
    
    
}

- (UIView *)viewForLeftSidebar {
    CGRect viewFrame = self.applicationViewFrame;
    
    UITableViewController   *controller = self.sideBarViewController;
    if ( ! controller) {
        self.sideBarViewController = [[SidebarViewController alloc] init];
        self.sideBarViewController.sidebarDelegate = self;
        controller = self.sideBarViewController;
        
    }
    
    controller.view.frame = CGRectMake(0, viewFrame.origin.y, 270, viewFrame.size.height);
    controller.view.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleHeight;
    
    return controller.view;
}

- (void)sidebarViewController:(SidebarViewController *)sidebarViewController didSelectObject:(NSObject *)object atIndexPath:(NSIndexPath *)indexPath
{
    [self toggleRevealState:JTRevealedStateLeft];
}


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [FBSDKLoginButton class];
    
    return YES;
}


#pragma mark - Prepare For tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    //Region *place = [placesData objectAtIndex:section];
    return [placesData count];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    // The header for the section is the region name -- get this from the region at the section index.
    
    return @"Select A Place";
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *placesTableIdentifer = @"placesTableIdentifer";
    
    UITableViewCell *cell = [self.placesTableView dequeueReusableCellWithIdentifier:nil];
    
  
  if (cell == nil) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:placesTableIdentifer];
    }
    
    UIImageView *imgChopSticksOAP = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    
    imgChopSticksOAP.image = [UIImage imageNamed:@"restaurant_icon.png"];
    
    UILabel *placesLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 250, 30)];
    placesLabel.text=[[placesData objectAtIndex:indexPath.row] valueForKey:@"name"];
    
   
    [cell.contentView addSubview:imgChopSticksOAP];
    [cell.contentView addSubview:placesLabel];
    return cell;
}


- (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error{
    NSLog(@"error %@",error);
    if (!result.isCancelled) {
        if (!error) {
            [self afterLogoutSuccess];
        }
    }
    else
    {
        [self dismissViewControllerAnimated:YES  completion:nil];
    
    }
    
    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self updateCheckinPlaceData:indexPath.row];
    [self.placesTableView removeFromSuperview];
    [self.placeListView removeFromSuperview];
    [self.greyedView removeFromSuperview];
    
   
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    UITouch *touch = [touches anyObject];
    if(touch.view!=self.placeListView){
        [self.placesTableView removeFromSuperview];
        [self.placeListView removeFromSuperview];
        [self.greyedView removeFromSuperview];
    }
}


-(void) updateCheckinPlaceData:(NSInteger) index{
   // NSJson
    
     placeNameLabel.text=[[placesData objectAtIndex:index] valueForKey:@"name"];
     postPlaceId=[[placesData objectAtIndex:index] valueForKey:@"id"];
     NSDictionary *placeLocation=[[placesData objectAtIndex:index] valueForKey:@"location"];
    double placeLatitude=[[placeLocation valueForKey:@"latitude"] doubleValue];
    double placeLongitude=[[placeLocation valueForKey:@"longitude"] doubleValue];
    postImageUrl=[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/staticmap?center=%f,%f&zoom=12&size=200x200&maptype=roadmap", placeLatitude,placeLongitude];
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:postImageUrl]];
    placeImageView.image = [UIImage imageWithData:imageData];

}



- (IBAction)btnCancel:(id)sender {
}
@end
