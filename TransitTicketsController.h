//
//  TransitTicketsController.h
//  MastercardFinal
//
//  Created by Brillio on 04/08/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactLessTicketsController.h"
#import "AppDelegate.h"

@interface TransitTicketsController : UIViewController<UITableViewDelegate,UITableViewDataSource>
- (IBAction)backBtnTap:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *TransitTicketsTableView;
@property (nonatomic, assign) BOOL isFare;
@end
