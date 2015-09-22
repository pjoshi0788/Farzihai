#import "SIMTokenProcessor.h"
#import <AddressBook/ABPerson.h>

@interface SIMTokenProcessor()

@end

@implementation SIMTokenProcessor


+(NSData *) formatDataForRequestWithKey:(NSString *)publicKey withPayment:(PKPayment *)payment error:(NSError *)error
{
    ABRecordRef ref = [payment billingAddress];
    
    NSString *cardHolderName = [[NSString alloc] initWithFormat:@"%@ %@", (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty)), (__bridge NSString *)ABRecordCopyValue(ref, kABPersonLastNameProperty)];
    NSObject *paymentTokenData = [NSJSONSerialization JSONObjectWithData:[[payment token] paymentData] options:kNilOptions error:&error];
    
    NSDictionary *dict = @{
                           @"key" : publicKey,
                           @"card" : @{
                                   @"cardEntryMode" : @"APPLE_PAY_IN_APP",
                                   @"applePayData" : @{ @"paymentToken" : paymentTokenData},
                                   @"name" : cardHolderName
                                   }
                           };
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:&error];
    return jsonData;
}

@end