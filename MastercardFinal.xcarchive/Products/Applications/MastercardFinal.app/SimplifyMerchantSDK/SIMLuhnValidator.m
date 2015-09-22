#import "SIMLuhnValidator.h"
#import "SIMDigitVerifier.h"
@implementation SIMLuhnValidator

-(BOOL)luhnValidateString:(NSString *)cardNumberString {
    SIMDigitVerifier *digitVerifier = [SIMDigitVerifier new];
    NSString *cardNumberStringWithoutSpaces = [cardNumberString stringByReplacingOccurrencesOfString:@" " withString:@""];

    if ([digitVerifier isDigit:cardNumberStringWithoutSpaces]) {
        
        int oddSum = 0;
        int evenSum = 0;
        int initialValue = (int)cardNumberStringWithoutSpaces.length - 1;
        
        BOOL isOdd = YES;
        
        for (int i = initialValue; i >= 0; i--) {
        
            int digit = (int)([cardNumberStringWithoutSpaces characterAtIndex:i] - '0');
            
            if (isOdd) {
                oddSum += digit;
            } else {
                evenSum += digit / 5 + (2 * digit) % 10;
            }
            
            isOdd = !isOdd;
        }
        
        int totalSum = oddSum + evenSum;
        
        return (totalSum % 10 == 0);
    }
    return NO;
}

@end
