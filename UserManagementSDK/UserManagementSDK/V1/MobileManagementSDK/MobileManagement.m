//
//  MobileManagement.m
//  UserManagementSDK
//
//  Created by Lev T on 10/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import "MobileManagement.h"

@interface MobileManagement()
@property (retain, readwrite) NSString *SignCode;
@end

@implementation MobileManagement {
    NSString *_signCode;
}
@synthesize SignCode = _signCode;

static MobileManagement *_instance = nil;

-(id)init {
    self = [super init];
    if (self) {
        self.plistName = @"MobileManagementSetup";
    }
    return self;
}

+ (MobileManagement *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [MobileManagement new];
        }
    }
    return _instance;
}

- (void)sendGetJsonRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion {
    
    [self sendPostRequestWithParameters:params withMethod:method credentialsToken:nil responseSerializer:responseJSON callback:completion];
}

/************************************* LOGIN SECTION START *************************************/

-(void)loginWithEmail:(NSString*)email userName:(NSString*)userName password:(NSString*)password callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:email] || [self isEmptyOrNil:password] || [self isEmptyOrNil:userName]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    NSDictionary *params = @{
                             @"email" : email,
                             @"userName" : userName,
                             @"password" : password,
                             @"deviceId" : [self getDeviceID],
                             @"appVersion" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"Login" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse, store email, userName, merchantNumber for relogin, [self setLoginValues]
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)reloginWithPassword:(NSString*)password callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:password]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    //TO DO: get stored data, check it for nils
    NSString *merchantNumber = @"";
    NSString *email = @"";
    NSString *userName = @"";
    
    NSDictionary *params = @{
                             @"merchantNumber" : merchantNumber,
                             @"email" : email,
                             @"userName" : userName,
                             @"password" : password,
                             @"deviceId" : [self getDeviceID],
                             @"appVersion" : [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"Relogin" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse, [self setLoginValues] (+set signCode)
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)registerDeviceWithPhone:(NSString*)phoneNumber callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:phoneNumber]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    //TO DO: signed with @""
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"deviceId" : [self getDeviceID],
                             @"phoneNumber" : phoneNumber,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"RegisterDevice" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)activateDeviceWithCode:(NSString*)activationCode callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:activationCode]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    //TO DO: signed with activationCode
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"signature" : activationCode,
                             @"deviceId" : [self getDeviceID],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"ActivateDevice" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse, set signature to activationCode in case device is activated, save it locally
            [self setSignCode:activationCode];
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/************************************** LOGIN SECTION END **************************************/


/********************************** TRANSACTION SECTION START **********************************/

-(void)getTransaction:(long)transactionId callback:(void (^)(bool success, NSString* message))callback {
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             @"transactionId" : @(transactionId),
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetTransaction" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)getTransactionWithQrId:(NSString*)transactionQrId callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:transactionQrId]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"transQrId" : transactionQrId,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetTransWithQrId" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)getTransactionHistory:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSString* message))callback {
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"page" : @(page),
                             @"pageSize" : @(pageSize),
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetTransactionHistory" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/*********************************** TRANSACTION SECTION END ***********************************/


/************************************* OTHER SECTION START *************************************/

-(void)getQRCodeImageWithCallback:(void (^)(bool success, NSString* message))callback {
    //TO DO: signed with activationCode, hppParams
    
    /*XmlDictionary *params = [[XmlDictionary alloc] initWithRoot:@"GetQrCodeImage" xmlns:requestXmlNs];
    if ([transDetails QrCode] == nil) [transDetails setQrCode: [[NSUUID UUID] UUIDString] ];
    [params addValue:EmptyIfNull([self MerchantNumber]) forKey:@"merchantID"];
    [params addValue:EmptyIfNull([transDetails stringAmount]) forKey:@"trans_amount"];
    [params addValue:EmptyIfNull([transDetails Currency]) forKey:@"trans_currency"];
    [params addValue:[NSString stringWithFormat:@"%d", [transDetails TransType]] forKey:@"trans_type"];
    [params addValue:[NSString stringWithFormat:@"%d", [transDetails Installments]] forKey:@"trans_installments"];
    [params addValue:EmptyIfNull([transDetails Details]) forKey:@"disp_payFor"];
    if([transDetails ProductID]) {
        [params addValue:EmptyIfNull([NSString stringWithFormat:@"%d", [transDetails ProductID]]) forKey:@"public_itemId"];
        [params addValue:@"1" forKey:@"public_quantity"];
    }
    [params addValue:[transDetails QrCode] forKey:@"QrCodeID"];
    NSString *hppParams = [params getRequestString];
    [params release];*/
    NSString *hppParams = @"";
    
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             @"hppParams" : [self getNonNilValueForString:hppParams],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetQrCodeImage" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)getProductListWithCallback:(void (^)(bool success, NSString* message))callback {
    NSDictionary *params = @{ @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken], };
    
    //TO DO: isDemo
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetProductList" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)getSettingsWithCallback:(void (^)(bool success, NSString* message))callback {
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetSettings" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)keepAliveSession:(void (^)(bool success, id resultObject))callback {
    NSDictionary *params = @{ @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken], };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"KeepAlive" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(YES, resultObject);
        } else {
            if (callback) callback(NO, resultObject);
        }
    }];
}

