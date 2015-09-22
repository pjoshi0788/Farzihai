//
//  MenuView.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/16/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface MenuView : UIView
{
    UIButton *reverseJrnBtn;
    UIButton *saveJrnBtn;
    UIButton *shareJrnBtn;
    UIButton *savedPlacesJrnBtn;
    UIButton *addPlaceBtn;
    UIButton *startDemoBtn;
    UIButton *stopDemoBtn;
    UIButton *stopNavigBtn;
    UIButton *nextBtn;
    int count;
}
@property(nonatomic,retain) UIButton *reverseJrnBtn;
@property(nonatomic,retain) UIButton *saveJrnBtn;
@property(nonatomic,retain) UIButton *shareJrnBtn;
@property(nonatomic,retain) UIButton *savedPlacesJrnBtn;
@property(nonatomic,retain) UIButton *addPlaceBtn;
@property(nonatomic,retain) UIButton *startDemoBtn;
@property(nonatomic,retain) UIButton *stopDemoBtn;
@property(nonatomic,retain) UIButton *stopNavigBtn;
//@property(nonatomic,retain) UIButton *nextBtn;
@property(nonatomic,retain) NSDictionary *userinfo_dic;
-(void)TravelNotice;
-(void)stopNavigation;
@end
