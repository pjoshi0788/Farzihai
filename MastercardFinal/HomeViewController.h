//
//  HomeViewController.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 6/4/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController
{
    
    NSString *alertText;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *greetingLogo;
@property (weak, nonatomic) IBOutlet UILabel *factLabel;
@property (weak, nonatomic) IBOutlet UIButton *LetsGo;

@end

