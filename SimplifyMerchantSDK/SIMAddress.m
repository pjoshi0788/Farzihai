#import "SIMAddress.h"

@interface SIMAddress()

@property (nonatomic, readwrite) NSString *name;
@property (nonatomic, readwrite) NSString *addressLine1;
@property (nonatomic, readwrite) NSString *addressLine2;
@property (nonatomic, readwrite) NSString *city;
@property (nonatomic, readwrite) NSString *state;
@property (nonatomic, readwrite) NSString *zip;
@property (nonatomic, readwrite) NSString *country;

@end

@implementation SIMAddress

-(instancetype)initWithName:(NSString *)name addressLine1:(NSString *)addressLine1 addressLine2:(NSString *)addressLine2 city:(NSString *)city state:(NSString *)state zip:(NSString *)zip {
    
    return [self initWithName:name addressLine1:addressLine1 addressLine2:addressLine2 city:city state:state country:@"US" zip:zip];
}

-(instancetype)initWithName:(NSString *)name addressLine1:(NSString *)addressLine1 addressLine2:(NSString *)addressLine2 city:(NSString *)city state:(NSString *)state country:(NSString *)country zip:(NSString *)zip {
    self = [super init];
	if (self) {
		self.name = name ? name : @"";
		self.addressLine1 = addressLine1 ? addressLine1 : @"";
		self.addressLine2 = addressLine2 ? addressLine2 : @"";
		self.city = city ? city : @"";
		self.state = state ? state : @"";
		self.zip = zip ? zip : @"";
        self.country = country ? country : @"";
	}
	return self;
}

@end
