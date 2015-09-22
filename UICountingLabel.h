//
//  UICountingLabel:UICountingLabel.h
//  MastercardFinal
//
//  Created by administrator on 11/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#ifndef MastercardFinal_UICountingLabel_UICountingLabel_h
#define MastercardFinal_UICountingLabel_UICountingLabel_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UILabelCountingMethod) {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear
};

typedef NSString* (^UICountingLabelFormatBlock)(CGFloat value);
typedef NSAttributedString* (^UICountingLabelAttributedFormatBlock)(CGFloat value);

@interface UICountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, assign) UILabelCountingMethod method;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@property (nonatomic, copy) UICountingLabelFormatBlock formatBlock;
@property (nonatomic, copy) UICountingLabelAttributedFormatBlock attributedFormatBlock;
@property (nonatomic, copy) void (^completionBlock)();

-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue;
-(void)countFrom:(CGFloat)startValue to:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromCurrentValueTo:(CGFloat)endValue;
-(void)countFromCurrentValueTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

-(void)countFromZeroTo:(CGFloat)endValue;
-(void)countFromZeroTo:(CGFloat)endValue withDuration:(NSTimeInterval)duration;

- (CGFloat)currentValue;

@end

#endif