-(void)serverLogWithSeverityId:(int)severityId longMessage:(NSString*)longMessage callback:(void (^)(bool success, NSString* message))callback {
    NSString *message = [NSString stringWithFormat:@"iPhone devId:%@ ver:%@", [self getDeviceID], [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    NSDictionary *params = @{
                             @"severityId" : @(severityId),
                             @"message" : [self getNonNilValueForString:message],
                             @"longMessage" : [self getNonNilValueForString:longMessage],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"Log" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(YES, resultObject);
        } else {
            if (callback) callback(NO, resultObject);
        }
    }];
}

/*-(void)sendPayment:(NetpayTransactionDetails*) transInfo callback:(void (^)(bool success, NSString* message))callback {
    
    <Process3 xmlns="http://netpay-intl.com/">
    <credentialsToken>string</credentialsToken>
    <signature>string</signature>
    <cardholderName>string</cardholderName>
    <transType>int</transType>
    <typeCredit>int</typeCredit>
    <creditcard>string</creditcard>
    <cvv>string</cvv>
    <expirationMonth>int</expirationMonth>
    <expirationYear>int</expirationYear>
    <currency>string</currency>
    <amount>string</amount>
    <payments>int</payments>
    <email>string</email>
    <personalNumber>string</personalNumber>
    <phone>string</phone>
    <track2>string</track2>
    <deviceId>string</deviceId>
    <payFor>string</payFor>
    <productId>int</productId>
    </Process3>
    
    [transInfo setTransID: 0];
    [transInfo setReplyCode: nil];
    [transInfo setReplyDesc: nil];
    [transInfo setTransDate: nil];
    if (![self IsLoogedIn]) [NSException raise:@"Wrong state" format:@"Should be logged in to use this method"];
    if ([self IsDemoMode]) {
        [transInfo setTransDate: [NSDate date]];
        if ([[transInfo Amount] isEqualToNumber:[NSNumber numberWithInt:2]]) {
            [transInfo setReplyCode: @"000"];
            [transInfo setTransID: -[[NSDate date] timeIntervalSince1970]];
        } else [transInfo setReplyCode: @"500"];
        [transInfo setReplyDesc: @"Demo mode transaction"];
        return YES;
    }
    NSString *trackII = [transInfo TrackII];
    //prepare request
    XmlDictionary *params = [[[XmlDictionary alloc] initWithRoot:@"Process3" xmlns:requestXmlNs] autorelease];
    [params addValue:EmptyIfNull(_credentialsToken) forKey:@"credentialsToken"];
    [params addValue:EmptyIfNull([transInfo FullName]) forKey:@"cardholderName"];
    [params addValue:[NSString stringWithFormat:@"%d", [transInfo TransType]] forKey:@"transType"];
    [params addValue:[NSString stringWithFormat:@"%d", [transInfo TypeCredit]] forKey:@"typeCredit"];
    [params addValue:EmptyIfNull([transInfo CardNumber]) forKey:@"creditcard"];
    [params addValue:EmptyIfNull([transInfo Cvv]) forKey:@"cvv"];
    [params addValue:[NSString stringWithFormat:@"%d", [transInfo ExpMonth]] forKey:@"expirationMonth"];
    [params addValue:[NSString stringWithFormat:@"%d", [transInfo ExpYear]] forKey:@"expirationYear"];
    [params addValue:EmptyIfNull([transInfo Currency]) forKey:@"currency"];
    [params addValue:[transInfo stringAmount] forKey:@"amount"];
    [params addValue:[NSString stringWithFormat:@"%d", [transInfo Installments]] forKey:@"payments"];
    [params addValue:EmptyIfNull([transInfo Email]) forKey:@"email"];
    [params addValue:EmptyIfNull([transInfo PersonalNumber]) forKey:@"personalNumber"];
    [params addValue:EmptyIfNull([transInfo PhoneNumber]) forKey:@"phone"];
    [params addValue:EmptyIfNull(trackII) forKey:@"track2"];
    [params addValue:[self getDeviceID] forKey:@"deviceId"];
    [params addValue:EmptyIfNull([transInfo Details]) forKey:@"payFor"];
    [params addValue:[NSString stringWithFormat:@"%d", [transInfo ProductID]] forKey:@"productId"];
    [params addSignature:_signCode paramName:@"signature"];
    
    XmlDictionary *doc = [self SendServiceRequest:params method:nil];
    if (!doc) return NO;
    if (![doc checkSignature:_signCode paramName:@"Signature"]) return NO;
    //parse result
    [transInfo setTransID: [[doc valueForKey:@"TransactionNumber"] intValue]];
    [transInfo setReplyCode: [doc valueForKey:@"ReplyCode"]];
    [transInfo setReplyDesc: [doc valueForKey:@"ReplyText"]];
    [transInfo setTransDate: [NSDate date]];
    
    if([[transInfo ReplyCode] isEqualToString:@"000"])
    {
        if([transInfo OwnerSign])
            [self SaveTransFile:[transInfo TransID] fileType:1 fileData:[transInfo OwnerSign]];
        if([transInfo OwnerImage])
            [self SaveTransFile:[transInfo TransID] fileType:2 fileData:[transInfo OwnerImage]];
    }
    return YES;
}*/

