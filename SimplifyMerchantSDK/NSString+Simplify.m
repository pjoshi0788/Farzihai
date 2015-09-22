#import "NSString+Simplify.h"

@implementation NSString (Simplify)


+(NSString *)urlEncodedString:(NSString *)urlString {
    return [NSString urlEncodedString:urlString usingEncoding:NSUTF8StringEncoding];
}

+(NSString *)urlEncodedString:(NSString *)urlString usingEncoding:(NSStringEncoding)encoding {
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    
    NSString *encodedUrlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    return encodedUrlString;
}


+(NSString *)amountStringFromNumber:(NSDecimalNumber *)amount {
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setMinimumFractionDigits:2];
    [numberFormatter setMaximumFractionDigits:2];
    [numberFormatter setMinimumIntegerDigits:1];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    return [numberFormatter stringFromNumber:amount];
}


@end
