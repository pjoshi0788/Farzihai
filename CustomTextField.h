//
//  CustomTextField.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/9/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomTextFieldDelegate <NSObject>

@optional
- (BOOL)CustomTextFieldShouldReturn:(UITextField *)theTextField;

@end

@interface CustomTextField : UITextField
- (void) drawPlaceholderInRect:(CGRect)rect;
@end


