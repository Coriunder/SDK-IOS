//
//  ShopParser.m
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Shop services

#import "ShopParser.h"

@implementation ShopParser

- (Cart*)parseCart:(NSDictionary*)cartDictionary {
    Cart *cart = [Cart new];
    [cart setChangedTotal:[self getDouble:@"ChangedTotal" from:cartDictionary]];
    [cart setCheckoutUrl:[self getString:@"CheckoutUrl" from:cartDictionary]];
    [cart setCookie:[self getString:@"Cookie" from:cartDictionary]];
    [cart setCurrencyIso:[self getString:@"CurrencyIso" from:cartDictionary]];
    [cart setInstallments:[self getObject:@"Installments" from:cartDictionary]];
    [cart setIsChanged:[self getBool:@"IsChanged" from:cartDictionary]];
    [cart setItems:[self parseCartItems:[self getArray:@"Items" from:cartDictionary]]];
    [cart setMaxInstallments:[self getObject:@"MaxInstallments" from:cartDictionary]];
    [cart setMerchant:[self parseMerchant:[self getDictionary:@"Merchant" from:cartDictionary]]];
    [cart.merchant setNumber:[self getString:@"MerchantNumber" from:cartDictionary]];
    [cart setMerchantReference:[self getString:@"MerchantReference" from:cartDictionary]];
    [cart setShopId:[self getLong:@"ShopId" from:cartDictionary]];
    [cart setTotalPrice:[self getDouble:@"Total" from:cartDictionary]];
    return cart;
}

- (NSMutableArray*)parseCartItems:(NSArray*)items {
    NSMutableArray *cartItems = [NSMutableArray new];
    if (items != nil) {
        for (NSDictionary *itemDict in items) {
            CartItem *item = [self parseCartItem:itemDict];
            [cartItems addObject:item];
        }
    }
    return cartItems;
}

/**
 * Method to parse NSDictionary to CartItem object
 * @param itemDict NSDictionary to parse
 * @return CartItem object
 */
- (CartItem*)parseCartItem:(NSDictionary*)itemDict {
    CartItem *item = [CartItem new];
    [item setChangedCurrencyIso:[self getString:@"ChangedCurrencyIsoCode" from:itemDict]];
    [item setChangedPrice:[self getDouble:@"ChangedPrice" from:itemDict]];
    [item setChangedTotal:[self getDouble:@"ChangedTotal" from:itemDict]];
    [item setCurrencyFxRate:[self getDouble:@"CurrencyFXRate" from:itemDict]];
    [item setCurrencyIsoCode:[self getString:@"CurrencyISOCode" from:itemDict]];
    [item setDownloadMediaType:[self getString:@"DownloadMediaType" from:itemDict]];
    [item setGuestDownloadUrl:[self getString:@"GuestDownloadUrl" from:itemDict]];
    [item setItemId:[self getLong:@"ID" from:itemDict]];
    [item setInsertDate:[self getReadableDate:@"InsertDate" from:itemDict]];
    [item setIsAvailable:[self getBool:@"IsAvailable" from:itemDict]];
    [item setIsChanged:[self getBool:@"IsChanged" from:itemDict]];
    
    // Parse cart item's properties
    NSArray *props = [self getArray:@"ItemProperties" from:itemDict];
    NSMutableArray *properties = [NSMutableArray new];
    if (props != nil) {
        for (NSDictionary *dict in props) {
            Property *property = [self parseCartProperty:dict];
            [properties addObject:property];
        }
    }
    [item setItemProperties:properties];
    
    [item setMaxQuantity:[self getInt:@"MaxQuantity" from:itemDict]];
    [item setMinQuantity:[self getInt:@"MinQuantity" from:itemDict]];
    [item setName:[self getString:@"Name" from:itemDict]];
    [item setPrice:[self getDouble:@"Price" from:itemDict]];
    [item setProductId:[self getLong:@"ProductId" from:itemDict]];
    [item setImageUrl:[self getString:@"ProductImageUrl" from:itemDict]];
    [item setProductStockId:[self getLong:@"ProductStockId" from:itemDict]];
    [item setQuantity:[self getInt:@"Quantity" from:itemDict]];
    [item setReceiptLink:[self getString:@"ReceiptLink" from:itemDict]];
    [item setReceiptText:[self getString:@"ReceiptText" from:itemDict]];
    [item setShippingFee:[self getDouble:@"ShippingFee" from:itemDict]];
    [item setStepQuantity:[self getInt:@"StepQuantity" from:itemDict]];
    [item setTotal:[self getDouble:@"Total" from:itemDict]];
    [item setTotalProduct:[self getDouble:@"TotalProduct" from:itemDict]];
    [item setTotalShipping:[self getDouble:@"TotalShipping" from:itemDict]];
    [item setType:[self getObject:@"Type" from:itemDict]];
    [item setVatPercent:[self getDouble:@"VATPercent" from:itemDict]];
    return item;
}

