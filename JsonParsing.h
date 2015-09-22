//
//  JsonParsing.h
//  socalMap
//
//  Created by matrix on 2/26/15.
//  Copyright (c) 2015 com.brillio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonParsing : NSObject
{
    NSDictionary *result,*demoResult;
    
    
    NSMutableArray *mapData;
}
-(NSDictionary *)simpleJsonParsing;
-(NSData *)json_ATM_Nearby_Data;
-(NSDictionary *)jsonParsingATMData;
-(NSData *)jsonData;
//-(NSData *)startDemo;

-(NSData *)json_Parking_Data;
- (NSDictionary *)jsonParsingStartDemo;

- (NSDictionary *)jsonParsingOfParkingData;

-(NSData *)json_OAP_Data;
- (NSDictionary *)jsonParsingOAPData;

-(NSData *)timeTableMapData;
- (NSDictionary *)jsonTimeTableMapData;

@end

