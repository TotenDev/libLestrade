//
// Copyright (c) 2012 TotenDev
//
// MIT License
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
// LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
// WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <Foundation/Foundation.h>

#define LestradeLibraryBuildVersion @"0.1002"

typedef void (^ValidationBlock)(BOOL isValid, NSError *error);

@interface Lestrade : NSObject


/**
 * ValidationURL
 * -------------
 *
 * Validation service like [Lestrade](https://github.com/TotenDev/Lestrade)
 * This property *must* be set before trying to validate a receipt.
 */
@property (strong, nonatomic) NSURL *validationURL;


/**
 * Authentication
 * --------------
 *
 * [HTTP Basic Authentication](http://en.wikipedia.org/wiki/Basic_access_authentication)
 * If not specified will not set header.
 */
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;


/**
 * Init with URL
 * -------------
 *
 * Init and set validationURL property.
 */
-(id)initWithValidationURL:(NSURL*)validationURL;


/**
 * Validate Receipt
 * ----------------
 *
 * Send a request to validate the receipt, you shoud check for conectivity before calling this method
 *
 * @param receiptData transaction receipt data.
 * @return YES if valid
 */
-(void)validateReceipt:(NSData*)receiptData validationBlock:(ValidationBlock)validation;

@end