/**
 * Method to parse NSDictionary to Property object
 * @param dict NSDictionary to parse
 * @return Property object
 */
- (Property*)parseCartProperty:(NSDictionary*)dict {
    Property *property = [Property new];
    [property setPropertyText:[self getString:@"Name" from:dict]];
    [property setPropertyId:[self getLong:@"PropertyID" from:dict]];
    [property setPropertyValue:[self getString:@"Value" from:dict]];
    return property;
}

/**
 * Method to parse NSDictionary to ProductCategory object
 * @param categoryDictionary NSDictionary to parse
 * @return ProductCategory object
 */
- (ProductCategory*)parseCategory:(NSDictionary*)categoryDictionary {
    ProductCategory *category = [ProductCategory new];
    [category setCategoryId:[self getInt:@"ID" from:categoryDictionary]];
    [category setName:[self getString:@"Name" from:categoryDictionary]];
    
    NSArray *subCategories = [self getArray:@"SubCategories" from:categoryDictionary];
    NSMutableArray *subCategoriesToAdd = [NSMutableArray new];
    if (subCategories != nil) {
        for (NSDictionary *dict in subCategories) {
            ProductCategory *subCategory = [self parseCategory:dict];
            [subCategoriesToAdd addObject:subCategory];
        }
    }
    [category setSubcategories:subCategoriesToAdd];
    return category;
}

- (Product*)parseProduct:(NSDictionary*)productDictionary {
    Product *product = [Product new];
    [product setCategories:[self getArray:@"Categories" from:productDictionary]];
    [product setCategoryId:[self getLong:@"CategoryId" from:productDictionary]];
    [product setCategoryName:[self getString:@"CategoryName" from:productDictionary]];
    [product setCheckoutUrl:[self getString:@"CheckoutUrl" from:productDictionary]];
    [product setCurrencyIso:[self getString:@"Currency" from:productDictionary]];
    [product setProductDescription:[self getString:@"Description" from:productDictionary]];
    [product setProductId:[self getLong:@"ID" from:productDictionary]];
    [product setImageURL:[self getString:@"ImageURL" from:productDictionary]];
    [product setIsDynamicAmount:[self getBool:@"IsDynamicAmount" from:productDictionary]];
    [product setIsRecurring:[self getBool:@"IsRecurring" from:productDictionary]];
    [product setMerchant:[self parseMerchant:[self getDictionary:@"Merchant" from:productDictionary]]];
    [product setMetaDescription:[self getString:@"Meta_Description" from:productDictionary]];
    [product setMetaKeywords:[self getString:@"Meta_Keywords" from:productDictionary]];
    [product setMetaTitle:[self getString:@"Meta_Title" from:productDictionary]];
    [product setName:[self getString:@"Name" from:productDictionary]];
    [product setNextProductId:[self getLong:@"NetxProductId" from:productDictionary]];
    [product setPaymentMethods:[self getArray:@"PaymentMethods" from:productDictionary]];
    [product setPreviousProductId:[self getLong:@"PrevProductId" from:productDictionary]];
    [product setPrice:[self getDouble:@"Price" from:productDictionary]];
    [product setProductUrl:[self getString:@"ProductURL" from:productDictionary]];
    
    // Parse product's properties
    NSArray *propArray = [self getArray:@"Properties" from:productDictionary];
    NSMutableArray *properties = [NSMutableArray new];
    if (propArray != nil) {
        for (NSDictionary *propertyDict in propArray) {
            Property *property = [self parseProperty:propertyDict];
            [properties addObject:property];
        }
    }
    [product setProperties:properties];
    
    [product setQuantityAvailable:[self getInt:@"QuantityAvailable" from:productDictionary]];
    [product setQuantityInterval:[self getInt:@"QuantityInterval" from:productDictionary]];
    [product setQuantityMax:[self getInt:@"QuantityMax" from:productDictionary]];
    [product setQuantityMin:[self getInt:@"QuantityMin" from:productDictionary]];
    [product setRecurringDisplay:[self getString:@"RecurringDisplay" from:productDictionary]];
    [product setSku:[self getString:@"SKU" from:productDictionary]];
    
    // Parse product's stocks
    NSArray *stocksArray = [self getArray:@"Stocks" from:productDictionary];
    NSMutableArray *stocks = [NSMutableArray new];
    if (stocksArray != nil) {
        for (NSDictionary *stocksDict in stocksArray) {
            Stock *stock = [Stock new];
            [stock setStockId:[self getLong:@"ID" from:stocksDict]];
            [stock setPropertyIds:[self getArray:@"PropertyValues" from:stocksDict]];
            [stock setQuantityAvailable:[self getInt:@"QuantityAvailable" from:stocksDict]];
            [stock setSku:[self getString:@"SKU" from:stocksDict]];
            [stocks addObject:stock];
        }
    }
    [product setStocks:stocks];
    
    [product setType:[self getString:@"Type" from:productDictionary]];
    return product;
}

