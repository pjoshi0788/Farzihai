//
//  TransitDetail.m
//  MastercardFinal
//
//  Created by Brillio Mac Mini 8 on 7/10/15.
//  Copyright (c) 2015 Brillio. All rights reserved.
//

#import "TransitDetail.h"

@implementation TransitDetail

-(id)copyWithZone:(NSZone *)zone
{
    TransitDetail* td = [[TransitDetail allocWithZone:zone]init];
    td->_arrStopName = [_arrStopName copy];
    td->_arrTime = [_arrTime copy];
    td->_depStopName = [_depStopName copy];
    td->_depTime = [_depTime copy];
    td->_numStop = [_numStop copy];
    td->_lineName = [_lineName copy];
    td->_lineAgencyName = [_lineAgencyName copy];
    td->_headSign = [_headSign copy];
    td->_vehicleType = [_vehicleType copy];
    td->_vehicleName = [_vehicleName copy];
    td->_short_name=[_short_name copy];
    
    return td;
}
@end