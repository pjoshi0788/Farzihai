#import "SIMCardType.h"

@interface SIMCardType ()
@property (nonatomic, strong, readwrite) NSString *cardTypeString;
@property (nonatomic, readwrite) int CVCLength;
@property (nonatomic, readwrite) int minCardLength;
@property (nonatomic, readwrite) int maxCardLength;
@end

@implementation SIMCardType

-(instancetype)init {
	if (self = [super init]) {
        self.cardTypeString = @"blank";
        self.CVCLength = 4;
        self.minCardLength = 13;
        self.maxCardLength = 19;
	}
	return self;
}

+(instancetype)cardTypeFromCardNumberString:(NSString *)cardNumber {
    SIMCardType *cardType = [SIMCardType new];
    NSString *cardNumberString = [[cardNumber componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    cardType.CVCLength = 3;
    if ([cardNumber isEqualToString:cardNumberString]) {
        if ([self hasPrefixFromArray:@[@"34", @"37"] inString:cardNumberString]) {
            cardType.cardTypeString =  @"amex";
            cardType.CVCLength = 4;
            cardType.minCardLength = 15;
            cardType.maxCardLength = 15;
        } else if ([self hasPrefixFromArray:@[@"622", @"624", @"625", @"626", @"628"] inString:cardNumberString]) {
            cardType.cardTypeString =  @"china-union";
            cardType.minCardLength = 16;
            cardType.maxCardLength = 19;
        } else if ([self hasPrefixFromArray:@[@"300", @"301", @"302", @"303", @"304", @"305", @"309", @"36", @"38", @"39"] inString:cardNumberString]) {
            cardType.cardTypeString =  @"diners";
            cardType.minCardLength = 14;
            cardType.maxCardLength = 16;
        } else if ([self hasPrefixFromArray:@[@"65", @"6011", @"644", @"645", @"646", @"647", @"648", @"649"] inString:cardNumberString]) {
            cardType.cardTypeString =  @"discover";
            cardType.minCardLength = 16;
            cardType.maxCardLength = 16;
        } else if ([self hasPrefixFromArray:@[@"3528", @"3529", @"353", @"354", @"355", @"356", @"357", @"358"] inString:cardNumberString]) {
            cardType.cardTypeString =  @"jcb";
            cardType.minCardLength = 16;
            cardType.maxCardLength = 16;
        } else if ([self hasPrefixFromArray:@[@"51", @"52", @"53", @"54", @"55", @"67"] inString:cardNumberString]) {
            cardType.cardTypeString =  @"mastercard";
            cardType.minCardLength = 16;
            cardType.maxCardLength = 16;
        } else if ([cardNumberString hasPrefix:@"4"]) {
            cardType.cardTypeString =  @"visa";
            cardType.minCardLength = 13;
            cardType.maxCardLength = 19;
        } else {
            cardType.cardTypeString = @"blank";
            cardType.CVCLength = 4;
            cardType.minCardLength = 13;
            cardType.maxCardLength = 19;
        }
    }else {
        cardType.cardTypeString = @"blank";
        cardType.CVCLength = 4;
        cardType.minCardLength = 13;
        cardType.maxCardLength = 19;
    }
    
    //Source for Amex: https://secure.cmax.americanexpress.com/Internet/International/japa/SG_en/Merchant/PROSPECT/WorkingWithUs/AvoidingCardFraud/HowToCheckCardFaces/Files/Guide_to_checking_Card_Faces.pdf
    //Source for China Union, Diners Club, Discover, JCB: http://www.discovernetwork.com/merchants/images/Merchant_Marketing_PDF.pdf
    //Source for MasterCard: http://www.mastercard.com/hu/merchant/PDF/ADC.pdf - 2-6
    //Source for Visa: http://usa.visa.com/download/merchants/card-security-features-mini-vcp-111512.pdf
    
    return cardType;
}


+(BOOL)hasPrefixFromArray:(NSArray *)prefixArray inString:(NSString *)cardString {
    for (NSString* prefix in prefixArray ) {
        if ( [cardString hasPrefix:prefix] ) {
            return YES;
        }
    }
    return NO;
}
@end
