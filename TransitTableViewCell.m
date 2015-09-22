//
//  TransitTableViewCell.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/13/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "TransitTableViewCell.h"

@implementation TransitTableViewCell
@synthesize durationLbl,routeInfoLbl,startEndTimeLabel, numOfSteps;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
