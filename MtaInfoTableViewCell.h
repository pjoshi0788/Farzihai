//
//  MtaInfoTableViewCell.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/23/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MtaInfoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mtaType;
@property (weak, nonatomic) IBOutlet UILabel *mtaName;
@property (weak, nonatomic) IBOutlet UILabel *mtaStatus;

@end
