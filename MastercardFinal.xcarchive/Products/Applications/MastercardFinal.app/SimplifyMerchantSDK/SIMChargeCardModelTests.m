#import "SIMChargeCardModel.h"
#import <OCMock/OCMock.h>

@interface SIMChargeCardModel (Test)

-(instancetype)initWithPublicKey:(NSString *)publicKey simplify:(SIMSimplify *)simplify;

@property (nonatomic) NSURL *currentAPIURL;

@end

@interface SIMChargeCardModelTests : XCTestCase
@property (nonatomic, strong) SIMChargeCardModel *testSubject;
@property (nonatomic) id mockSimplify;
@end

@implementation SIMChargeCardModelTests

-(void)setUp
{
    [super setUp];
    
    self.mockSimplify = [OCMockObject mockForClass:SIMSimplify.class];
    self.testSubject = [[SIMChargeCardModel alloc] initWithPublicKey:@"sbpb_N2ZkOGIwZWYtYTg3My00OTE1LWI3ZjgtMzZhMzZhZTAyYTY5" simplify:self.mockSimplify];
    
}

-(void)tearDown
{
    [super tearDown];
}

-(void)testChargeCardModelReturnsNilAndErrorWhenPublicKeyIsInvalid {
    NSString *publicKey = @"invalid1234";
    NSError *error;
    self.testSubject = [[SIMChargeCardModel alloc] initWithPublicKey:publicKey error:&error];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNotNil(error, @"");
    XCTAssertEqual(error.code, SIMSimplifyErrorCodeInvalidPublicKey, @"");
}

-(void)testSimplifyAcceptsNilErrorOnSuccess {
    NSString *publicKey = @"sbpb_1234";
    NSError *error;
    self.testSubject = [[SIMChargeCardModel alloc] initWithPublicKey:publicKey error:nil];
    
    XCTAssertNotNil(self.testSubject, @"");
    XCTAssertNil(error, @"");
}

-(void)testSimplifyAcceptsNilErrorOnFailureAndNilObject {
    NSString *publicKey = @"invalid1234";
    NSError *error;
    self.testSubject = [[SIMChargeCardModel alloc] initWithPublicKey:publicKey error:nil];
    
    XCTAssertNil(self.testSubject, @"");
    XCTAssertNil(error, @"");
}

-(void)testInitWithCartInitializesChargeCardModelProperly
{
    XCTAssertEqualObjects(self.testSubject.cardNumber, @"", "no card number");
    XCTAssertEqualObjects(self.testSubject.expirationDate, @"", "no expiration");
    XCTAssertEqualObjects(self.testSubject.formattedCardNumber, @"", "no formatted card number");
    XCTAssertEqualObjects(self.testSubject.formattedExpirationDate, @"", "no formatted expiration");
    XCTAssertEqualObjects(self.testSubject.cvcCode, @"", "no cvc code");
    XCTAssertEqualObjects(self.testSubject.zipCode, @"", "no zip code");
    XCTAssertEqualObjects(self.testSubject.cardTypeString, @"blank", "blank type");
}

//Tests for format
-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsOneDigitLong {
    NSString *expectedExpirationDate = @"2M/YY";
    NSString *expectedExpirationMonth = @"2";
    
    [self.testSubject updateExpirationDateWithString:@"2"];
    
    NSString *actualExpirationDate = self.testSubject.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testSubject.expirationMonth;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "one digit");
    XCTAssertEqualObjects(expectedExpirationMonth, actualExpirationMonth, "one digit");
}

-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsTwoDigitsLong {
    NSString *expectedExpirationDate = @"12/YY";
    
    [self.testSubject updateExpirationDateWithString:@"12"];
    
    NSString *actualExpirationDate = self.testSubject.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testSubject.expirationMonth;
    NSString *actualExpirationYear = self.testSubject.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "two digits");
    XCTAssertEqualObjects(@"12", actualExpirationMonth, "two digits");
    XCTAssertEqualObjects(@"", actualExpirationYear, "no digit");
}

-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsThreeDigitsLong {
    NSString *expectedExpirationDate = @"12/5Y";
    
    [self.testSubject updateExpirationDateWithString:@"125"];
    
    NSString *actualExpirationDate = self.testSubject.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testSubject.expirationMonth;
    NSString *actualExpirationYear = self.testSubject.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "three digits");
    XCTAssertEqualObjects(@"12", actualExpirationMonth, "two digits");
    XCTAssertEqualObjects(@"5", actualExpirationYear, "one digit");
}

