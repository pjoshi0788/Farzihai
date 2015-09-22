//
//  StepTableViewCell.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/15/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *transitType;
@property (weak, nonatomic) IBOutlet UILabel *departTime;
@property (weak, nonatomic) IBOutlet UIImageView *stepRouteImage;

@property (weak, nonatomic) IBOutlet UILabel *stepLineName;

@property (weak, nonatomic) IBOutlet UILabel *stepInstruction;
@property (weak, nonatomic) IBOutlet UILabel *stepArrivalStop;
@property (weak, nonatomic) IBOutlet UILabel *stepDepStop;


@property (weak, nonatomic) IBOutlet UILabel *stepDistance;
@end
