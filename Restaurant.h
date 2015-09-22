//
//  Restaurant.h
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/21/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *lat;
@property(nonatomic,copy) NSString *lon;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *iconUrl;

@end