-(void)testFormattedExpirationDateFormatsCorrectlyWhenStringIsFourDigitsLong {
    NSString *expectedExpirationDate = @"12/54";
    
    [self.testSubject updateExpirationDateWithString:@"1254"];
    
    NSString *actualExpirationDate = self.testSubject.formattedExpirationDate;
    NSString *actualExpirationMonth = self.testSubject.expirationMonth;
    NSString *actualExpirationYear = self.testSubject.expirationYear;
    
    XCTAssertEqualObjects(expectedExpirationDate, actualExpirationDate, "four digits");
    XCTAssertEqualObjects(@"12", actualExpirationMonth, "two digits");
    XCTAssertEqualObjects(@"54", actualExpirationYear, "two digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith4NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234";
    
    [self.testSubject updateCardNumberWithString:@"1234"];
    
    NSString *actualCreditCardString = self.testSubject.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "four digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith5NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5";
    
    [self.testSubject updateCardNumberWithString:@"12345"];
    
    NSString *actualCreditCardString = self.testSubject.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "five digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith11NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5678 901";
    
    [self.testSubject updateCardNumberWithString:@"12345678901"];
    
    NSString *actualCreditCardString = self.testSubject.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "11 digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith16NumbersWhenNotTypeAmex {
    NSString *expectedCreditCardString = @"1234 5678 9012 3456";
    
    [self.testSubject updateCardNumberWithString:@"1234567890123456"];
    
    NSString *actualCreditCardString = self.testSubject.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "16 digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith4NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434";
    
    [self.testSubject updateCardNumberWithString:@"3434"];
    
    NSString *actualCreditCardString = self.testSubject.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "four digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith5NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434 5";
    
    [self.testSubject updateCardNumberWithString:@"34345"];
    
    NSString *actualCreditCardString = self.testSubject.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "five digits");
}

-(void)testFormatttedCreditCardStringFormatsCorrectlyWith11NumbersWhenTypeAmex {
    NSString *expectedCreditCardString = @"3434 567890 1";
    
    [self.testSubject updateCardNumberWithString:@"34345678901"];
    
    NSString *actualCreditCardString = self.testSubject.formattedCardNumber;
    
    XCTAssertEqualObjects(expectedCreditCardString, actualCreditCardString, "11 digits");
}

