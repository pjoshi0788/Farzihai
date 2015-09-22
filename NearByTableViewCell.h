//
//  NearByTableViewCell.h
//  MastercardFinal
//
//  Created by Prateek on 7/7/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NearByTableViewCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate>
{
NSString *reuseID;
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *mainLabel;

@end