/**
 * Method to parse NSDictionary to Property object
 * @param propertiesDict NSDictionary to parse
 * @return Property object
 */
- (Property*)parseProperty:(NSDictionary*)propertiesDict {
    Property *property = [Property new];
    [property setPropertyId:[self getLong:@"ID" from:propertiesDict]];
    [property setPropertyText:[self getString:@"Text" from:propertiesDict]];
    [property setPropertyType:[self getString:@"Type" from:propertiesDict]];
    [property setPropertyValue:[self getString:@"Value" from:propertiesDict]];
    
    // Parse subProperties for the property
    NSArray *values = [self getArray:@"Values" from:propertiesDict];
    NSMutableArray *subproperties = [NSMutableArray new];
    if (values != nil) {
        for (NSDictionary *subpropertyDict in values) {
            Property *subPproperty = [self parseProperty:subpropertyDict];
            [subproperties addObject:subPproperty];
        }
    }
    [property setSubproperties:subproperties];
    
    return property;
}

- (Shop*)parseShop:(NSDictionary*)shopDict {
    Shop *shop = [Shop new];
    [shop setBannerLinkUrl:[self getString:@"BannerLinkUrl" from:shopDict]];
    [shop setBannerUrl:[self getString:@"BannerUrl" from:shopDict]];
    
    // Parse countries for shop
    NSArray *countriesArray = [self getArray:@"Countries" from:shopDict];
    NSMutableArray *countries = [NSMutableArray new];
    if (countriesArray != nil) {
        for (NSDictionary *dict in countriesArray) {
            ShopLocation *country = [ShopLocation new];
            country.isoCode = [self getString:@"IsoCode" from:dict];
            country.name = [self getString:@"Name" from:dict];
            [countries addObject:country];
        }
    }
    [shop setCountries:countries];
    
    [shop setCurrencyIsoCode:[self getString:@"CurrencyIsoCode" from:shopDict]];
    [shop setFacebookUrl:[self getString:@"FacebookUrl" from:shopDict]];
    [shop setGooglePlusUrl:[self getString:@"GooglePlusUrl" from:shopDict]];
    [shop setLinkedinUrl:[self getString:@"LinkedinUrl" from:shopDict]];
    [shop setLocationsString:[self getString:@"LocationsString" from:shopDict]];
    [shop setLogoUrl:[self getString:@"LogoUrl" from:shopDict]];
    [shop setPinterestUrl:[self getString:@"PinterestUrl" from:shopDict]];
    
    // Parse regions for shop
    NSArray *regionsArray = [self getArray:@"Regions" from:shopDict];
    NSMutableArray *regions = [NSMutableArray new];
    if (regionsArray != nil) {
        for (NSDictionary *dict in regionsArray) {
            ShopLocation *region = [ShopLocation new];
            region.isoCode = [self getString:@"IsoCode" from:dict];
            region.name = [self getString:@"Name" from:dict];
            [regions addObject:region];
        }
    }
    [shop setRegions:regions];
    
    [shop setShopId:[self getLong:@"ShopId" from:shopDict]];
    [shop setTwitterUrl:[self getString:@"TwitterUrl" from:shopDict]];
    [shop setUiBaseColor:[self getString:@"UIBaseColor" from:shopDict]];
    [shop setVimeoUrl:[self getString:@"VimeoUrl" from:shopDict]];
    [shop setYoutubeUrl:[self getString:@"YoutubeUrl" from:shopDict]];
    return shop;
}

- (NSMutableArray*)parseActiveCarts:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *carts = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *cartDictionary in result) {
            Cart *cart = [self parseCart:cartDictionary];
            [carts addObject:cart];
        }
    }
    return carts;
}

- (NSMutableArray*)parseCategories:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *categories = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *dict in result) {
            ProductCategory *category = [self parseCategory:dict];
            [categories addObject:category];
        }
    }
    return categories;
}

- (NSMutableArray*)parseMerchants:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *merchants = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *merchantDictionary in result) {
            Merchant *merchant = [self parseMerchant:merchantDictionary];
            [merchants addObject:merchant];
        }
    }
    return merchants;
}

- (NSMutableArray*)parseProducts:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *products = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *productDictionary in result) {
            Product *product = [self parseProduct:productDictionary];
            [products addObject:product];
        }
    }
    return products;
}

- (NSMutableArray*)parseShops:(id)resultObject {
    NSArray *result = [self getArray:@"d" from:resultObject];
    NSMutableArray *shops = [NSMutableArray new];
    if (result != nil) {
        for (NSDictionary *shopDictionary in result) {
            Shop *shop = [self parseShop:shopDictionary];
            [shops addObject:shop];
        }
    }
    return shops;
}

@end
