//
//  CustomTextField.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/9/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField
- (void) drawPlaceholderInRect:(CGRect)rect {
    UIColor *colour = [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:16];
    
    NSDictionary *attributes = @{NSForegroundColorAttributeName: colour, NSFontAttributeName:font};
    
    
    [self.placeholder drawInRect:rect withAttributes:attributes];
}
@end
