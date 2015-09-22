#import "SIMChargeCardModel.h"
#import "SIMDigitVerifier.h"
#import "SIMLuhnValidator.h"

@interface SIMChargeCardModel ()

@property (nonatomic, strong) SIMDigitVerifier *digitVerifier;
@property (nonatomic, strong) SIMSimplify *simplify;
@property (nonatomic, strong) NSString *publicKey;
@property (nonatomic, strong, readwrite) NSString *cardNumber;
@property (nonatomic, strong, readwrite) NSString *expirationDate;
@property (nonatomic, strong, readwrite) NSString *expirationMonth;
@property (nonatomic, strong, readwrite) NSString *expirationYear;
@property (nonatomic, strong, readwrite) NSString *formattedCardNumber;
@property (nonatomic, strong, readwrite) NSString *formattedExpirationDate;
@property (nonatomic, strong, readwrite) NSString *cvcCode;
@property (nonatomic, strong, readwrite) NSString *zipCode;
@property (nonatomic, strong, readwrite) NSString *cardTypeString;
@property (nonatomic, strong, readwrite) SIMAddress *address;
@property (nonatomic, readwrite) int cvcLength;
@property (nonatomic, readwrite) int cardNumberMinLength;
@property (nonatomic, readwrite) int cardNumberMaxLength;
@end

@implementation SIMChargeCardModel

-(instancetype)initWithPublicKey:(NSString *)publicKey error:(NSError **)error{
    
    NSError *apiError;
    self.simplify = [[SIMSimplify alloc] initWithPublicKey:publicKey error:&apiError];
    
    if (apiError) {
        if(error != NULL) *error = apiError;
        return nil;
    } else {
        return [self initWithPublicKey:publicKey simplify:self.simplify];
    }
}

-(instancetype)initWithPublicKey:(NSString *)publicKey simplify:(SIMSimplify *)simplify{
    self = [super init];
    
    if (self) {
        self.cardNumber = @"";
        self.expirationDate = @"";
        self.cvcCode = @"";
        self.zipCode = @"";
        self.publicKey = publicKey;
        self.simplify = simplify;
    }
    return self;
}


-(BOOL)isCardChargePossible {
    if ([self isCardNumberValid] && [self isExpirationDateValid] && [self isCVCCodeValid] && [self isZipCodeValid]) {
        return YES;
    }
    return NO;
}

-(BOOL)isCardNumberValid {
    if ((self.cardNumber.length >= self.cardNumberMinLength) && (self.cardNumber.length <= self.cardNumberMaxLength)) {
        SIMLuhnValidator *luhnValidator = [SIMLuhnValidator new];
        return [luhnValidator luhnValidateString:self.cardNumber];
    }
    return NO;
}

-(BOOL)isExpirationDateValid {
    if ((self.expirationDate.length == 4) && [self expirationDateInFuture] && [self isExpirationMonthValid]) {
        return YES;
    }
    return NO;
}

-(BOOL)isExpirationMonthValid {
    if (([self.expirationMonth integerValue] <= 12) && ([self.expirationMonth integerValue] > 0)) {
        return YES;
    }
    return NO;
}

-(BOOL)isCVCCodeValid {
    if (self.isCVCRequired && self.cvcCode.length == 0) {
        return NO;
    }
    if (self.cvcCode.length == self.cvcLength || self.cvcCode.length == 0  || (self.cvcCode.length == 3 && [self.cardType.cardTypeString  isEqual: @"blank"])) {
        return YES;
    }
    return NO;
}

-(BOOL)isZipCodeValid {
    if (self.isZipRequired && self.zipCode.length == 0) {
        return NO;
    }
    if (self.zipCode.length == 0  || self.zipCode.length == 5 || self.zipCode.length == 9) {
        return YES;
    }
    return NO;
}

-(BOOL)isApplePayAvailable {
    
    return (self.paymentRequest && [PKPaymentAuthorizationViewController canMakePayments]);
}

-(BOOL)expirationDateInFuture {
    NSDate *currentDate = [NSDate date];
    int expirationMonthInt = [self.expirationMonth intValue] + 1;
    int expirationYearInt = [self.expirationYear intValue];
    if ([self.expirationMonth intValue] == 12) {
        expirationMonthInt = 01;
        expirationYearInt += 1;
    }
    
    NSString *dateString = [NSString stringWithFormat:@"%d-20%d", expirationMonthInt, expirationYearInt];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"MM-yyyy";
    NSDate *expirationDate = [dateFormatter dateFromString:dateString];
    return [expirationDate compare:currentDate] == NSOrderedDescending || [expirationDate compare:currentDate] == NSOrderedSame;
}

