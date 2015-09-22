//
//  TransitTableViewCell.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/13/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *routeInfoLbl;
@property (weak, nonatomic) IBOutlet UILabel *startEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numOfSteps;

@end
