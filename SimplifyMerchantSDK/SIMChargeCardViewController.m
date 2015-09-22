#import "SIMChargeCardViewController.h"
#import "SIMChargeCardModel.h"
#import "UIColor+Simplify.h"
#import "UIImage+Simplify.h"
#import "NSBundle+Simplify.h"
#import "NSString+Simplify.h"
#import "SIMResponseViewController.h"

@interface SIMChargeCardViewController () <SIMChargeCardModelDelegate, UITextFieldDelegate, PKPaymentAuthorizationViewControllerDelegate>
@property (strong, nonatomic) SIMChargeCardModel *chargeCardModel;
@property (strong, nonatomic) NSString *publicKey;
@property (strong, nonatomic) NSError *modelError;
@property (strong, nonatomic) PKPaymentRequest *paymentRequest;
@property (strong, nonatomic) UIColor *primaryColor;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UIButton *submitPaymentButton;

@property (strong, nonatomic) IBOutlet UITextField *expirationField;
@property (strong, nonatomic) IBOutlet UITextField *cvcField;
@property (strong, nonatomic) IBOutlet UITextField *zipField;
@property (strong, nonatomic) IBOutlet UIImageView *cardTypeImage;
@property (strong, nonatomic) IBOutlet UIView *cvcCodeView;
@property (strong, nonatomic) IBOutlet UIView *cardNumberView;
@property (strong, nonatomic) IBOutlet UIView *expirationDateView;
@property (strong, nonatomic) IBOutlet UIView *applePayViewHolder;
@property (strong, nonatomic) IBOutlet UIView *cardEntryView;
@property (strong, nonatomic) IBOutlet UIView *zipCodeView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cardEntryViewTopConstraint;
@property (strong, nonatomic) IBOutlet UILabel *headerTitle;

@end

@implementation SIMChargeCardViewController

-(instancetype)initWithPublicKey:(NSString *)publicKey {
    return [self initWithPublicKey:publicKey primaryColor:nil];
}

-(instancetype)initWithPublicKey:(NSString *)publicKey primaryColor:(UIColor *)primaryColor {
    return [self initWithPublicKey:publicKey paymentRequest:nil primaryColor:primaryColor];
}

-(instancetype)initWithPublicKey:(NSString *)publicKey paymentRequest:(PKPaymentRequest *)paymentRequest {
    return [self initWithPublicKey:publicKey paymentRequest:paymentRequest primaryColor:nil];
}

-(instancetype)initWithPublicKey:(NSString *)publicKey paymentRequest:(PKPaymentRequest *)paymentRequest primaryColor:(UIColor *)primaryColor {
    self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle frameworkBundle]];
    if (self) {
        self.publicKey = publicKey;
        self.primaryColor = primaryColor ? primaryColor : [UIColor buttonBackgroundColorEnabled];
        self.paymentRequest = paymentRequest;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    return  self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardNumberField.delegate = self;
    self.expirationField.delegate = self;
    self.cvcField.delegate = self;
    self.zipField.delegate = self;
    
    self.cardNumberField.text = @"5204 7400 0990 0014";
    self.cardNumberField.tintColor = self.primaryColor;
    self.expirationField.tintColor = self.primaryColor;
    self.cvcField.tintColor = self.primaryColor;
    self.zipField.tintColor = self.primaryColor;
    
    NSError *error;
    self.chargeCardModel = [[SIMChargeCardModel alloc] initWithPublicKey:self.publicKey error:&error];
    self.chargeCardModel.isZipRequired = self.isZipRequired;
    self.chargeCardModel.isCVCRequired = self.isCVCRequired;
    self.chargeCardModel.paymentRequest = self.paymentRequest;
    
    if (error) {
        self.modelError = error;
    } else {
        self.chargeCardModel.delegate = self;

        [self setCardTypeImage];
        [self.submitPaymentButton setBackgroundColor:[UIColor buttonBackgroundColorDisabled]];
        [self.cardNumberField becomeFirstResponder];
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Remove the Apple Pay button if there is no PKPaymentRequest or if the device is not capable of doing Apple Pay
    if (![self.chargeCardModel isApplePayAvailable]) {
        
        [self.applePayViewHolder removeFromSuperview];
        self.cardEntryViewTopConstraint.constant = 15.0;
    }
    
    [self changeTitle:self.amount];

}

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    if (self.modelError) {

        SIMResponseViewController *viewController = [[SIMResponseViewController alloc] initWithBackground:nil primaryColor:self.primaryColor title:@"Failure." description:@"\n\nThere was a problem with your Public Key.\n\nPlease double-check your Public Key and try again."];
        
        viewController.isPaymentSuccessful = NO;
        [self presentViewController:viewController animated:YES completion:nil];
    }
    
}

- (void)changeTitle:(NSDecimalNumber *)amount {
    if (amount) {
        self.headerTitle.text = [NSString stringWithFormat:@"Charge $%@", [NSString amountStringFromNumber:amount]];
    } else {
        self.headerTitle.text = @"Charge Card";
    }
}

