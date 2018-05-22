//
//  AccountParser.h
//  Coriunder
//
//  Copyright © 2016 Coriunder. All rights reserved.
//
//  Parser methods for Account services

#import "BaseParser.h"
#import "LoginResult.h"
#import "CookieDecodeResult.h"

@interface AccountParser : BaseParser

/**
 * Method to parse result to CookieDecodeResult object
 * @param resultObject result to parse
 * @return CookieDecodeResult object
 */
- (CookieDecodeResult*)parseCookieDecoder:(id)resultObject;

/**
 * Method to parse result to LoginResult object
 * @param resultObject result to parse
 * @return LoginResult object
 */
- (LoginResult*)parseLoginResult:(id)resultObject;

@end