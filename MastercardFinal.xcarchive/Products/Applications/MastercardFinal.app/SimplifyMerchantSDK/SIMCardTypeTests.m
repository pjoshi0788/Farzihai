#import "SIMCardType.h"

@interface SIMCardTypeTests : XCTestCase
@end

@implementation SIMCardTypeTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testIfCardNumberHasNonDigitsThenReturnsUnknownCardType {
    NSString *unknown = @"blank";
    int cvcLength = 4;
    int minCardLength = 13;
    int maxCardLength = 19;
    SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"34asdad"];
	XCTAssertEqualObjects(unknown, testCardType.cardTypeString, "unknown");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
}

-(void)testAmexRangeReturnsAmex {
    NSString *americanExpress = @"amex";
    int cvcLength = 4;
    int minCardLength = 15;
    int maxCardLength = 15;
    SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"34"];
	XCTAssertEqualObjects(americanExpress, testCardType.cardTypeString, "amex");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
    testCardType  = [SIMCardType cardTypeFromCardNumberString:@"37"];
	XCTAssertEqualObjects(americanExpress, testCardType.cardTypeString, "amex");
}

-(void)testChinaUnionRangeReturnsChinaUnion {
    NSString *chinaUnion = @"china-union";
    int cvcLength = 3;
    int minCardLength = 16;
    int maxCardLength = 19;
    SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"622"];
	XCTAssertEqualObjects(chinaUnion, testCardType.cardTypeString, "china union");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
    testCardType  = [SIMCardType cardTypeFromCardNumberString:@"624"];
	XCTAssertEqualObjects(chinaUnion, testCardType.cardTypeString, "china union");
    testCardType  = [SIMCardType cardTypeFromCardNumberString:@"625"];
	XCTAssertEqualObjects(chinaUnion, testCardType.cardTypeString, "china union");
    testCardType  = [SIMCardType cardTypeFromCardNumberString:@"626"];
	XCTAssertEqualObjects(chinaUnion, testCardType.cardTypeString, "china union");
    testCardType  = [SIMCardType cardTypeFromCardNumberString:@"628"];
	XCTAssertEqualObjects(chinaUnion, testCardType.cardTypeString, "china union");
}

-(void)testDinersClubRangeReturnsDinersClub{
    NSString *dinersClub = @"diners";
    int cvcLength = 3;
    int minCardLength = 14;
    int maxCardLength = 16;
	SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"300"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"301"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"302"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"303"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"304"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"305"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
    testCardType  = [SIMCardType cardTypeFromCardNumberString:@"309"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"36"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"38"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
	testCardType  = [SIMCardType cardTypeFromCardNumberString:@"39"];
	XCTAssertEqualObjects(dinersClub, testCardType.cardTypeString, "diners");
}

-(void)testDiscoverCardRangeReturnsDiscover {
    NSString *discover = @"discover";
    int cvcLength = 3;
    int minCardLength = 16;
    int maxCardLength = 16;
    SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"65"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
	testCardType = [SIMCardType cardTypeFromCardNumberString:@"6011"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
	testCardType = [SIMCardType cardTypeFromCardNumberString:@"644"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"645"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"646"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"647"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"648"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"649"];
	XCTAssertEqualObjects(discover, testCardType.cardTypeString, "discover");
}

-(void)testJCBRangeReturnsJCB {
	NSString *jcb = @"jcb";
    int cvcLength = 3;
    int minCardLength = 16;
    int maxCardLength = 16;
    SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"3528"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"3529"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"353"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"354"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"355"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"356"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"357"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"358"];
    XCTAssertEqualObjects(jcb, testCardType.cardTypeString, "jcb");
}

-(void)testMasterCardRangeReturnsMasterCard {
    NSString *mastercard = @"mastercard";
    int cvcLength = 3;
    int minCardLength = 16;
    int maxCardLength = 16;
	SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"51"];
	XCTAssertEqualObjects(mastercard, testCardType.cardTypeString, "mastercard");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
	testCardType = [SIMCardType cardTypeFromCardNumberString:@"52"];
	XCTAssertEqualObjects(mastercard, testCardType.cardTypeString, "mastercard");
	testCardType = [SIMCardType cardTypeFromCardNumberString:@"53"];
	XCTAssertEqualObjects(mastercard, testCardType.cardTypeString, "mastercard");
	testCardType = [SIMCardType cardTypeFromCardNumberString:@"54"];
	XCTAssertEqualObjects(mastercard, testCardType.cardTypeString, "mastercard");
	testCardType = [SIMCardType cardTypeFromCardNumberString:@"55"];
	XCTAssertEqualObjects(mastercard, testCardType.cardTypeString, "mastercard");
    testCardType = [SIMCardType cardTypeFromCardNumberString:@"67"];
	XCTAssertEqualObjects(mastercard, testCardType.cardTypeString, "mastercard");
}

-(void)testVisaRangeReturnsVisa {
	NSString *visa = @"visa";
    int cvcLength = 3;
    int minCardLength = 13;
    int maxCardLength = 19;
    SIMCardType *testCardType  = [SIMCardType cardTypeFromCardNumberString:@"4"];
	XCTAssertEqualObjects(visa, testCardType.cardTypeString, "visa");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
}

-(void)testUnknownRangeReturnsBlankType {
	NSString *blank = @"blank";
    int cvcLength = 4;
    int minCardLength = 13;
    int maxCardLength = 19;
    SIMCardType *testCardType = [SIMCardType cardTypeFromCardNumberString:@"1"];
	XCTAssertEqualObjects(blank, testCardType.cardTypeString, "blank card");
    XCTAssertEqual(cvcLength, testCardType.CVCLength, "cvc");
    XCTAssertEqual(minCardLength, testCardType.minCardLength, "min card length");
    XCTAssertEqual(maxCardLength, testCardType.maxCardLength, "max card length");
}

@end
