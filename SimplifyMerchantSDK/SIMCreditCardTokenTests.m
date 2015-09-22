#import "SIMCreditCardToken.h"

@interface SIMCardTokenTests : XCTestCase
@property (nonatomic, strong) SIMCreditCardToken *testSubject;
@end

@implementation SIMCardTokenTests

-(void)testThatSimCardTokenCanBeCreated {
    
    id mockAddress = [OCMockObject niceMockForClass:SIMAddress.class];
    
    NSString *token = @"123456";
    NSString *tokenId = @"tokenId";
    NSString *tokenName = @"tokenName";
    NSString *tokenType = @"tokenType";
    NSNumber *last4Digits = @1234;
    NSNumber *expirationMonth = @11;
    NSNumber *expirationYear = @15;
    NSDate *tokenDate = [NSDate date];
    
    self.testSubject = [[SIMCreditCardToken alloc] initWithToken:token tokenId:tokenId name:tokenName type:tokenType last4:last4Digits address:mockAddress expMonth:expirationMonth expYear:expirationYear dateCreated:tokenDate];

    XCTAssertTrue([self.testSubject.token isEqualToString:token], @"");
    XCTAssertTrue([self.testSubject.tokenId isEqualToString:tokenId], @"");
    XCTAssertTrue([self.testSubject.name isEqualToString:tokenName], @"");
    XCTAssertTrue([self.testSubject.type isEqualToString:tokenType], @"");
    XCTAssertTrue([self.testSubject.expMonth isEqual:expirationMonth], @"");
    XCTAssertTrue([self.testSubject.expYear isEqual:expirationYear], @"");
    
}

-(void)testThatSimCardTokenCanBeCreatedWithNilValuesReturnsNilSafeValues {
    
    self.testSubject = [[SIMCreditCardToken alloc] initWithToken:nil tokenId:nil name:nil type:nil last4:nil address:nil expMonth:nil expYear:nil dateCreated:nil];
    
    XCTAssertNotNil(self.testSubject.token, @"");
    XCTAssertNotNil(self.testSubject.tokenId, @"");
    XCTAssertNotNil(self.testSubject.name, @"");
    XCTAssertNotNil(self.testSubject.type, @"");
    XCTAssertNotNil(self.testSubject.expMonth, @"");
    XCTAssertNotNil(self.testSubject.expYear, @"");
    
}

-(void)testFromDictionary_BuildsObjectFromDictionaryCorrectly {
	NSDictionary *cardDictionary = @{
                                     @"name" : @"MasterCard Customer",
                                     @"type" : @"cardType",
                                     @"last4" : @1234,
                                     @"addressLine1" : @"2200 MasterCard Blvd",
                                     @"addressLine2" : @"Area 1",
                                     @"addressCity" : @"O'Fallon",
                                     @"addressState" : @"Missouri",
                                     @"addressZip" : @"63368",
                                     @"addressCountry" : @"US",
                                     @"expMonth" : @"05",
                                     @"expYear" : @"50",
                                     @"dateCreated" : @"20140508"
                                     };
	NSDictionary *dictionary = @{@"id" : @"cardTokenID", @"card" : cardDictionary};
    
	self.testSubject = [SIMCreditCardToken cardTokenFromDictionary:dictionary];
    
	XCTAssertTrue([self.testSubject.token isEqualToString:@"cardTokenID"]);
	XCTAssertTrue([self.testSubject.name isEqualToString:@"MasterCard Customer"]);
	XCTAssertTrue([self.testSubject.type isEqualToString:@"cardType"]);
	XCTAssertTrue([self.testSubject.last4 isEqual:@1234]);
	XCTAssertTrue([self.testSubject.address.addressLine1 isEqualToString:@"2200 MasterCard Blvd"]);
	XCTAssertTrue([self.testSubject.address.addressLine2 isEqualToString:@"Area 1"]);
	XCTAssertTrue([self.testSubject.address.city isEqualToString:@"O'Fallon"]);
	XCTAssertTrue([self.testSubject.address.state isEqualToString:@"Missouri"]);
	XCTAssertTrue([self.testSubject.address.zip isEqualToString:@"63368"]);
	XCTAssertTrue([self.testSubject.address.country isEqualToString:@"US"]);
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:20140508 / 1000];
	XCTAssertEqualObjects(self.testSubject.dateCreated, date);
}

@end