-(void)updateCardNumberWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if (updatedString.length <= self.cardNumberMaxLength) {
        self.cardNumber = updatedString;
    }
}

-(void)updateExpirationDateWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    if (updatedString.length > 0) {
        int firstDigit = (int)([updatedString characterAtIndex:0] - '0');
        
        
        if (updatedString.length <= 3) {
            self.expirationDate = updatedString;
            
        } else if ((firstDigit <= 1) && (updatedString.length == 4)) {
            int secondDigit = (int)([updatedString characterAtIndex:1] - '0');
            if ((firstDigit == 0)  && (secondDigit > 0)) {
                self.expirationDate = updatedString;
            } else if ((firstDigit == 1) && (secondDigit < 3)) {
                self.expirationDate = updatedString;
            }
        }
    } else {
        self.expirationDate = updatedString;
    }
}


-(void)updateCVCNumberWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if (updatedString.length <= self.cvcLength) {
        self.cvcCode = updatedString;
    }
}

-(void)updateZipCodeWithString:(NSString *)newString {
    NSString *updatedString = [[newString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    if (updatedString.length <= 9) {
        self.zipCode = updatedString;
        self.address = [[SIMAddress alloc] initWithName:nil addressLine1:nil addressLine2:nil city:nil state:nil zip:self.zipCode];
    }
}

-(void)deleteCharacterInExpiration {
    if (self.expirationDate.length > 0) {
        NSString *newExpirationDate = [self.expirationDate substringToIndex:self.expirationDate.length -1];
        [self updateExpirationDateWithString:newExpirationDate];
    }
}

-(void)deleteCharacterInCardNumber {
    if (self.cardNumber.length > 0) {
        NSString *newCardNumber = [self.cardNumber substringToIndex:self.cardNumber.length -1];
        [self updateCardNumberWithString:newCardNumber];
    }
}

-(NSString *)formattedCardNumber {
    NSMutableString *formattedString =[NSMutableString stringWithString:self.cardNumber];
    if (![self.cardTypeString isEqual: @"amex"]) {
        int index=4;
        
        while (index < formattedString.length && formattedString.length < 23) {
            [formattedString insertString:@" " atIndex:index];
            index +=5;
        }
    } else {
        if (self.cardNumber.length > 4 && self.cardNumber.length < 10) {
            [formattedString insertString:@" " atIndex:4];
        } else if (self.cardNumber.length >= 10) {
            [formattedString insertString:@" " atIndex:4];
            [formattedString insertString:@" " atIndex:11];
        }
    }
    
    return formattedString;
}

-(NSString *)formattedExpirationDate {
    if (self.expirationDate.length == 1) {
        return [NSString stringWithFormat:@"%@M/YY",self.expirationMonth];
    }
    else if (self.expirationDate.length == 2) {
        return [NSString stringWithFormat:@"%@/YY",self.expirationMonth];
    }
    else if (self.expirationDate.length == 3) {
        return [NSString stringWithFormat:@"%@/%@Y",self.expirationMonth, self.expirationYear];
    }
    else if (self.expirationDate.length == 4) {
        return [NSString stringWithFormat:@"%@/%@",self.expirationMonth, self.expirationYear];
    }
    return self.expirationDate;
}

-(NSString *)expirationMonth {
    if (self.expirationDate.length  == 1) {
        return [self.expirationDate substringToIndex:1];
    } else if (self.expirationDate.length > 1){
        return [self.expirationDate substringToIndex:2];
    }
    return @"";
}

-(NSString *)expirationYear {
    
    if (self.expirationDate.length > 2){
        return [self.expirationDate substringFromIndex:2];
    }
    return @"";
}

-(NSString *)cardTypeString {
    return self.cardType.cardTypeString;
}

-(SIMCardType *)cardType {
    return [SIMCardType cardTypeFromCardNumberString:self.cardNumber];
}

-(int)cvcLength {
    return self.cardType.CVCLength;
}

-(int)cardNumberMaxLength {
    return self.cardType.maxCardLength;
}

-(int)cardNumberMinLength {
    return self.cardType.minCardLength;
}

-(void)retrieveToken {
    
    CardTokenCompletionHandler completionHandler = ^(SIMCreditCardToken *cardToken, NSError *error) {
        if (error) {
            [self.delegate tokenFailedWithError:error];
        } else {
            [self.delegate tokenProcessed:cardToken];
        }
    };
    
    [self.simplify createCardTokenWithExpirationMonth:self.expirationMonth expirationYear:self.expirationYear cardNumber:self.cardNumber cvc:self.cvcCode address:self.address completionHander:completionHandler];
}

@end