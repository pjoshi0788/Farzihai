//
//  HeadView.m
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn, logoImgView,dropDwnImgView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(55, 0, 250, 40);
        
        [btn.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:14]];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];

        
        logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15,10, 22, 22)];
        logoImgView.contentMode = UIViewContentModeScaleAspectFit;
        dropDwnImgView = [[UIImageView alloc] initWithFrame:CGRectMake(250,18, 13, 8)];
        //logoImgView.image = [UIImage imageNamed:@"mclogo.png"];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_on"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        [self addSubview:logoImgView];
        [self addSubview:dropDwnImgView];
        //Section separator
        
        UIView *lineView;
        lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39, 265, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:70.0/255.0 green:70.0/255.0 blue:70.0/255.0 alpha:1.0];

        [self addSubview:lineView];
        self.backBtn = btn;

    }
    return self;
}

-(void)doSelected{
    //    [self setImage];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
     	[_delegate selectedWith:self];
    }
}
@end
