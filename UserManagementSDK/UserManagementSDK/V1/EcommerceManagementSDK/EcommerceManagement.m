//
//  EcommerceManagement.m
//  UserManagementSDK
//
//  Created by Lev T on 03/02/16.
//  Copyright © 2016 Sapdan. All rights reserved.
//

#import "EcommerceManagement.h"
#import "UserManagement.h"
#import "PropertyOld.h"
#import "StockOld.h"
#import "CartOld.h"
#import "CartItemOld.h"
#import "ProductCategoryOld.h"

@implementation EcommerceManagement

static EcommerceManagement *_instance = nil;

-(id)init {
    self = [super init];
    if (self) {
        self.plistName = @"EcommerceManagementSetup";
    }
    return self;
}

+ (EcommerceManagement *)getInstance {
    @synchronized(self) {
        if (_instance == nil) {
            _instance = [EcommerceManagement new];
        }
    }
    return _instance;
}

- (void)sendGetJsonRequestWithParameters:(NSDictionary *)params withMethod:(NSString *)method callback:(void (^)(BOOL success, id resultObject))completion {
    
    [self sendPostRequestWithParameters:params withMethod:method credentialsToken:[UserManagement getInstance].credentialsToken responseSerializer:responseJSON callback:completion];
}

/************************************ PRODUCTS SECTION START ************************************/

