//
//  Steps.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/10/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "Steps.h"

@implementation Steps


-(id)copyWithZone:(NSZone *)zone
{
    Steps* st = [[Steps allocWithZone:zone]init];
    st->_arrTime = [_arrTime copy];
    st->_depTime = [_depTime copy];
    st->_distance = [_distance copy];
    st->_duration = [_duration copy];
    st->_instruction = [_instruction copy];
    st->_subStep = [_subStep copy];
    st->_transtDtls = [_transtDtls copy];
    
    
    return st;
}
@end
