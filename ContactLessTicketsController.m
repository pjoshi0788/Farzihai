//
//  ContactLessTicketsController.m
//  MastercardFinal
//
//  Created by administrator on 07/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#define DeviceWidth self.view.bounds.size.width
#define DeviceHeight self.view.bounds.size.height

#import "ContactLessTicketsController.h"
#import "constant.h"

@interface ContactLessTicketsController ()

@end

@implementation ContactLessTicketsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgoundImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, DeviceHeight)];
    backgoundImage.image = [UIImage imageNamed:@"bg.png"];
    [self.view addSubview:backgoundImage];
    
    UIView *topTitleHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceWidth, 55)];
    topTitleHeader.backgroundColor = [UIColor blackColor];
    [self.view addSubview:topTitleHeader];

    UIButton *sideBarViewButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 22, 28, 28)];
    //sideBarViewButton.=@"Back";
    //[sideBarViewButton setTitle:@"Back" forState:UIControlStateNormal];
    [sideBarViewButton setImage:[UIImage imageNamed:@"back_arrow.png"] forState:UIControlStateNormal];
    //[sideBarViewButton addTarget:self action:@selector(SideBarViewButtonAction) forControlEvents:UIControlEventTouchDown];
    [sideBarViewButton addTarget:self action:@selector(backViewButtonAction) forControlEvents:UIControlEventTouchDown];
    [topTitleHeader addSubview:sideBarViewButton];
    
    UILabel *Title = [[UILabel alloc] initWithFrame:CGRectMake(50, 24, DeviceWidth - 55, 25)];
    Title.text = @"Contactless Tickets";
    Title.textColor = [UIColor whiteColor];
    [Title setFont:[UIFont  fontWithName:@"HelveticaNeue-Bold" size:18]];
    [topTitleHeader addSubview:Title];
    
    UIImageView *TrainImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"train.png"]];
    TrainImage.frame = CGRectMake(30, 75, 25, 35);
    [self.view addSubview:TrainImage];
    
    UILabel *LongIslandLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 70, DeviceWidth - 80, 30)];
    LongIslandLabel.text = _TicketName;
    [self.view addSubview:LongIslandLabel];
    [LongIslandLabel setFont:[UIFont  fontWithName:@"Helvetica Neue" size:16]];
    LongIslandLabel.backgroundColor = [UIColor clearColor];
    LongIslandLabel.textColor = [UIColor whiteColor];
    
    UILabel *MonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 100, DeviceWidth - 80, 30)];
    MonthLabel.text = @"MONTHLY: JUNE";
    [self.view addSubview:MonthLabel];
    [MonthLabel setFont:[UIFont  fontWithName:@"Helvetica Neue" size:12]];
    MonthLabel.backgroundColor = [UIColor clearColor];
    MonthLabel.textColor = [UIColor whiteColor];
    
    UIImageView *fromDateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blue-bg.png"]];
    fromDateImage.frame = CGRectMake(65, 145, 33, 33);
    [self.view addSubview:fromDateImage];
    
    UILabel *fromDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    fromDate.text = @"7";
    fromDate.textAlignment = NSTextAlignmentCenter;
    fromDate.backgroundColor = [UIColor clearColor];
    fromDate.textColor = [UIColor whiteColor];
    [fromDate setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [fromDateImage addSubview:fromDate];
    
    UILabel *FromLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 140, 80, 25)];
    FromLabel.text = @"From";
    FromLabel.textColor = [UIColor whiteColor];
    [FromLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [self.view addSubview:FromLabel];
    
    UILabel *FromStationName = [[UILabel alloc] initWithFrame:CGRectMake(110, 160, 150, 25)];
    FromStationName.text = _OriginStationName;
    FromStationName.textColor = [UIColor whiteColor];
    [FromStationName setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [self.view addSubview:FromStationName];
    

    UIImageView *ToDateImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"green-bg.png"]];
    ToDateImage.frame = CGRectMake(65, 200, 33, 33);
    [self.view addSubview:ToDateImage];
    
    UILabel *ToDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    ToDate.text = @"1";
    ToDate.textColor = [UIColor whiteColor];
    ToDate.textAlignment = NSTextAlignmentCenter;
    ToDate.backgroundColor = [UIColor clearColor];
    [ToDate setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [ToDateImage addSubview:ToDate];
    
    UILabel *ToLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 195, 160, 25)];
    ToLabel.text = @"To";
    ToLabel.textColor = [UIColor whiteColor];
    [ToLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [self.view addSubview:ToLabel];

    UILabel *ToStationName = [[UILabel alloc] initWithFrame:CGRectMake(110, 215, 80, 30)];
    ToStationName.text = _DestinationStationName;
    ToStationName.textColor = [UIColor whiteColor];
    [ToStationName setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [self.view addSubview:ToStationName];
    
    UIImageView *QRCodeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"qr-code.png"]];
    QRCodeImage.frame = CGRectMake(50, 280, DeviceWidth - 100, 200);
    QRCodeImage.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:QRCodeImage];
    
    UILabel *ExpiryLabel = [[UILabel alloc] initWithFrame:CGRectMake(65,520, 60, 25)];
    ExpiryLabel.text = @"Expires";
    ExpiryLabel.textAlignment = NSTextAlignmentLeft;
    [ExpiryLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    ExpiryLabel.textColor = [UIColor whiteColor];
    ExpiryLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:ExpiryLabel];
    
    UILabel *expiryDatelabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 540, 160, 25)];
    expiryDatelabel.text = @"Tue, Aug 25";
    expiryDatelabel.textColor = [UIColor whiteColor];
    expiryDatelabel.textAlignment = NSTextAlignmentLeft;
    [expiryDatelabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [self.view addSubview:expiryDatelabel];
    
    UILabel *PaymentLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth-130, 520, 60, 25)];
    PaymentLabel.text  = @"Payment";
    PaymentLabel.textAlignment = NSTextAlignmentRight;
    PaymentLabel.textColor = [UIColor whiteColor];
    [PaymentLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14]];
    [self.view addSubview:PaymentLabel];
    
    UILabel *PaymentCostLabel = [[UILabel alloc] initWithFrame:CGRectMake(DeviceWidth-130, 540, 60, 25)];
    PaymentCostLabel.text  = @"$287.00";
    PaymentCostLabel.textColor = [UIColor whiteColor];
    PaymentCostLabel.textAlignment = NSTextAlignmentRight;
    [PaymentCostLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:12]];
    [self.view addSubview:PaymentCostLabel];
    
    self.navigationItem.revealSidebarDelegate=self;
}

-(void) backViewButtonAction{
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) SideBarViewButtonAction {
 
    [self toggleRevealState:JTRevealedStateLeft];
}

#pragma mark JTRevealSidebarDelegate
// This is an example to configure your sidebar view without a UIViewController
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
