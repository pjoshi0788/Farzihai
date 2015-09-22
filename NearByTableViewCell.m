//
//  NearByTableViewCell.m
//  MastercardFinal
//
//  Created by Prateek on 7/7/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "NearByTableViewCell.h"

@implementation NearByTableViewCell
@synthesize nameLabel,mainLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        reuseID = reuseIdentifier;
        
      nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        [nameLabel setText:@"name"];
        
        [nameLabel setTextColor:[UIColor blackColor]];
        [nameLabel setBackgroundColor:[UIColor colorWithHue:32 saturation:100 brightness:63 alpha:1]];
        [nameLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView addSubview:nameLabel];
        
        mainLabel = [[UILabel alloc] init];
        [mainLabel setTextColor:[UIColor blackColor]];
        [mainLabel setBackgroundColor:[UIColor colorWithHue:66 saturation:100 brightness:63 alpha:1]];
        [mainLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:18.0f]];
        [mainLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:mainLabel];
        
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    }
    return self;
}


@end
