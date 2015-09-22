//
//  StepTableViewCell.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/15/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "StepTableViewCell.h"

@implementation StepTableViewCell
@synthesize departTime,stepRouteImage,stepInstruction,stepDistance,transitType,stepArrivalStop,stepDepStop,stepLineName;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    float indentPoints = self.indentationLevel * self.indentationWidth;
//    
//    self.frame = CGRectMake(
//                                        50,
//                                        self.frame.origin.y,
//                                        self.frame.size.width - indentPoints,
//                                        self.frame.size.height
//                                        );
//}

@end
