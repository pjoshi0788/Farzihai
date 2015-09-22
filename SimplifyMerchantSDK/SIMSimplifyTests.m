#import "SIMSimplify.h"

//Expose internals for testing
@interface SIMSimplify (Test)

@property (nonatomic) NSURL *currentAPIURL;

@end

@interface SIMSimplifyTests : XCTestCase

@property (nonatomic) SIMSimplify *testSubject;

@end

@implementation SIMSimplifyTests

-(void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

-(void)testSimplifyCanDetermineLiveModeFromProvidedPublicKey {
    NSString *publicKey = @"lvpb_1234";
    NSError *error;
    self.testSubject = [[SIMSimplify alloc] initWithPublicKey:publicKey error:&error];

    NSURL *apiURL = [NSURL URLWithString:@"https://api.simplify.com/v1/api"];
    
    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertTrue(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
    XCTAssertEqualObjects(apiURL, self.testSubject.currentAPIURL, @"");
}

-(void)testSimplifyCanDetermineSandboxModeFromProvidedPublicKey {
    NSString *publicKey = @"sbpb_1234";
    NSError *error;
    self.testSubject = [[SIMSimplify alloc] initWithPublicKey:publicKey error:&error];

    NSURL *apiURL = [NSURL URLWithString:@"https://sandbox.simplify.com/v1/api"];

    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertFalse(self.testSubject.isLiveMode, @"");
    XCTAssertNil(error, @"");
    XCTAssertEqualObjects(apiURL, self.testSubject.currentAPIURL, @"");
    
}

-(void)testSimplifyReturnsNilAndErrorWhenPublicKeyIsInvalid {
    NSString *publicKey = @"invalid1234";
    NSError *error;
    self.testSubject = [[SIMSimplify alloc] initWithPublicKey:publicKey error:&error];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNotNil(error, @"");
    XCTAssertEqual(error.code, SIMSimplifyErrorCodeInvalidPublicKey, @"");
}

-(void)testSimplifyAcceptsNilErrorOnSuccess {
    NSString *publicKey = @"sbpb_1234";
    NSError *error;
    self.testSubject = [[SIMSimplify alloc] initWithPublicKey:publicKey error:nil];
    
    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertNil(error, @"");
}

-(void)testSimplifyAcceptsNilErrorOnFailureAndNilObject {
    NSString *publicKey = @"invalid1234";
    NSError *error;
    self.testSubject = [[SIMSimplify alloc] initWithPublicKey:publicKey error:nil];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNil(error, @"");
}

@end
