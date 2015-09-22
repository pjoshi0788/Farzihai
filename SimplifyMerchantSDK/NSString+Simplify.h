@interface NSString (Simplify)

/**
 Converts a string to it's URL-compatible counterpart
 @return URL-encoded string encoded by NSUTF8StringEncoding
 */
+(NSString *)urlEncodedString:(NSString *)urlString;

/**
 Converts a string to a URL-compatible string.  For example, a string is not a valid URL character so it has to be converted to its URL-compatible counterpart
 @param urlString is the string to be checked to see if all characters are valid URL characters
 @param encoding  should be NSUTF8StringEncoding to verify if the input string is URL-compatible
 @return a string that is URL-compatible
 */
+(NSString *)urlEncodedString:(NSString *)urlString usingEncoding:(NSStringEncoding)encoding;

+(NSString *)amountStringFromNumber:(NSDecimalNumber *)amount;

@end