-(void)setAmount:(NSDecimalNumber *)amount {
    _amount = amount;
    
    [self changeTitle:amount];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)displayPaymentValidity {
    
    self.cardNumberView.backgroundColor = [self.chargeCardModel isCardNumberValid] ? [UIColor fieldBackgroundColorValid] : [UIColor fieldBackgroundColorInvalid];
    
    self.expirationDateView.backgroundColor = [self.chargeCardModel isExpirationDateValid] ? [UIColor fieldBackgroundColorValid] : [UIColor fieldBackgroundColorInvalid];

    self.cvcCodeView.backgroundColor = [self.chargeCardModel isCVCCodeValid] ? [UIColor fieldBackgroundColorValid] : [UIColor fieldBackgroundColorInvalid];

    self.zipCodeView.backgroundColor = [self.chargeCardModel isZipCodeValid] ? [UIColor fieldBackgroundColorValid] : [UIColor fieldBackgroundColorInvalid];

    
    BOOL isEnabled = [self.chargeCardModel isCardChargePossible];
    [self.submitPaymentButton setEnabled:isEnabled];
    
    if (isEnabled) {
        [self.submitPaymentButton setBackgroundColor:self.primaryColor ? self.primaryColor : [UIColor buttonBackgroundColorEnabled]];
    } else {
        [self.submitPaymentButton setBackgroundColor:[UIColor buttonBackgroundColorDisabled]];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSUInteger fieldLength = string.length;
    
    if (textField == self.cardNumberField) {

        if (fieldLength) {
            [self.chargeCardModel updateCardNumberWithString:newString];

            if ([self.chargeCardModel isCardNumberValid]) {
                [self.expirationField becomeFirstResponder];
            }
            
        } else {
            [self.chargeCardModel deleteCharacterInCardNumber];
        }
        
        self.cardNumberField.text = self.chargeCardModel.formattedCardNumber;
        [self setCardTypeImage];
        
    } else if (textField == self.expirationField) {
        
        if (fieldLength) {
            [self.chargeCardModel updateExpirationDateWithString:newString];
        } else {
            [self.chargeCardModel deleteCharacterInExpiration];
        }

        self.expirationField.text = self.chargeCardModel.formattedExpirationDate;
        
        if ([self.chargeCardModel isExpirationDateValid]) {
            [self.cvcField becomeFirstResponder];
        }
        

    } else if (textField == self.cvcField) {

        [self.chargeCardModel updateCVCNumberWithString:newString];
        self.cvcField.text = self.chargeCardModel.cvcCode;
        
        if ([self.chargeCardModel isCVCCodeValid]) {
            [self.zipField becomeFirstResponder];
        }
        
    } else if (textField == self.zipField) {

        [self.chargeCardModel updateZipCodeWithString:newString];
        self.zipField.text = self.chargeCardModel.zipCode;
    }
    
    [self displayPaymentValidity];

    return NO;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField {
    
    if (textField == self.cardNumberField) {
        [self.chargeCardModel updateCardNumberWithString:@""];
        [self setCardTypeImage];
    }
    
    else if (textField == self.cvcField) {
        [self.chargeCardModel updateCVCNumberWithString:@""];
    }
    
    else if (textField == self.expirationField) {
        [self.chargeCardModel updateExpirationDateWithString:@""];
    }
    
    [self displayPaymentValidity];
    
    return YES;
}

-(void)setCardTypeImage {
    
    UIImage *cardImage = [UIImage imageNamed:self.chargeCardModel.cardTypeString inBundle:[NSBundle frameworkBundle] compatibleWithTraitCollection:nil];
    [self.cardTypeImage setImage:cardImage];
}

- (IBAction)cancelTokenRequest:(id)sender {
    [self clearTextFields];

    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate chargeCardCancelled];
    }];
}

-(IBAction)retrieveToken:(id)sender {
    [self.chargeCardModel retrieveToken];
}

-(IBAction)retriveApplePayToken:(id)sender {
    if (self.chargeCardModel.paymentRequest) {
        PKPaymentAuthorizationViewController *pavc = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:self.chargeCardModel.paymentRequest];
        pavc.delegate = self;
        [self presentViewController:pavc animated:YES completion:nil];
    }
}

-(void) clearTextFields {
    [self.chargeCardModel updateCardNumberWithString:@""];
    [self.chargeCardModel updateCVCNumberWithString:@""];
    [self.chargeCardModel updateExpirationDateWithString:@""];
    self.cardNumberField.text = self.chargeCardModel.formattedCardNumber;
    self.cvcField.text = self.chargeCardModel.cvcCode;
    self.expirationField.text = self.chargeCardModel.formattedExpirationDate;
    [self setCardTypeImage];
    [self displayPaymentValidity];
}

- (void) dismissKeyboard {
    [self.cardNumberField resignFirstResponder];
    [self.expirationField resignFirstResponder];
    [self.cvcField resignFirstResponder];
}

#pragma mark SIMChargeCardModelDelegate callback methods
- (void)tokenFailedWithError:(NSError *)error {
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self clearTextFields];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate creditCardTokenFailedWithError:error];
            
        }];
        
    });

}

-(void)tokenProcessed:(SIMCreditCardToken *)token {

        dispatch_sync(dispatch_get_main_queue(), ^{
            [self clearTextFields];
            [self dismissKeyboard];
            [self dismissViewControllerAnimated:YES completion:^{
                
                [self.delegate creditCardTokenProcessed:token];
            }];
            
        });
}

#pragma mark PKPaymentAuthorizationViewControllerDelegate
-(void) paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion {
    NSError *error = nil;
    SIMSimplify* simplify = [[SIMSimplify alloc] initWithPublicKey:self.publicKey error:&error];

    if (error) {
        completion(PKPaymentAuthorizationStatusFailure);
    } else {
        
        [simplify createCardTokenWithPayment:payment completionHandler:^(SIMCreditCardToken *cardToken, NSError *error)
         {
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 
                 [controller dismissViewControllerAnimated:YES completion:^{
                     
                     [self dismissViewControllerAnimated:YES completion:^{
                         if (error) {
                             completion(PKPaymentAuthorizationStatusFailure);
                             [self.delegate creditCardTokenFailedWithError:error];
                         } else {
                             completion(PKPaymentAuthorizationStatusSuccess);
                             [self.delegate creditCardTokenProcessed:cardToken];
                         }
                     }];
                 }];
             });
         }];
    }
}

-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
