//
//  ShopRequestBuilder.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  This class contains methods designed to prepare
//  NSDictionary to send with requests to Shop service

#import "ShopRequestBuilder.h"

@implementation ShopRequestBuilder

- (NSDictionary*)buildJsonForGetCart:(NSString*)cookie {
    return @{ @"cookie": [self getNonNilValueForString:cookie], };
}

- (NSDictionary*)buildJsonForGetCartOfTransaction:(long)transactionId {
    return @{ @"transactionId": @(transactionId), };
}

/*
 ToDoV2:
 Installments, MaxInstallments - unsignedByte;
 Merchant - no need;
 Items - most fields not added now
 */
- (NSDictionary*)buildJsonForUpdateCart:(Cart*)cart {
    if (cart == nil || cart.merchant == nil) return nil;
    
    NSDictionary *cartPart = [[NSMutableDictionary alloc] init];
    [cartPart setValue:@(cart.changedTotal) forKey:@"ChangedTotal"];
    [cartPart setValue:[self getNonNilValueForString:cart.checkoutUrl] forKey:@"CheckoutUrl"];
    [cartPart setValue:[self getNonNilValueForString:cart.cookie] forKey:@"Cookie"];
    [cartPart setValue:[self getNonNilValueForString:cart.currencyIso] forKey:@"CurrencyIso"];
    [cartPart setValue:[self getNonNilValueForString:cart.installments] forKey:@"Installments"];
    [cartPart setValue:@(cart.isChanged) forKey:@"IsChanged"];
    
    // Create NSMutableArray with cart items
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    if (cart.items != nil) {
        for (CartItem *item in cart.items) {
            NSDictionary *shopCartItem = [[NSMutableDictionary alloc] init];
            [shopCartItem setValue:@(item.productId) forKey:@"ProductId"];
            if (item.productStockId > 0)
                [shopCartItem setValue:@(item.productStockId) forKey:@"ProductStockId"];
            else [shopCartItem setValue:[NSNull null] forKey:@"ProductStockId"];
            [shopCartItem setValue:@(item.quantity) forKey:@"Quantity"];
            [shopCartItem setValue:@(item.price) forKey:@"Price"];
            [itemsArray addObject:shopCartItem];
        }
    }
    [cartPart setValue:itemsArray forKey:@"Items"];
    
    [cartPart setValue:[self getNonNilValueForString:cart.maxInstallments] forKey:@"MaxInstallments"];
    [cartPart setValue:[self getNonNilValueForString:cart.merchant.number] forKey:@"MerchantNumber"];
    [cartPart setValue:[self getNonNilValueForString:cart.merchantReference] forKey:@"MerchantReference"];
    [cartPart setValue:@(cart.shopId) forKey:@"ShopId"];
    [cartPart setValue:@(cart.totalPrice) forKey:@"Total"];
    
    return @{ @"cart": cartPart, };
}

- (NSDictionary*)buildJsonForDownload:(long)itemId asPlainData:(BOOL)asPlainData {
    return @{ @"itemId": @(itemId),
              @"asPlainData": @(asPlainData), };
}

- (NSDictionary*)buildJsonForDownloadUnauthorized:(NSString*)fileKey asPlainData:(BOOL)asPlainData {
    return @{ @"fileKey": [self getNonNilValueForString:fileKey],
              @"asPlainData": @(asPlainData), };
}

- (NSDictionary*)buildJsonForDownloads:(int)page pageSize:(int)pageSize {
    // Create sortAndPage NSDictionary
    NSDictionary *sortAndPage = @{ @"PageNumber": @(page),
                                   @"PageSize": @(pageSize), };
    return @{ @"sortAndPage": sortAndPage, };
}

- (NSDictionary*)buildJsonForGetMerchant:(NSString*)merchantNumber {
    return @{ @"merchantNumber": [self getNonNilValueForString:merchantNumber], };
}

- (NSDictionary*)buildJsonForGetCategories:(NSString*)merchantNumber language:(NSString*)language {
    return @{ @"merchantNumber": [self getNonNilValueForString:merchantNumber],
              @"language": [self getNonNilValueForString:language], };;
}

- (NSDictionary*)buildJsonForGetContent:(NSString*)merchantNumber language:(NSString*)language contentName:(NSString*)contentName {
    return @{ @"merchantNumber": [self getNonNilValueForString:merchantNumber],
              @"language": [self getNonNilValueForString:contentName],
              @"contentName": [self getNonNilValueForString:language], };
}

- (NSDictionary*)buildJsonForGetMerchants:(long)groupId status:(merchantStatus)status text:(NSString*)text appToken:(NSString*)appToken {
    // Create filters NSMutableDictionary
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:appToken forKey:@"ApplicationToken"];
    [params setObject:@(groupId) forKey:@"GroupId"];
    
    // Put int value depending on the merchant status
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
    [params setObject:[self getNonNilValueForString:text] forKey:@"Text"];
    return @{ @"filters": params, };
}

