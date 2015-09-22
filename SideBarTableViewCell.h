//
//  SideBarTableViewCell.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/12/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *menuTypeImg;
@property (weak, nonatomic) IBOutlet UIButton *menuLabelBtn;
@property (weak, nonatomic) IBOutlet UIImageView *menuDropDownImg;

@end
