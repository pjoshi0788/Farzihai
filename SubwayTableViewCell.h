//
//  SubwayTableViewCell.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/23/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubwayTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageType;
@property (weak, nonatomic) IBOutlet UIImageView *imageName1;
@property (weak, nonatomic) IBOutlet UIImageView *imageName2;
@property (weak, nonatomic) IBOutlet UIImageView *imageName3;
@property (weak, nonatomic) IBOutlet UIImageView *imageName4;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;

@end
