//
//  HeadView.h
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeadViewDelegate; 

@interface HeadView : UIView{
       NSInteger section;
    UIImageView *logoImgView;
    UIButton* backBtn;
    UIImageView *dropDwnImgView;
    BOOL open;
}
@property(nonatomic, assign) id<HeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;
@property(nonatomic, retain) UIImageView* logoImgView;
@property(nonatomic, retain) UIImageView* dropDwnImgView;
@end

@protocol HeadViewDelegate <NSObject>
-(void)selectedWith:(HeadView *)view;
@end