- (void)getProductWithId:(long)productId callback:(void (^)(bool success, ProductOld *product, NSString* message))callback {
    NSDictionary *params = @{
                             @"merchantNumber": @"",
                             @"itemId": @(productId),
                             @"language": @"Unknown",
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetProduct" callback:^(BOOL success, id resultObject) {
        if (success) {            
            NSDictionary *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                ProductOld *product = [self parseProduct:result];
                if (callback) callback(YES, product, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong or product with this id doesn't exist");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getProductsOnPage:(int)page pageSize:(int)pageSize categories:(NSArray*)categories merchantGroups:(NSArray*)merchantGroups merchantId:(NSString*)merchantId text:(NSString*)text promoOnly:(BOOL)promoOnly callback:(void (^)(bool success, NSMutableArray *products, NSString* message))callback {
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setValue:@(promoOnly) forKey:@"PromoOnly"];
    [filters setValue:@"Unknown" forKey:@"Language"];
    if (text != nil && ![text isEqualToString:@""])
        [filters setValue:text forKey:@"Text"];
    if (merchantId != nil && ![merchantId isEqualToString:@""])
        [filters setValue:merchantId forKey:@"MerchantNumber"];
    if (categories!=nil && categories.count > 0)
        [filters setValue:categories forKey:@"Categories"];
    if (merchantGroups!=nil && merchantGroups.count > 0)
        [filters setValue:merchantGroups forKey:@"MerchantGroups"];
    
    NSDictionary *params = @{
                             @"page": @(page),
                             @"pageSize": @(pageSize),
                             @"filters": filters,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetProducts" callback:^(BOOL success, id resultObject) {
        if (success) {             
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray *products = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *productDictionary in result) {
                    ProductOld *product = [self parseProduct:productDictionary];
                    [products addObject:product];
                }
                if (callback) callback(YES, products, nil);
            } else {
                if (callback) callback(YES, products, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getNextProductForMerchantWithNumber:(NSString*)merchantNumber productId:(long)productId callback:(void (^)(bool success, NSInteger productId, NSString* message))callback {
    [self getProductWithMethod:@"GetNextProductId" merchantNumber:merchantNumber productId:productId callback:callback];
}

- (void)getPrevProductForMerchantWithNumber:(NSString*)merchantNumber productId:(long)productId callback:(void (^)(bool success, NSInteger productId, NSString* message))callback {
    [self getProductWithMethod:@"GetPrevProductId" merchantNumber:merchantNumber productId:productId callback:callback];
}

- (void)getProductWithMethod:(NSString*)method merchantNumber:(NSString*)merchantNumber productId:(long)productId callback:(void (^)(bool success, NSInteger productId, NSString* message))callback {
    if ([self isEmptyOrNil:merchantNumber]) {
        if (callback) callback(NO, 0, @"Attempt to send an empty value to the service.");
    }
    
    NSDictionary *params = @{
                             @"merchantNumber": merchantNumber,
                             @"productId": @(productId),
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:method callback:^(BOOL success, id resultObject) {
        if (success) {
            NSInteger productId = [[self getObject:@"d" from:resultObject] integerValue];
            if (callback) callback(YES, productId, nil);
        } else {
            if (callback) callback(NO, 0, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/************************************* PRODUCTS SECTION END *************************************/


/************************************ MERCHANT SECTION START ************************************/

- (void)getMerchantWithId:(NSString*)merchantNumber callback:(void (^)(bool success, MerchantOld* merchant, NSString* message))callback {
    if (merchantNumber == nil) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service.");
    }
    
    NSDictionary *params = @{ @"merchantNumber": merchantNumber, };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetMerchant" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *merchantDict = [self getObject:@"d" from:resultObject];
            if (merchantDict != nil) {
                MerchantOld *merchant = [self parseMerchant:merchantDict];
                if (callback) callback(YES, merchant, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong or there is no such merchant");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)sendEmailToMerchantWithId:(NSString*)merchantNumber from:(NSString*)from withSubject:(NSString*)subject andBody:(NSString*)body callback:(void (^)(bool success, NSString* message))callback {
    
    if ([self isEmptyOrNil:merchantNumber] || [self isEmptyOrNil:from] || [self isEmptyOrNil:subject] || [self isEmptyOrNil:body]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service.");
    }
    
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"merchantNumber": merchantNumber,
                             @"from": from,
                             @"subject": subject,
                             @"body": body,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"SendMerchantContactEmail" callback:^(BOOL success, id resultObject) {
        if (success) {
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getCategoriesForMerchantWithId:(NSString*)merchantNumber callback:(void (^)(bool success, NSArray* categories, NSString* message))callback {
    if (merchantNumber == nil) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service.");
    }
    
    NSDictionary *params = @{ @"merchantNumber": merchantNumber, };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetMerchantCategories" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            if (result != nil) {
                NSMutableArray *categories = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in result) {
                    ProductCategoryOld *category = [self parseCategory:dict];
                    [categories addObject:category];
                }
                if (callback) callback(YES, categories, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getContentForMerchantWithId:(NSString*)merchantNumber contentName:(NSString*)contentName callback:(void (^)(bool success, NSString* message))callback {
    if ([self isEmptyOrNil:merchantNumber] || [self isEmptyOrNil:contentName]) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service.");
    }
    
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"merchantNumber": merchantNumber,
                             @"language": @"Unknown",
                             @"contentName": contentName,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetMerchantContent" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             add issuccess/message check
             parse and modify callback **/
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getMerchantsWithGroupID:(long)groupId text:(NSString*)text status:(merchantStatus)status callback:(void (^)(bool success, NSMutableArray *merchants, NSString* message))callback {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[self getAppToken] forKey:@"ApplicationToken"];
    if (groupId != 0) [params setObject:@(groupId) forKey:@"GroupId"];
    if (text != nil && ![text isEqualToString:@""]) [params setObject:text forKey:@"Text"];
    if (status != statusAll) {
        NSInteger statusLong = 0;
        switch (status) {
            case statusArchived: statusLong = 0; break;
            case statusNew: statusLong = 1; break;
            case statusBlocked: statusLong = 2; break;
            case statusClosed: statusLong = 3; break;
            case statusLoginOnly: statusLong = 10; break;
            case statusIntegration: statusLong = 20; break;
            case statusProcessing: statusLong = 30; break;
            default: break;
        }
        [params setObject:@(statusLong) forKey:@"MerchantStatus"];
    }
    
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setObject:params forKey:@"filters"];
    
    [self sendGetJsonRequestWithParameters:filters withMethod:@"GetMerchants" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray *merchants = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *merchantDictionary in result) {
                    MerchantOld *merchant = [self parseMerchant:merchantDictionary];
                    [merchants addObject:merchant];
                }
                if (callback) callback(YES, merchants, nil);
            } else {
                if (callback) callback(YES, merchants, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/************************************* MERCHANT SECTION END *************************************/


/************************************ DOWNLOAD SECTION START ************************************/

- (void)getDownloadsOnPage:(int)page pageSize:(int)pageSize callback:(void (^)(bool success, NSMutableArray *downloads, NSString* message))callback {
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"walletCredentials": [self getNonNilValueForString:[UserManagement getInstance].credentialsToken],
                             @"page": @(page),
                             @"pageSize": @(pageSize),
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetDownloads" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             add issuccess/message check
             test with non-nil list **/
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray *cartItems = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *itemDict in result) {
                    CartItemOld *item = [self parseCartItem:itemDict];
                    [cartItems addObject:item];
                }
                if (callback) callback(YES, cartItems, nil);
            } else {
                if (callback) callback(YES, cartItems, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)downloadItemWithId:(int)itemId asPlainData:(BOOL)asPlainData callback:(void (^)(bool success, NSString* message))callback {
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"walletCredentials": [self getNonNilValueForString:[UserManagement getInstance].credentialsToken],
                             @"itemId": @(itemId),
                             @"asPlainData": @(asPlainData),
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"Download" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             explanations
             allow different asPlainData?
             add issuccess/message check
             parse and modify callback **/
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/************************************* DOWNLOAD SECTION END *************************************/


/************************************** CART SECTION START **************************************/

- (CartOld*)createNewCartForMerchant:(NSString*)merchantId currencyIso:(NSString*)currencyIso {
    CartOld *cart = [CartOld new];
    cart.cartCookie = nil;
    cart.cartCurrencyIso = currencyIso;
    cart.merchant = [MerchantOld new];
    cart.merchant.number = merchantId;
    return cart;
}

- (void)getActiveCarts:(void (^)(bool success, NSMutableArray *carts, NSString* message))callback {
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"walletCredentials": [self getNonNilValueForString:[UserManagement getInstance].credentialsToken] ,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetActiveCarts" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSArray *result = [self getObject:@"d" from:resultObject];
            NSMutableArray *carts = [[NSMutableArray alloc] init];
            if (result != nil) {
                for (NSDictionary *cartDictionary in result) {
                    CartOld *cart = [self parseCart:cartDictionary];
                    [carts addObject:cart];
                }
                if (callback) callback(YES, carts, nil);
            } else {
                if (callback) callback(YES, carts, nil);
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)updateCart:(CartOld*)cart callback:(void (^)(bool success, NSString* message))callback {
    if (cart == nil) {
        if (callback) callback(NO, @"Attempt to send an empty value to the service.");
    }
    if (cart.merchant == nil) {
        if (callback) callback(NO, @"Wrong merchant");
    }
    
    if (cart.shopCartItems == nil) cart.shopCartItems = [[NSMutableArray alloc] init];
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    for (CartItemOld *item in cart.shopCartItems) {        
        NSDictionary *shopCartItem = [[NSMutableDictionary alloc] init];
        [shopCartItem setValue:@([item.itemProductId intValue]) forKey:@"ProductId"];
        if (item.itemProductStockId > 0)
            [shopCartItem setValue:@(item.itemProductStockId) forKey:@"ProductStockId"];
        else
            [shopCartItem setValue:[NSNull null] forKey:@"ProductStockId"];
        [shopCartItem setValue:@([item.itemQuantity intValue]) forKey:@"Quantity"];
        [shopCartItem setValue:@([item.itemPrice doubleValue]) forKey:@"Price"];
        
        [itemsArray addObject:shopCartItem];
    }
    
    NSDictionary *cartPart = [[NSMutableDictionary alloc] init];
    if (cart.cartCookie != nil)
        [cartPart setValue:cart.cartCookie forKey:@"Cookie"];
    [cartPart setValue:itemsArray forKey:@"Items"];
    [cartPart setValue:cart.cartCurrencyIso forKey:@"CurrencyIso"];
    [cartPart setValue:cart.merchant.number forKey:@"MerchantNumber"];
    
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"cart": cartPart,
                             @"walletCredentials": [self getNonNilValueForString:[UserManagement getInstance].credentialsToken],
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"SetCart" callback:^(BOOL success, id resultObject) {
        if (success) {
            if ([self getObject:@"d" from:resultObject] != nil) {
                if (callback) callback(YES, nil);
            } else {
                if (callback) callback(NO, @"Something went wrong or cart wasn't found");
            }
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getCartWithCookie:(NSString*)cartCookie callback:(void (^)(bool success, CartOld* cart, NSString* message))callback {
    if ([self isEmptyOrNil:cartCookie]) {
        if (callback) callback(NO, nil, @"Attempt to send an empty value to the service.");
    }
    
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"cookie": cartCookie,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetCart" callback:^(BOOL success, id resultObject) {
        if (success) {
            NSDictionary *cartDict = [self getObject:@"d" from:resultObject];
            if (cartDict != nil) {
                CartOld *cart = [self parseCart:cartDict];
                if (callback) callback(YES, cart, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong or there is no such cart");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getCartWithTransaction:(long)transactionId callback:(void (^)(bool success, CartOld* cart, NSString* message))callback {
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"walletCredentials": [self getNonNilValueForString:[UserManagement getInstance].credentialsToken],
                             @"transactionId": @(transactionId),
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetCartOfTransaction" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             test with real cart transaction **/
            NSDictionary *cartDict = [self getObject:@"d" from:resultObject];
            if (cartDict != nil) {
                CartOld *cart = [self parseCart:cartDict];
                if (callback) callback(YES, cart, nil);
            } else {
                if (callback) callback(NO, nil, @"Something went wrong or there is no such cart");
            }
        } else {
            if (callback) callback(NO, nil, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/*************************************** CART SECTION END ***************************************/


/************************************** SHOPS SECTION START *************************************/

- (void)getShopWithId:(long)shopId merchantNumber:(NSString*)merchantNumber callback:(void (^)(bool success, NSString* message))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (shopId != 0) [params setValue:@(shopId) forKey:@"shopId"];
    if (merchantNumber != nil) [params setValue:merchantNumber forKey:@"merchantNumber"];
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetShop" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             add to *.h
             explanations
             parse and modify callback **/
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getShopIds:(NSString*)subDomainName imageHeight:(long)imageHeight callback:(void (^)(bool success, NSString* message))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (subDomainName != nil) [params setValue:subDomainName forKey:@"subDomainName"];
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetShopIds" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             add to *.h
             explanations
             parse and modify callback **/
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

- (void)getShops:(NSString*)merchantNumber culture:(NSString*)culture callback:(void (^)(bool success, NSString* message))callback {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (merchantNumber != nil) [params setValue:merchantNumber forKey:@"merchantNumber"];
    if (culture != nil) [params setValue:culture forKey:@"culture"];
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"GetShops" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             add to *.h
             explanations
             parse and modify callback **/
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/*************************************** SHOPS SECTION END **************************************/


/************************************ UNSORTED SECTION START ************************************/

- (void)setSessionWithImageWidth:(long)imageWidth imageHeight:(long)imageHeight callback:(void (^)(bool success, NSString* message))callback {
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setValue:@(imageWidth) forKey:@"ImageWidth"];
    [options setValue:@(imageHeight) forKey:@"ImageHeight"];
    
    NSDictionary *params = @{
                             @"applicationToken": [self getAppToken],
                             @"options": options,
                             };
    
    [self sendGetJsonRequestWithParameters:params withMethod:@"SetSession" callback:^(BOOL success, id resultObject) {
        if (success) {
            /** TO DO:
             explanations
             parse and modify callback **/
            if (callback) callback(YES, nil);
        } else {
            if (callback) callback(NO, ((NSError*)resultObject).localizedDescription);
        }
    }];
}

/************************************* UNSORTED SECTION END ************************************/

- (PropertyOld*)parseProperty:(NSDictionary*)propertiesDict {
    PropertyOld *property = [PropertyOld new];
    property.propertyId = [[self getObject:@"ID" from:propertiesDict] integerValue];
    property.propertyText = [self getObject:@"Text" from:propertiesDict];
    property.propertyValue = [self getObject:@"Value" from:propertiesDict];
    property.propertyType = [self getObject:@"Type" from:propertiesDict];
    NSMutableArray *subproperties = [[NSMutableArray alloc] init];
    NSArray *values = [self getObject:@"Values" from:propertiesDict];
    if (values != nil) {
        for (NSDictionary *subpropertyDict in values) {
            PropertyOld *subPproperty = [self parseProperty:subpropertyDict];
            [subproperties addObject:subPproperty];
        }
    }
    property.subproperties = subproperties;
    return property;
}

- (ProductOld *)parseProduct:(NSDictionary*)productDictionary {
    ProductOld *product = [ProductOld new];
    product.productId = [self getObject:@"ID" from:productDictionary];
    product.sku = [self getObject:@"SKU" from:productDictionary];
    product.name = [self getObject:@"Name" from:productDictionary];
    product.prodDescription = [self getObject:@"Description" from:productDictionary];
    product.imageUrl = [self getObject:@"ImageURL" from:productDictionary];
    product.price = [self getObject:@"Price" from:productDictionary];
    product.currencyISOCode = [self getObject:@"Currency" from:productDictionary];
    product.isDynamicAmount = [[self getObject:@"IsDynamicAmount" from:productDictionary] boolValue];
    product.type = [self getObject:@"Type" from:productDictionary];
    product.minQuantity = [self getObject:@"QuantityMin" from:productDictionary];
    product.maxQuantity = [self getObject:@"QuantityMax" from:productDictionary];
    product.stepQuantity = [self getObject:@"QuantityInterval" from:productDictionary];
    product.quantity = [self getObject:@"QuantityAvailable" from:productDictionary];
    product.productUrl = [self getObject:@"ProductURL" from:productDictionary];
    product.metaTitle = [self getObject:@"Meta_Title" from:productDictionary];
    product.metaDescription = [self getObject:@"Meta_Description" from:productDictionary];
    product.metaKeywords = [self getObject:@"Meta_Keywords" from:productDictionary];
    
    //properties
    product.properties = [[NSMutableArray alloc] init];
    NSArray *propArray = [self getObject:@"Properties" from:productDictionary];
    if (propArray != nil) {
        for (NSDictionary *propertyDict in propArray) {
            PropertyOld *property = [self parseProperty:propertyDict];
            [product.properties addObject:property];
        }
    }
    
    //stocks
    product.stocks = [[NSMutableArray alloc] init];
    NSArray *stocksArray = [self getObject:@"Stocks" from:productDictionary];
    if (stocksArray != nil) {
        for (NSDictionary *stocksDict in stocksArray) {
            StockOld *stock = [[StockOld alloc] init];
            stock.stockId = [[self getObject:@"ID" from:stocksDict] longValue];
            stock.propertyIds = [self getObject:@"PropertyValues" from:stocksDict];
            stock.stockQuantity = [[self getObject:@"QuantityAvailable" from:stocksDict] longValue];
            stock.sku = [self getObject:@"SKU" from:stocksDict];
            [product.stocks addObject:stock];
        }
    }
    
    product.categories = [[NSMutableArray alloc] init];
    product.categories = [self getObject:@"Categories" from:productDictionary];
    
    product.paymentMethods = [[NSMutableArray alloc] init];
    product.paymentMethods = [self getObject:@"PaymentMethods" from:productDictionary];
    
    NSDictionary *merchantDict = [self getObject:@"Merchant" from:productDictionary];
    if (merchantDict != nil) product.merchant = [self parseMerchant:merchantDict];
    
    return product;
}

- (MerchantOld*)parseMerchant:(NSDictionary*)merchantDict {
    MerchantOld *merchant = [MerchantOld new];
    merchant.number = [self getObject:@"Number" from:merchantDict];
    merchant.name = [self getObject:@"Name" from:merchantDict];
    merchant.website = [self getObject:@"WebsiteUrl" from:merchantDict];
    merchant.countryIso = [self getObject:@"CountryIso" from:merchantDict];
    merchant.address1 = [self getObject:@"AddressLine1" from:merchantDict];
    merchant.city = [self getObject:@"City" from:merchantDict];
    merchant.phone = [self getObject:@"PhoneNumber" from:merchantDict];
    merchant.email = [self getObject:@"Email" from:merchantDict];
    merchant.bannerUrl = [self getObject:@"BannerUrl" from:merchantDict];
    merchant.fax = [self getObject:@"FaxNumber" from:merchantDict];
    merchant.twitterUrl = [self getObject:@"TwitterUrl" from:merchantDict];
    merchant.zipCode = [self getObject:@"PostalCode" from:merchantDict];
    merchant.googlePlusUrl = [self getObject:@"GooglePlusUrl" from:merchantDict];
    merchant.bannerLinkUrl = [self getObject:@"BannerLinkUrl" from:merchantDict];
    merchant.vimeoUrl = [self getObject:@"VimeoUrl" from:merchantDict];
    merchant.group = [self getObject:@"Group" from:merchantDict];
    merchant.baseColor = [self getObject:@"UIBaseColor" from:merchantDict];
    merchant.pinterestUrl = [self getObject:@"PinterestUrl" from:merchantDict];
    merchant.youtubeUrl = [self getObject:@"YoutubeUrl" from:merchantDict];
    merchant.linkedinUrl = [self getObject:@"LinkedinUrl" from:merchantDict];
    merchant.address2 = [self getObject:@"AddressLine2" from:merchantDict];
    merchant.currencies = [self getObject:@"Currencies" from:merchantDict];
    merchant.stateIso = [self getObject:@"StateIso" from:merchantDict];
    merchant.facebookUrl = [self getObject:@"FacebookUrl" from:merchantDict];
    merchant.logoUrl = [self getObject:@"LogoUrl" from:merchantDict];
    return merchant;
}

- (CartItemOld*)parseCartItem:(NSDictionary*)itemDict {
    CartItemOld *item = [[CartItemOld alloc] init];
    item.itemId = [self getObject:@"ID" from:itemDict];
    item.itemProductId = [self getObject:@"ProductId" from:itemDict];
    item.itemProductStockId = [[self getObject:@"ProductStockId" from:itemDict] integerValue];
    item.itemImageUrl = [self getObject:@"ProductImageUrl" from:itemDict];
    item.itemInsertDate = [self getReadableDate:[self getObject:@"InsertDate" from:itemDict]];
    item.itemName = [self getObject:@"Name" from:itemDict];
    item.itemQuantity = [self getObject:@"Quantity" from:itemDict];
    item.itemPrice = [self getObject:@"Price" from:itemDict];
    item.itemCurrencyIsoCode = [self getObject:@"CurrencyISOCode" from:itemDict];
    item.itemCurrencyFxRate = [self getObject:@"CurrencyFXRate" from:itemDict];
    item.itemShippingFee = [self getObject:@"ShippingFee" from:itemDict];
    item.itemVATPercent = [self getObject:@"VATPercent" from:itemDict];
    item.itemTotalProduct = [[self getObject:@"TotalProduct" from:itemDict] doubleValue];
    item.itemTotal = [self getObject:@"Total" from:itemDict];
    item.itemMinQuantity = [self getObject:@"MinQuantity" from:itemDict];
    item.itemMaxQuantity = [self getObject:@"MaxQuantity" from:itemDict];
    item.itemStepQuantity = [self getObject:@"StepQuantity" from:itemDict];
    item.itemProperties = [self getObject:@"ItemProperties" from:itemDict];
    item.itemTotalShipping = [self getObject:@"TotalShipping" from:itemDict];
    item.itemIsAvailable = [[self getObject:@"IsAvailable" from:itemDict] boolValue];
    item.itemReceiptLink = [self getObject:@"ReceiptLink" from:itemDict];
    item.itemReceiptText = [self getObject:@"ReceiptText" from:itemDict];
    item.itemType = [self getObject:@"Type" from:itemDict];
    item.itemGuestDownloadUrl = [self getObject:@"GuestDownloadUrl" from:itemDict];
    item.itemDownloadMediaType = [self getObject:@"DownloadMediaType" from:itemDict];
    item.itemIsChanged = [[self getObject:@"IsChanged" from:itemDict] boolValue];
    item.itemChangedPrice = [self getObject:@"ChangedPrice" from:itemDict];
    item.itemChangedTotal = [self getObject:@"ChangedTotal" from:itemDict];
    item.itemChangedCurrencyIso = [self getObject:@"ChangedCurrencyIsoCode" from:itemDict];
    return item;
}

- (CartOld*)parseCart:(NSDictionary*)cartDictionary {
    CartOld *cart = [[CartOld alloc] init];
    
    NSArray *items = [self getObject:@"Items" from:cartDictionary];
    if (items != nil) {
        cart.shopCartItems = [[NSMutableArray alloc] init];
        for (NSDictionary *itemDict in items) {
            CartItemOld *item = [self parseCartItem:itemDict];
            [cart.shopCartItems addObject:item];
        }
    }
    
    NSDictionary *merchantDict = [self getObject:@"Merchant" from:cartDictionary];
    if (merchantDict != nil) cart.merchant = [self parseMerchant:merchantDict];
    
    cart.cartCookie = [self getObject:@"Cookie" from:cartDictionary];
    cart.totalPrice = [self getObject:@"Total" from:cartDictionary];
    cart.cartCurrencyIso = [self getObject:@"CurrencyIso" from:cartDictionary];
    cart.installments = [self getObject:@"Installments" from:cartDictionary];
    cart.maxInstallments = [self getObject:@"MaxInstallments" from:cartDictionary];
    cart.cartMerchantReference = [self getObject:@"MerchantReference" from:cartDictionary];
    cart.cartCheckoutUrl = [self getObject:@"CheckoutUrl" from:cartDictionary];
    cart.cartIsChanged = [[self getObject:@"IsChanged" from:cartDictionary] boolValue];
    cart.cartChangedTotal = [self getObject:@"ChangedTotal" from:cartDictionary];
    if (cart.merchant == nil) cart.merchant = [MerchantOld new];
    cart.merchant.number = [self getObject:@"MerchantNumber" from:cartDictionary];
    
    return cart;
}

- (ProductCategoryOld*)parseCategory:(NSDictionary*)categorydictionary {
    ProductCategoryOld *category = [ProductCategoryOld new];
    category.categoryId = [self getObject:@"ID" from:categorydictionary];
    category.categoryName = [self getObject:@"Name" from:categorydictionary];
    NSArray *subCategories = [self getObject:@"SubCategories" from:categorydictionary];
    NSMutableArray *subCategoriesToAdd = [[NSMutableArray alloc] init];
    if (subCategories != nil) {
        for (NSDictionary *dict in subCategories) {
            ProductCategoryOld *subCategory = [self parseCategory:dict];
            [subCategoriesToAdd addObject:subCategory];
        }
    }
    category.subcategories = subCategoriesToAdd;
    return category;
}

@end