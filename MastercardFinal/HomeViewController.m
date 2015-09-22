//
//  HomeViewController.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/4/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "TransitViewController.h"
#import "SurpriseViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize homeImage, logoImage, greetingLogo, factLabel;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"alertText"];
    
    if(testValue !=nil)
    {
        alertText = [[NSUserDefaults standardUserDefaults] valueForKey:@"alertText"];
    }
    
    [self setHomeView];
   
    
}
- (IBAction)Pricelesscities:(UIButton *)sender
{
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if(appDelegate.NetworkStatus == YES)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        
        SurpriseViewController *transitCtrl = [storyboard instantiateViewControllerWithIdentifier:@"SurpriseViewController"];
        [self presentViewController:transitCtrl animated:YES completion:nil];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }

    
}
- (IBAction)LetsGo:(id)sender {
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;

    if(appDelegate.NetworkStatus == YES)
    {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle:nil];
        
        TransitViewController *transitCtrl = [storyboard instantiateViewControllerWithIdentifier:@"transitViewController"];
        [self presentViewController:transitCtrl animated:YES completion:nil];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"The Internet connection appears to be offline" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    
    NSInteger hour = [components hour];
    
    if(hour<16 && hour > 5)
        homeImage.image = [UIImage imageNamed:@"nyDay.jpg"];
    else
        homeImage.image = [UIImage imageNamed:@"nyNight.jpg"];
    
    
    
    int lowerBound = 1;
    int upperBound = 11;
    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    NSString *localString = [NSString stringWithFormat:@"FunFact%d",rndValue];
    
    factLabel.text = NSLocalizedString(localString, nil);
}

-(void) setHomeView
{
    NSString *greetStr = [self getGreetingString];
    homeImage.image = [UIImage imageNamed:NSLocalizedString( @"backgroundImage", nil)];
    // logoImage.image = [UIImage imageNamed:NSLocalizedString( @"homeMtaLogo", nil)];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    NSDictionary *userinfo_dic= [NSDictionary dictionary];
    userinfo_dic = [appDelegate UserinfoplistContent:NO];
    NSString *name=[userinfo_dic objectForKey:@"name"];
        
    NSString *greetingStr;
    if (name.length != 0) {
        greetingStr = [NSString stringWithFormat:@"%@ %@%@",greetStr,name,@"!"];
    }else {
        greetingStr = [NSString stringWithFormat:@"%@ %@",greetStr,@"!"];
    }

    
    greetingLogo.text = greetingStr;
    greetingLogo.numberOfLines=2;
    [greetingLogo setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    [greetingLogo setTextColor:[UIColor whiteColor]];
    
    [factLabel setText:alertText];
    [factLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:19]];
    [factLabel setTextColor:[UIColor whiteColor]];
    
}

-(NSString*) getGreetingString
{
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:[NSDate date]];
    
    NSInteger hour = [components hour];
    
    
    if(hour > 4 && hour < 12)
        return @"Good Morning";
    else if(hour >=12 && hour <17)
        return @"Good Afternoon";
    else if(hour >=17 && hour < 22)
        return @"Good Evening";
    
    return @"Good Evening";
}
@end
