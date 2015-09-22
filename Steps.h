//
//  Steps.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/10/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransitDetail.h"

typedef enum {
    walking,
    transit,
    train,
    bus
} TravelMode;

@interface Steps : NSObject<NSCopying>

@property(nonatomic,assign) TravelMode tm;
@property(nonatomic,copy) NSString *distance;
@property(nonatomic,copy) NSString *duration;
@property(nonatomic,copy) TransitDetail *transtDtls;
@property(nonatomic,copy) Steps *subStep;
@property(nonatomic,copy) NSString *depTime;
@property(nonatomic,copy) NSString *arrTime;
@property(nonatomic,copy) NSString *instruction;
@property(nonatomic,copy) NSMutableArray *step_arr;

-(id)copyWithZone:(NSZone *)zone;
@end
