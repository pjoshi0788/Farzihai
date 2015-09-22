//
//  JsonParsing.m
//  socalMap
//
//  Created by matrix on 2/26/15.
//  Copyright (c) 2015 com.brillio. All rights reserved.
//

#import "JsonParsing.h"
#import "constant.h"
#import "AppDelegate.h"
#define kNearbyURL @"https://maps.googleapis.com/maps/api/place/search/json?"
#define kDirectionsURL @"https://maps.googleapis.com/maps/api/directions/json?"



#define kLatNearBy @"12.9075661"
#define kLongNearBy @"77.5993041"

#define kATM_URL @"https://bcmapi.herokuapp.com/getAtmsExtra?po=0&pl=25&radius=10"
@implementation JsonParsing
{
    NSDictionary *jsonDiction;
    double searchLatitude;
    double searchLongtitude;
    double addressMap;
    NSMutableArray *filteredResult;
    NSMutableDictionary *addressDictionary;
    NSString *addValue,*latvalue,*longvalue,*locName;
    
}

//************************************** Fetching data from URL And Parsing ***********************************//
-(NSData *)jsonData
{
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
  
    NSString *jsonUrlString;
    if([appDelegate.transitMode isEqualToString:@"train"])
    {
    jsonUrlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@&alternatives=%@&mode=transit&transit_mode=%@&key=AIzaSyDu42jY1Nx1ybeFx8Wbct6Dj3g16JEkXBQ", kDirectionsURL, appDelegate.origin1,appDelegate.destination1,@"true",appDelegate.transitMode];
    }
    else
    {
       jsonUrlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@&alternatives=%@&transit_mode=%@&key=AIzaSyDu42jY1Nx1ybeFx8Wbct6Dj3g16JEkXBQ", kDirectionsURL, appDelegate.origin1,appDelegate.destination1,@"true",appDelegate.transitMode];
    }
      
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return responseData;
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

//************************************** Data return ***********************************//

- (NSDictionary *)simpleJsonParsing
{
    result = [NSJSONSerialization JSONObjectWithData: [self jsonData] options:NSJSONReadingMutableContainers  error:nil];
    
    jsonDiction =[(NSDictionary *)result objectForKey:@"routes"];
    mapData =[[NSMutableArray alloc] init];
    addressDictionary =[[NSMutableDictionary alloc]init];
    
    return result;
    
    
}

-(NSData *)json_ATM_Nearby_Data
{
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
   
    //  NSString *jsonUrlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=%@&alternatives=%@", kDirectionsURL, @"Hamster Breeding, 619 Seaman Avenue, Baldwin, NY 11510, United States", @"Westbury, NY, USA", sensor,@"true"];
    
    // NSString *jsonUrlString = [NSString stringWithFormat:@"%@origin=%@&destination=%@&sensor=%@&alternatives=%@", kDirectionsURL, @"Hamster Breeding, 619 Seaman Avenue, Baldwin, NY 11510, United States", @"Westbury, NY, USA", sensor,@"true"];
    
    
   // NSString *jsonUrlString = kATM_URL;
   

    
    NSString *jsonUrlString = [NSString stringWithFormat:@"%@&lat=%f&lon=%f",kATM_URL,appDelegate.currLat,appDelegate.currLong];
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return responseData;
    
}



//************************************** Data return ***********************************//

- (NSDictionary *)jsonParsingATMData
{
    if ([self json_ATM_Nearby_Data]) {
        result = [NSJSONSerialization JSONObjectWithData: [self json_ATM_Nearby_Data] options:NSJSONReadingMutableContainers  error:nil];
        
        jsonDiction =[(NSDictionary *)result objectForKey:@"Atms"];
        //            jsonDiction =[[NSDictionary alloc]initWithDictionary:result];
        mapData =[[NSMutableArray alloc] init];
        addressDictionary =[[NSMutableDictionary alloc]init];
    }
    return result;
    
    
}
-(NSData *)json_OAP_Data
{
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    
    AppDelegate *appDelegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
    
    NSString *jsonUrlString =[NSString stringWithFormat:@"%@location=%f,%f&radius=500&types=restaurant&key=AIzaSyC94RNMXsCTyuLwBImd-1IUHPUVf657WA4",kNearbyURL,appDelegate.currLat,appDelegate.currLong ];
    
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    

    return responseData;
    
}



//************************************** Data return ***********************************//

- (NSDictionary *)jsonParsingOAPData
{
    if ([self json_OAP_Data]) {
        result = [NSJSONSerialization JSONObjectWithData: [self json_OAP_Data] options:NSJSONReadingMutableContainers  error:nil];
        
        jsonDiction =[(NSDictionary *)result objectForKey:@"results"];
        mapData =[[NSMutableArray alloc] init];
        addressDictionary =[[NSMutableDictionary alloc]init];
        
   
    }
    return result;
    
    
}
-(NSData *)json_Parking_Data
{
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //NSString *jsonUrlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=12.9075661,77.5993041&rankby=distance&types=parking&key=AIzaSyDu42jY1Nx1ybeFx8Wbct6Dj3g16JEkXBQ"];
    
   NSString *jsonUrlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=%f,%f&rankby=distance&types=parking&key=AIzaSyDu42jY1Nx1ybeFx8Wbct6Dj3g16JEkXBQ",appDelegate.currLat,appDelegate.currLong];
    
    NSLog(@"encoded url %@",jsonUrlString);
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return responseData;
    
}
//************************************** Data return ***********************************//

- (NSDictionary *)jsonParsingOfParkingData
{
    if ([self json_Parking_Data]) {
        result = [NSJSONSerialization JSONObjectWithData: [self json_Parking_Data] options:NSJSONReadingMutableContainers  error:nil];
        
        jsonDiction =[(NSDictionary *)result objectForKey:@"results"];
        //            jsonDiction =[[NSDictionary alloc]initWithDictionary:result];
        mapData =[[NSMutableArray alloc] init];
        addressDictionary =[[NSMutableDictionary alloc]init];
        
        //return result;
    }
    
    return result;
    
}

-(NSData *)timeTableMapData
{
    //-- Make URL request with server
    NSHTTPURLResponse *response = nil;
//    AppDelegate *appDelegate= (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    //NSString *jsonUrlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?&location=12.9075661,77.5993041&rankby=distance&types=parking&key=AIzaSyDu42jY1Nx1ybeFx8Wbct6Dj3g16JEkXBQ"];
    
    NSString *jsonUrlString =[NSString stringWithFormat:@"%@origin=%@&destination=%@&alternatives=%@&key=AIzaSyDu42jY1Nx1ybeFx8Wbct6Dj3g16JEkXBQ", kDirectionsURL,@"Pennsylvania Station, New York, NY, United States",@"Hicksville, United States",@"true"];
    
    NSLog(@"encoded url %@",jsonUrlString);
    
    NSURL *url = [NSURL URLWithString:[jsonUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
    //-- Get request and response though URL
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    return responseData;
    
}
//************************************** Data return ***********************************//

- (NSDictionary *)jsonTimeTableMapData
{
    if ([self timeTableMapData]) {
        result = [NSJSONSerialization JSONObjectWithData: [self timeTableMapData] options:NSJSONReadingMutableContainers  error:nil];
        
        jsonDiction =[(NSDictionary *)result objectForKey:@"results"];
        //            jsonDiction =[[NSDictionary alloc]initWithDictionary:result];
        mapData =[[NSMutableArray alloc] init];
        addressDictionary =[[NSMutableDictionary alloc]init];
        
        //return result;
    }
    
    return result;
    
}



@end
