//
//  ViewController.m
//  UserManagementSDK
//
//  Created by Lev T on 29/01/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import "ViewController.h"
#import "AccountSDK.h"
#import "BalanceSDK.h"
#import "InternationalSDK.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(IBAction)click0 {
    //blablabla1@sapdan.com - 1019958
    //blablabla@sapdan.com - 4399633
    //sdk@test.test - 2647597
    
    //[[AccountSDK getInstance] loginWithEmail:@"blablabla1@sapdan.com" userName:nil password:@"aaa111aaa"
    //[[AccountSDK getInstance] loginWithEmail:@"blablabla@sapdan.com" userName:nil password:@"aaa111aaa"
    [[AccountSDK getInstance] loginWithEmail:@"sdk@test.test" userName:nil password:@"bbcc1122"
                                     appName:@"" deviceId:@"" pushToken:@"" setCookie:NO
                                    callback:^(BOOL success, LoginResult *result, NSString *message) {
        if (success) {
            NSLog(@"Success");
        } else {
            NSLog(@"%@",message);
        }
    }];
}

-(IBAction)click1 {
    [[AccountSDK getInstance] logOff:^(BOOL success, NSString *message) {
        if (success) {
            NSLog(@"Success");
        } else {
            NSLog(@"%@",message);
        }
    }];
}

/************** TEST METHODS **************/

-(IBAction)click2 {
}

-(IBAction)click3 {
}

-(IBAction)click4 {
}

-(IBAction)click5 {
}

-(IBAction)click6 {
}

-(IBAction)click7 {
}

-(IBAction)click8 {
}

-(IBAction)click9 {
}

-(IBAction)click10 {
}

-(IBAction)click11 {
}

-(IBAction)click12 {
}

-(IBAction)click13 {
}

@end

//@"5722306" - merchant
//649 - product
//Always empty!!!
/*[[ShopSDKShops getInstance] getProductsOnPage:1 pageSize:10 categories:nil countries:nil includeGlobalRegion:YES language:@"EN" merchantGroups:nil merchantId:nil name:nil promoOnly:NO regions:nil shopId:0 tags:nil callback:^(bool success, NSMutableArray *products, NSString *message) {
 if (success) {
 NSLog(@"Success");
 } else {
 NSLog(@"%@",message);
 }
 }];*/


/*[[CustomerSDKCustomers getInstance] registerUserWithPassword:@"aaa111aaa" pinCode:@"1234" name:@"Test" surname:@"Tests" email:@"lev@levtestmail.com" addressLine1:nil addressLine2:nil city:nil countryIso:nil postalCode:nil stateIso:nil cellNumber:nil birthDate:nil personalNumber:nil phoneNumber:@"45454545" profileImage:nil callback:^(BOOL success, NSString *message) {
 if (success) {
 NSLog(@"Success");
 } else {
 NSLog(@"%@",message);
 }
 }];*/


/*[[ShopSDKShops getInstance] getMerchantWithId:@"5722306" callback:^(bool success, Merchant *merchant, NSString *message) {
 if (success) {
 NSLog(@"Success");
 } else {
 NSLog(@"%@",message);
 }
 }];*/
