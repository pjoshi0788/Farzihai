#import "SIMLuhnValidator.h"
@interface SIMLuhnValidatorTests : XCTestCase
@property (nonatomic, strong) SIMLuhnValidator *testLuhnValidator;
@end

@implementation SIMLuhnValidatorTests

-(void)setUp
{
    [super setUp];
    self.testLuhnValidator = [SIMLuhnValidator new];
}

-(void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testLuhnValidatorReturnsYesForValidCards
{
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"49927398716"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"1234567812345670"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"79927398713"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"5105105105105100"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"5204 7400 0990 0014"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"5420 9238 7872 4339"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"5553 0422 4198 4105"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"5555 5555 5555 4444"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"4012 8888 8888 1881"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"4111 1111 1111 1111"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"6011 0009 9013 9424"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"6011 1111 1111 1117"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"3714 496353 98431"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"3782 822463 10005"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"3056 9309 0259 04"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"3852 0000 0232 37"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"3530 1113 3330 0000"], "valid");
    XCTAssertTrue([self.testLuhnValidator luhnValidateString:@"3566 0020 2036 0505"], "valid");

    
}

-(void)testLuhnValidatorReturnsNoForInvalidCards
{
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"49927398717"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"1234567812345678"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398710"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398711"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398712"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398714"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398715"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398716"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398717"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398718"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"79927398719"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"a"], "invalid");
    XCTAssertFalse([self.testLuhnValidator luhnValidateString:@"799273987a1s9"], "invalid");
}

@end
