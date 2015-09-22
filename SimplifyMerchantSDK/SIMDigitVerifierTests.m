#import "SIMDigitVerifier.h"

@interface SIMDigitVerifierTests : XCTestCase
@property (nonatomic, strong) SIMDigitVerifier *testDigitVerifier;
@end

@implementation SIMDigitVerifierTests

-(void)setUp
{
    [super setUp];
    self.testDigitVerifier = [SIMDigitVerifier new];
}

-(void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testIsDigitReturnsYesForDigit
{
    BOOL isDigit = [self.testDigitVerifier isDigit:@"0"];
    XCTAssertTrue(isDigit, "is digit");
}

-(void)testIsDigitReturnsYesForMultipleDigits
{
    BOOL isDigit = [self.testDigitVerifier isDigit:@"023425543"];
    XCTAssertTrue(isDigit, "is digit");
}

-(void)testIsDigitReturnsNoForNegativeDigits
{
    BOOL isDigit = [self.testDigitVerifier isDigit:@"-5"];
    XCTAssertFalse(isDigit, "is not digit");
}

-(void)testIsDigitReturnsNoForCharaceters
{
    BOOL isDigit = [self.testDigitVerifier isDigit:@"digits"];
    XCTAssertFalse(isDigit, "is not digit");
}

@end