//Tests for isRetrivalPossible, isExpirationDateValid, and isCardNumberValid
-(void)testIsCardChargePossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigits {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"1273"];
    [self.testSubject updateCVCNumberWithString:@"123"];
    [self.testSubject updateZipCodeWithString:@"12345"];

    XCTAssertTrue([self.testSubject isExpirationDateValid], "should be a valid expiration date");
    XCTAssertTrue([self.testSubject isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testSubject isCVCCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testSubject isZipCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testSubject isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigitsZipCode9 {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"1273"];
    [self.testSubject updateCVCNumberWithString:@"123"];
    [self.testSubject updateZipCodeWithString:@"123456789"];
    
    XCTAssertTrue([self.testSubject isExpirationDateValid], "should be a valid expiration date");
    XCTAssertTrue([self.testSubject isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testSubject isCVCCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testSubject isZipCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testSubject isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigitsExceptNoZipCode {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"1273"];
    [self.testSubject updateCVCNumberWithString:@"123"];
    
    XCTAssertTrue([self.testSubject isExpirationDateValid], "should be a valid expiration date");
    XCTAssertTrue([self.testSubject isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testSubject isCVCCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testSubject isZipCodeValid], "no digits");
    XCTAssertTrue([self.testSubject isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsYesWhenCardTypeBlankAndCVCLengthIs3 {
    [self.testSubject updateCardNumberWithString:@"6709507858655272"];
    [self.testSubject updateExpirationDateWithString:@"0173"];
    [self.testSubject updateCVCNumberWithString:@"123"];
    
    XCTAssertTrue([self.testSubject isExpirationDateValid], "should be a valid expiration date");
    XCTAssertTrue([self.testSubject isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testSubject isCVCCodeValid], "should be a correct number of digits");
    XCTAssertTrue([self.testSubject isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsNoWhenCardNumberIsLessThanMinimumNumberOfDigitsPerCardType {
    [self.testSubject updateCardNumberWithString:@"412345678901"];
    [self.testSubject updateExpirationDateWithString:@"173"];
    XCTAssertFalse([self.testSubject isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no, less than minumum for visa");
}

-(void)testIsCardChargePossibleReturnsNoWhenCardNumberIsMoreThanMaximumNumberOfDigitsPerCardType {
    [self.testSubject updateCardNumberWithString:@"34123456789013"];
    [self.testSubject updateExpirationDateWithString:@"173"];
    XCTAssertFalse([self.testSubject isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no, more than max for amex");
}

-(void)testIsCardChargePossibleReturnsNoWhenCardNumberIsNotLuhnValidated {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5102"];
    [self.testSubject updateExpirationDateWithString:@"173"];
    XCTAssertFalse([self.testSubject isCardNumberValid], "should not be a valid card");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no, more than max for amex");
}

-(void)testIsCardChargePossibleReturnsYesWhenAllFieldsHaveCorrectNumberOfDigitsButNoCVCCode {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"1273"];
    XCTAssertTrue([self.testSubject isExpirationDateValid], "should be yes");
    XCTAssertTrue([self.testSubject isCardNumberValid], "should be a valid card");
    XCTAssertTrue([self.testSubject isCVCCodeValid], "should be valid with no code");
    XCTAssertTrue([self.testSubject isCardChargePossible], "should be yes");
}

-(void)testIsCardChargePossibleReturnsNoWhenExpirationDateIsLessThanThreeDigits {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"12"];
    XCTAssertFalse([self.testSubject isExpirationDateValid], "should be no");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no");
}

-(void)testIsCardChargePossibleReturnsNoWhenExpirationDateIsExpired {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"4/14"];
    XCTAssertFalse([self.testSubject isExpirationDateValid], "should be no");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no");
}

-(void)testIsCardChargePossibleReturnsNoWhenCVCCodeIsNotLongEnough {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"4/94"];
    [self.testSubject updateCVCNumberWithString:@"12"];
    XCTAssertFalse([self.testSubject isCVCCodeValid], "should be no");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no");
}

-(void)testIsCardChargePossibleReturnsNoWhenZipCodeIsNotLongEnough {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"4/94"];
    [self.testSubject updateZipCodeWithString:@"12"];
    XCTAssertFalse([self.testSubject isZipCodeValid], "should be no");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no");
}

-(void)testIsCardChargePossibleReturnsNoWhenZipCodeIsLongerThanFiveButShorterThanNine {
    [self.testSubject updateCardNumberWithString:@"5105 1051 0510 5100"];
    [self.testSubject updateExpirationDateWithString:@"4/94"];
    [self.testSubject updateZipCodeWithString:@"123456"];
    XCTAssertFalse([self.testSubject isZipCodeValid], "should be no");
    XCTAssertFalse([self.testSubject isCardChargePossible], "should be no");
}

//Tests for updating charge amount, card number, expiration date, and CVC code
-(void)testUpdateCardNumberWithStringCorrectlyRemovesSpaces {
    NSString *expectedStringWithNoSpaces = @"123434563456";
    
    [self.testSubject updateCardNumberWithString:@"1234 3456 3456"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"123434563456";
    
    [self.testSubject updateCardNumberWithString:@"1234 a3456s 3456s"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no non-digits");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfOver19Digits {
    [self.testSubject updateCardNumberWithString:@"1234 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"1234345634563456";
    
    [self.testSubject updateCardNumberWithString:@"1234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfDinersAndOver14Digits {
    [self.testSubject updateCardNumberWithString:@"3004 3456 3456 34"];
    NSString *expectedStringWithNoSpaces = @"30043456345634";
    
    [self.testSubject updateCardNumberWithString:@"3004 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfAmexAndOver15Digits {
    [self.testSubject updateCardNumberWithString:@"34234 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"34234345634563456";
    
    [self.testSubject updateCardNumberWithString:@"341234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfMasterCardAndOver16Digits {
    [self.testSubject updateCardNumberWithString:@"3528 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"3528345634563456";
    
    [self.testSubject updateCardNumberWithString:@"35289 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no spaces");
}

-(void)testUpdateCardNumberWithStringDoesNotUpdateCardNumberIfJCBAndOver16Digits {
    [self.testSubject updateCardNumberWithString:@"5134 3456 3456 3456"];
    NSString *expectedStringWithNoSpaces = @"5134345634563456";
    
    [self.testSubject updateCardNumberWithString:@"351234 3456 3456 3456 1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no spaces");
}

-(void)testUpdateExpirationDateWithStringCorrectlyRemovesSlashes {
    NSString *expectedStringWithNoSpaces = @"24";
    
    [self.testSubject updateExpirationDateWithString:@"24"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "no spaces");
}

-(void)testUpdateExpirationDateWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"24";
    
    [self.testSubject updateExpirationDateWithString:@"2a4"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "only digits");
}

-(void)testUpdateExpirationDateWithStringDoesNotAllow00ForMonth {
    NSString *expectedStringWithNoDoubleZero = @"024";
    
    [self.testSubject updateExpirationDateWithString:@"024"];
    [self.testSubject updateExpirationDateWithString:@"0024"];
    
    XCTAssertEqualObjects(expectedStringWithNoDoubleZero, self.testSubject.expirationDate, "no double zero for month");
}

-(void)testUpdateExpirationDateWithStringDoesNotUpdateExpirationDateIfOver4Digits {
    [self.testSubject updateExpirationDateWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testSubject updateExpirationDateWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringIsNot4DigitsLongIfMonthDoesNotStartWith0or1 {
    [self.testSubject updateExpirationDateWithString:@"234"];
    NSString *expectedStringWithNoSpaces = @"234";
    
    [self.testSubject updateExpirationDateWithString:@"2345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringIfStringIsEmpty {
    [self.testSubject updateExpirationDateWithString:@""];
    NSString *expectedStringWithNoSpaces = @"";
    
    [self.testSubject updateExpirationDateWithString:@""];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "no digits");
}

-(void)testUpdateExpirationDateWithStringDoesNotUpdateExpirationDateIfMonthMoreThan12 {
    [self.testSubject updateExpirationDateWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testSubject updateExpirationDateWithString:@"1345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "four digits");
}

-(void)testUpdateExpirationDateWithStringDoesUpdateExpirationDateIfMonthStartsWithZero {
    [self.testSubject updateExpirationDateWithString:@"0234"];
    NSString *expectedStringWithNoSpaces = @"0234";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverFourDigitsIfCardTypeBlank {
    [self.testSubject updateCardNumberWithString:@"1"];
    [self.testSubject updateCVCNumberWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testSubject updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cvcCode, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverFourDigitsIfCardTypeAmex {
    [self.testSubject updateCardNumberWithString:@"341234"];
    [self.testSubject updateCVCNumberWithString:@"1234"];
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testSubject updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cvcCode, "four digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotUpdateCVCCodeIfOverThreeDigitsIfCardTypeNotBlankOrAmex {
    [self.testSubject updateCardNumberWithString:@"41234"];
    [self.testSubject updateCVCNumberWithString:@"123"];
    NSString *expectedStringWithNoSpaces = @"123";
    
    [self.testSubject updateCVCNumberWithString:@"12345"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cvcCode, "three digits");
}

-(void)testUpdateCVCNumberWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testSubject updateCVCNumberWithString:@"12sf34"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cvcCode, "four digits");
}

-(void)testUpdateZipCodeWithStringUpdatesZipCode {
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testSubject updateZipCodeWithString:@"1234"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.zipCode, "four digits");
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.address.zip, "four digits");
}

-(void)testUpdateZipCodeWithStringUpdatesZipCodeIfLongerThanFiveDigits {
    NSString *expectedStringWithNoSpaces = @"123456";
    
    [self.testSubject updateZipCodeWithString:@"123456"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.zipCode, "six digits");
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.address.zip, "six digits");
}

-(void)testUpdateZipCodeWithStringDoesNotUpdateZipCodeIfMoreThan9Digits {
    [self.testSubject updateZipCodeWithString:@"123456789"];
    NSString *expectedStringWithNoSpaces = @"123456789";
    
    [self.testSubject updateZipCodeWithString:@"1234567890"];

    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.zipCode, "nine digits");
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.address.zip, "nine digits");
}

-(void)testUpdateZipCodeWithStringDoesNotAddNonDigits {
    NSString *expectedStringWithNoSpaces = @"1234";
    
    [self.testSubject updateZipCodeWithString:@"12sf34"];
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.zipCode, "four digits");
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.address.zip, "four digits");
}


-(void)testDeleteCharacterInExpirationFormatsCorrectly {
    [self.testSubject updateExpirationDateWithString:@"0234"];
    [self.testSubject deleteCharacterInExpiration];
    NSString *expectedStringWithNoSpaces = @"023";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "three digits");
}

-(void)testDeleteCharacterInExpirationFormatsCorrectlyWithOneDigit {
    [self.testSubject updateExpirationDateWithString:@"0"];
    [self.testSubject deleteCharacterInExpiration];
    NSString *expectedStringWithNoSpaces = @"";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "no digits");
}

-(void)testDeleteCharacterInExpirationFormatsCorrectlyWithNoDigits {
    [self.testSubject updateExpirationDateWithString:@""];
    [self.testSubject deleteCharacterInExpiration];
    NSString *expectedStringWithNoSpaces = @"";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.expirationDate, "no digits");
}

-(void)testDeleteCharacterInCardNumberFormatsCorrectly {
    [self.testSubject updateCardNumberWithString:@"0234"];
    [self.testSubject deleteCharacterInCardNumber];
    NSString *expectedStringWithNoSpaces = @"023";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "three digits");
}

-(void)testDeleteCharacterInCardNumberFormatsCorrectlyWithOneDigit {
    [self.testSubject updateCardNumberWithString:@"0"];
    [self.testSubject deleteCharacterInCardNumber];
    NSString *expectedStringWithNoSpaces = @"";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no digits");
}

-(void)testDeleteCharacterInCardNumberFormatsCorrectlyWithNoDigits {
    [self.testSubject updateCardNumberWithString:@""];
    [self.testSubject deleteCharacterInCardNumber];
    NSString *expectedStringWithNoSpaces = @"";
    
    XCTAssertEqualObjects(expectedStringWithNoSpaces, self.testSubject.cardNumber, "no digits");
}

-(void)testRetrieveTokenWithCallsSimplify {
    
    [[self.mockSimplify expect] createCardTokenWithExpirationMonth:OCMOCK_ANY expirationYear:OCMOCK_ANY cardNumber:OCMOCK_ANY cvc:OCMOCK_ANY address:OCMOCK_ANY completionHander:OCMOCK_ANY];
    
    [self.testSubject retrieveToken];
    
    [self.mockSimplify verify];
    
}

-(void)testIsApplePayAvailableIsTrueWhenRequestIsPresentAndDeviceCanMakePayments {
    
    id mockPaymentRequest  = [OCMockObject mockForClass:PKPaymentRequest.class];
    self.testSubject.paymentRequest = mockPaymentRequest;
    id mockPKPaymentAuthorizationViewController = [OCMockObject mockForClass:PKPaymentAuthorizationViewController.class];
    
    [[[mockPKPaymentAuthorizationViewController stub] andReturnValue:OCMOCK_VALUE(YES)] canMakePayments];
    
    BOOL canMakePayments = [self.testSubject isApplePayAvailable];
    
    XCTAssertTrue(canMakePayments);

}

-(void)testIsApplePayAvailableIsFalseWhenRequestIsNotPresentAndDeviceCanMakePayments {
    
    self.testSubject.paymentRequest = nil;
    id mockPKPaymentAuthorizationViewController = [OCMockObject mockForClass:PKPaymentAuthorizationViewController.class];
    
    [[[mockPKPaymentAuthorizationViewController stub] andReturnValue:OCMOCK_VALUE(YES)] canMakePayments];
    
    BOOL canMakePayments = [self.testSubject isApplePayAvailable];
    
    XCTAssertFalse(canMakePayments);
    
}

-(void)testIsApplePayAvailableIsFalseWhenRequestIsPresentAndDeviceCannotMakePayments {
    
    id mockPaymentRequest  = [OCMockObject mockForClass:PKPaymentRequest.class];
    self.testSubject.paymentRequest = mockPaymentRequest;
    id mockPKPaymentAuthorizationViewController = [OCMockObject mockForClass:PKPaymentAuthorizationViewController.class];

    
    [[[mockPKPaymentAuthorizationViewController stub] andReturnValue:OCMOCK_VALUE(NO)] canMakePayments];
    
    BOOL canMakePayments = [self.testSubject isApplePayAvailable];
    
    XCTAssertFalse(canMakePayments);
    
}

-(void)testIsApplePayAvailableIsFalseWhenRequestIsNotPresentAndDeviceCannotMakePayments {
    
    self.testSubject.paymentRequest = nil;
    id mockPKPaymentAuthorizationViewController = [OCMockObject mockForClass:PKPaymentAuthorizationViewController.class];
    
    [[[mockPKPaymentAuthorizationViewController stub] andReturnValue:OCMOCK_VALUE(NO)] canMakePayments];
    
    BOOL canMakePayments = [self.testSubject isApplePayAvailable];
    
    XCTAssertFalse(canMakePayments);
    
}


@end
