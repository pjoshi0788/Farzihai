//
//  Route.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/10/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Route : NSObject

@property(nonatomic,assign) NSInteger num_of_steps;
@property(nonatomic,copy) NSMutableArray *step_arr;
@property(nonatomic,copy) NSString *arrival_time;
@property(nonatomic,copy) NSString *dep_time;
@property(nonatomic,copy) NSString *distance;
@property(nonatomic,copy) NSString *routeDuration;
@property(nonatomic,copy) NSString *startAddress;
@property(nonatomic,copy) NSString *endAddress;
@property(nonatomic,copy) NSString *points;
@property(nonatomic,copy) NSString *startLat;
@property(nonatomic,copy) NSString *startLon;
@property(nonatomic,copy) NSString *endLat;
@property(nonatomic,copy) NSString *endLon;
@property(nonatomic,copy) NSString *short_Name;
@end