-(void)sendRefundForTransaction:(long)transactionId callback:(void (^)(bool success, NSString* message))callback {
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"transactionID" : @(transactionId),
                             @"deviceID" : [self getDeviceID],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"Refund" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)sendRefundRequestForTransaction:(long)transactionId transactionAmount:(float)amount comment:(NSString*)comment errorDesc:(NSString**)errorDesc callback:(void (^)(bool success, NSString* message))callback {
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"transactionID" : @(transactionId),
                             @"amount" : @(amount),
                             @"comment" : [self getNonNilValueForString:comment],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"RefundRequest" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)saveFileForTransaction:(long)transactionId fileType:(int)fileType fileData:(NSData*)fileData callback:(void (^)(bool success, NSString* message))callback {
    if (fileData == nil) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    NSString *base64DataString = [self base64forData:(const uint8_t*)[fileData bytes] length:[fileData length]];
    
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             @"transId" : @(transactionId),
                             @"fileType" : @(fileType),
                             @"fileData" : [self getNonNilValueForString:base64DataString],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"SaveTransImage" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

-(void)sendPaymentInvoiceToEmail:(NSString*)email transactionId:(long)transactionId callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:email]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             @"transactionID" : @(transactionId),
                             @"email" : email,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"SendEmail" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, resultObject);
        } else {
            if (callback) callback(NO, resultObject);
        }
    }];
}

-(void)sendPaymentInvoiceToPhone:(NSString*)phone transactionId:(long)transactionId merchantText:(NSString*)merchantText callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:phone]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service");
        return;
    }
    
    //TO DO: signed with activationCode, isDemo
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"signature" : [self getNonNilValueForString:_signCode],
                             @"transactionID" : @(transactionId),
                             @"phone" : phone,
                             @"merchantText" : [self getNonNilValueForString:merchantText],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"SendSms" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, resultObject);
        } else {
            if (callback) callback(NO, resultObject);
        }
    }];
}

-(void)sendPassCodeWithCallback:(void (^)(bool success, NSString* message))callback {
    NSDictionary *params = @{
                             @"credentialsToken" : [self getNonNilValueForString:self.credentialsToken],
                             @"deviceId" : [self getDeviceID],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"SendPassCode" callback:^(BOOL success, id resultObject) {
        if (success) {
            //TO DO: parse
            if (callback) callback(YES, resultObject);
        } else {
            if (callback) callback(NO, resultObject);
        }
    }];
}

/************************************** OTHER SECTION END **************************************/

-(NSString*)getDeviceID {
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSString* devId = [userdef objectForKey:@"DeviceID"];
    if (devId == nil) {
        devId = [[NSUUID UUID] UUIDString];
        [userdef setValue:devId forKey:@"DeviceID"];
        [userdef synchronize];
    }
    return devId;
}

-(NSString*)base64forData:(const uint8_t*)input length:(long)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) value |= (0xFF & input[j]);
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end