- (NSDictionary*)buildJsonForGetCategorisedProducts:(long)category shopId:(long)shopId language:(NSString*)language {
    return @{ @"shopId": @(shopId),
              @"itemsPerCategory": @(category),
              @"language": [self getNonNilValueForString:language], };
}

- (NSDictionary*)buildJsonForGetProduct:(long)productId merchantNumber:(NSString*)merchantNumber language:(NSString*)language {
    return @{ @"merchantNumber": [self getNonNilValueForString:merchantNumber],
              @"itemId": @(productId),
              @"language": [self getNonNilValueForString:language], };
}

- (NSDictionary*)buildJsonForGetProducts:(int)page pageSize:(int)pageSize categories:(NSArray<NSNumber*>*)categories
                               countries:(NSArray<NSString*>*)countries includeGlobalRegion:(BOOL)includeGlobalRegion
                                language:(NSString*)language merchantGroups:(NSArray<NSNumber*>*)merchantGroups
                              merchantId:(NSString*)merchantId name:(NSString*)name promoOnly:(BOOL)promoOnly
                                 regions:(NSArray<NSString*>*)regions shopId:(long)shopId tags:(NSString*)tags {
    
    // Create filters NSMutableDictionary
    NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
    [filters setValue:(categories == nil) ? [NSArray new] : categories forKey:@"Categories"];
    [filters setValue:(countries == nil) ? [NSArray new] : countries forKey:@"Countries"];
    [filters setValue:@(includeGlobalRegion) forKey:@"IncludeGlobalRegion"];
    [filters setValue:[self getNonNilValueForString:language] forKey:@"Language"];
    [filters setValue:(merchantGroups == nil) ? [NSArray new] : merchantGroups forKey:@"MerchantGroups"];
    [filters setValue:[self getNonNilValueForString:merchantId] forKey:@"MerchantNumber"];
    [filters setValue:[self getNonNilValueForString:name] forKey:@"Name"];
    [filters setValue:@(promoOnly) forKey:@"PromoOnly"];
    [filters setValue:(regions == nil) ? [NSArray new] : regions forKey:@"Regions"];
    [filters setValue:@(shopId) forKey:@"ShopId"];
    [filters setValue:[self getNonNilValueForString:tags] forKey:@"Tags"];
    
    // Create sortAndPage NSDictionary
    NSDictionary *sortAndPage = @{ @"PageNumber": @(page),
                                   @"PageSize": @(pageSize), };
    return @{ @"filters": filters,
              @"sortAndPage": sortAndPage, };
}

- (NSDictionary*)buildJsonForGetShop:(long)shopId merchantNumber:(NSString*)merchantNumber {
    return @{ @"merchantNumber": [self getNonNilValueForString:merchantNumber],
              @"shopId": @(shopId), };
}

- (NSDictionary*)buildJsonForGetShopIds:(NSString*)subDomainName {
    return @{ @"subDomainName": [self getNonNilValueForString:subDomainName], };
}

- (NSDictionary*)buildJsonForGetShops:(NSString*)merchantNumber culture:(NSString*)culture {
    return @{ @"merchantNumber": [self getNonNilValueForString:merchantNumber],
              @"culture": [self getNonNilValueForString:culture], };
}

- (NSDictionary*)buildJsonForGetShopsByLocation:(NSArray<NSString*>*)regions countries:(NSArray<NSString*>*)countries
                             includeGlobalShops:(BOOL)includeGlobalShops culture:(NSString*)culture {
    return @{ @"regions": (regions == nil) ? [NSArray new] : regions,
              @"countries": (countries == nil) ? [NSArray new] : countries,
              @"includeGlobalShops": @(includeGlobalShops),
              @"culture": [self getNonNilValueForString:culture], };
}

- (NSDictionary*)buildJsonForSetSession:(NSString*)declineUrl imageHeight:(long)imageHeight imageWidth:(long)imageWidth
                             pendingUrl:(NSString*)pendingUrl successUrl:(NSString*)successUrl appToken:(NSString*)appToken {
    
    // Create options NSMutableDictionary
    NSMutableDictionary *options = [[NSMutableDictionary alloc] init];
    [options setValue:[self getNonNilValueForString:declineUrl] forKey:@"DeclineUrl"];
    [options setValue:@(imageHeight) forKey:@"ImageHeight"];
    [options setValue:@(imageWidth) forKey:@"ImageWidth"];
    [options setValue:[self getNonNilValueForString:pendingUrl] forKey:@"PendingUrl"];
    [options setValue:[self getNonNilValueForString:successUrl] forKey:@"SuccessUrl"];
    
    return @{ @"applicationToken": appToken,
              @"options": options, };
}

/**
 * Method to get non-nil NSString object
 * @param string NSString which shouldn't be nil
 */
-(NSString*)getNonNilValueForString:(NSString*)string {
    return (string == nil) ? @"" : string;
}

@end
