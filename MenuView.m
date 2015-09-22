//
//  MenuView.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/16/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "MenuView.h"
#import "TransitViewController.h"
#import "AppDelegate.h"
#import "Reachability.h"

@implementation MenuView {
    
    TransitViewController *object;
}

@synthesize reverseJrnBtn, saveJrnBtn,startDemoBtn,stopNavigBtn,savedPlacesJrnBtn,addPlaceBtn,shareJrnBtn,userinfo_dic,stopDemoBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
         AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        //object = [[TransitViewController alloc] init];
        
        reverseJrnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,5,150,30)];
        [reverseJrnBtn setTitle:@"Reverse Journey" forState:UIControlStateNormal];
        [reverseJrnBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [reverseJrnBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        if(networkStatus != NotReachable)
        {
      
        [reverseJrnBtn addTarget:self action:@selector(ReverseJrny) forControlEvents:UIControlEventTouchDown];
        
       
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please connect to internet to get location details" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            alert.delegate=self;
            
            [alert show];
        }
        saveJrnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,40,100,30)];
        [saveJrnBtn setTitle:@"Save Journey" forState:UIControlStateNormal];
        [saveJrnBtn addTarget:self action:@selector(SaveJourney) forControlEvents:UIControlEventTouchDown];
        [saveJrnBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [saveJrnBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        shareJrnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,75,100,30)];
        [shareJrnBtn setTitle:@"Share Journey" forState:UIControlStateNormal];
        [shareJrnBtn addTarget:self action:@selector(ShareJourney) forControlEvents:UIControlEventTouchDown];
        [shareJrnBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [shareJrnBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        
        savedPlacesJrnBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,110,100,30)];
        [savedPlacesJrnBtn setTitle:@"Saved Places" forState:UIControlStateNormal];
        [savedPlacesJrnBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [savedPlacesJrnBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        addPlaceBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,145,100,30)];
        [addPlaceBtn setTitle:@"Add Places" forState:UIControlStateNormal];
        [addPlaceBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [addPlaceBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        
        if(appDelegate.setnotice == NO)
        {
            startDemoBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,180,100,30)];
            [startDemoBtn setTitle:@"Start Demo" forState:UIControlStateNormal];
            [startDemoBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [startDemoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
             [startDemoBtn addTarget:self action:@selector(TravelNotice) forControlEvents:UIControlEventTouchDown];
            stopNavigBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,215,150,30)];
           
        }else
        {
            stopDemoBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,180,100,30)];
            [stopDemoBtn setTitle:@"Stop Demo" forState:UIControlStateNormal];
            [stopDemoBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [stopDemoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [stopDemoBtn addTarget:self action:@selector(StopDemo) forControlEvents:UIControlEventTouchDown];
            
            nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,215,100,30)];
            [nextBtn setTitle:@"Next" forState:UIControlStateNormal];
            [nextBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
            [nextBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
             [nextBtn addTarget:self action:@selector(FaceBookNotice) forControlEvents:UIControlEventTouchDown];
              stopNavigBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,250,150,30)];
            
        }
        
        [stopNavigBtn setTitle:@"Stop Navigation" forState:UIControlStateNormal];
        [stopNavigBtn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [stopNavigBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [stopNavigBtn addTarget:self action:@selector(stopNavigation) forControlEvents:UIControlEventTouchDown];

    //Below code for checking the business persona
            
       /*  userinfo_dic= [NSDictionary dictionary];
        userinfo_dic=[appDelegate UserinfoplistContent];
        NSString *visiting_NY=[userinfo_dic objectForKey:@"visitInNY"];
        NSString *business_NY=[userinfo_dic objectForKey:@"visitInNY"];
        if([visiting_NY isEqualToString:@"1"])
        {
            if([business_NY isEqualToString:@"1"])
              
            
       }*/
        //else
//        {
//            [startDemoBtn addTarget:self action:@selector(startDemo) forControlEvents:UIControlEventTouchDown];
//        }
            
        
        
        [self addSubview:reverseJrnBtn];
        [self addSubview:saveJrnBtn];
        [self addSubview:shareJrnBtn];
        [self addSubview:savedPlacesJrnBtn];
        [self addSubview:addPlaceBtn];
        [self addSubview:startDemoBtn];
        [self addSubview:stopNavigBtn];
        if(appDelegate.setnotice == YES)
        {
             [self addSubview: nextBtn];
            [self addSubview:stopDemoBtn];
        }
        
       // object = [[TransitViewController alloc] init];
     
        object= (TransitViewController*)appDelegate.window.rootViewController;

    }
    
    return self;
}
-(void)SaveJourney {
    [self removeFromSuperview];
    [object saveMap];
}

-(void) ShareJourney {
    [self removeFromSuperview];
    [object shareMap];
}

-(void) ReverseJrny {
    [self removeFromSuperview];
    [object ReverseJrny];
    
}
-(void)StopDemo
{
     [self removeFromSuperview];
    AppDelegate *appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.setnotice = NO;
    appDelegate.noticeRepeat = YES;
    
}

-(void)FaceBookNotice
{
    [self removeFromSuperview];

    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    if(appdelegate.count ==0)
    {
    appdelegate.count=1;

    [object FaceBookNotice];
        
    }
    
    else if(appdelegate.count==1)
    {
        appdelegate.count =2;
        [object carRentalNotice];
        
        
    }
    else if(appdelegate.count==2)
    {
        if(appdelegate.rentcar_cab == NO)
        {
            if (![appdelegate.destination1 isEqualToString:@""]) {
                appdelegate.count =3;
                [object MeetingNotice];
            }else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please choose origin and destination" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }

//            appdelegate.count =3;
//            [object MeetingNotice];
        }else
        {
         appdelegate.count =3;
         [object parkViewNotice];
        }
        
        
    }
    else if(appdelegate.count==3)
    {
        if(appdelegate.rentcar_cab == NO)
        {
            appdelegate.count =4;
            [object Ordernow];
        }else
        {
            //appdelegate.count =4;
            [object pricelessOfferView];
        }
        
        
    }else if(appdelegate.count==4)
    {
        if(appdelegate.rentcar_cab == NO)
        {
            //appdelegate.count =5;
            [object shareJourney];
        }
    }
}

-(void)TravelNotice
{
    AppDelegate *appdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    appdelegate.count=0;
   [self removeFromSuperview];
     
    [object TravelNotice];
}
-(void)startDemo
{
     [self removeFromSuperview];
     [object startDemo];
}
//Alert for TravelNotice [visiting newyork && business traveller is choosed]
-(void)stopNavigation
{
    [object reloadTransitPage];
}
@end
