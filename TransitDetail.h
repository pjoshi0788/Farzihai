//
//  TransitDetail.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/10/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitDetail : NSObject<NSCopying>

@property(nonatomic,copy) NSString *arrStopName;
@property(nonatomic,copy) NSString *arrTime;
@property(nonatomic,copy) NSString *depStopName;
@property(nonatomic,copy) NSString *depTime;
@property(nonatomic,copy) NSString *numStop;
@property(nonatomic,copy) NSString *lineName;
@property(nonatomic,copy) NSString *lineAgencyName;
@property(nonatomic,copy) NSString *headSign;
@property(nonatomic,copy) NSString *vehicleType;
@property(nonatomic,copy) NSString *vehicleName;
@property(nonatomic,copy) NSString *short_name;

@end