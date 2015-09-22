//
//  TrainScheduleViewController.m
//  MastercardFinal
//
//  Created by administrator on 30/07/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "TrainScheduleViewController.h"
#import "TimeTableViewController.h"

@interface TrainScheduleViewController ()

@end

@implementation TrainScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)AddToFavoritesBtn:(id)sender {
    
    TimeTableViewController *object = [[TimeTableViewController alloc] init];
//    object.FavouriteLabel.hidden = FALSE;
    [self dismissViewControllerAnimated:object completion:nil];
}

- (IBAction)backBtnTap:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
