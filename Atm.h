//
//  Atm.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/21/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Atm : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *distance;
@property(nonatomic,copy) NSString *addressLine1;
@property(nonatomic,copy) NSString *addressLine2;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *country;
@property(nonatomic,copy) NSString *postalCode;
@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *lon;
@end
