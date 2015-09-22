#import "SIMDigitVerifier.h"

@implementation SIMDigitVerifier

-(BOOL)isDigit:(NSString *)potentialStringOfDigits {
    BOOL isDigit = NO;
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([potentialStringOfDigits rangeOfCharacterFromSet:notDigits].location == NSNotFound) {
        isDigit = YES;
    }
    return isDigit;
}

@end
