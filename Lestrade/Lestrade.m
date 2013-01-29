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

#import "Lestrade.h"

#if __TARGET__NAME__ == LestradeFull
	#import "NSData+Base64.h"
	#import "NSString+Base64.h"
	#import "Reachability.h"
#endif

#define LIB_LESTRADE_VERSION       @"v0.0.1"
// auto-increment at every build
#define LIB_LESTRADE_BUILD_VERSION @"0.0006"

@interface Lestrade()
@property (strong, nonatomic) id reachability;
@end



@implementation Lestrade

#pragma mark - Version

+(NSString*)version { return [NSString stringWithFormat:@"%@-%@", LIB_LESTRADE_VERSION, LIB_LESTRADE_BUILD_VERSION]; }

#pragma mark - Init

+(Lestrade*)newLestradeWithValidationURL:(NSURL*)validationURL withUsername:(NSString*)_username withPassword:(NSString*)_password {
  Lestrade *__self = [[self alloc] initWithValidationURL:validationURL];
  [__self setUsername:_username];
  [__self setPassword:_password];
  return __self;
}

-(id)initWithValidationURL:(NSURL*)validationURL {
  self = [super init];
  if (self) {
    self.validationURL = validationURL;
    self.reachability  = [[NSClassFromString(@"Reachability") class] reachabilityForInternetConnection];
  }
  return self;
}

#pragma mark - Validation

-(void)validateReceipt:(NSData*)receiptData validationBlock:(ValidationBlock)validation {
  NSAssert(self.validationURL, @"Invalid validationURL");
  
  if (![self.reachability isReachable]) {
    NSDictionary *details = @{NSLocalizedDescriptionKey: @"Unable to connect to server, please check your internet connection."};
    NSError *err = [NSError errorWithDomain:@"libLestrade" code:1 userInfo:details];
    validation(NO, err);
    return;
  }
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.validationURL];
  
  [request setHTTPMethod:@"POST"];
  [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
  [request setValue:[Lestrade version] forHTTPHeaderField:@"X-LibLestrade-Version"];
  [self setBasicAuthenticationForRequest:request];
  
  NSString *bodyString = [NSString stringWithFormat:@"{\"receipt-data\":\"%@\"}", [receiptData base64EncodedString]];
  [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
  
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
    if (error) { validation(NO, error); return; }
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSNumber *status = [parsed objectForKey:@"status"];
    validation([status boolValue], error);
  }];
}

-(void)setBasicAuthenticationForRequest:(NSMutableURLRequest*)request {
  if (self.username && self.password) {
    NSString *encodedAuth = [[NSString stringWithFormat:@"%@:%@", self.username, self.password] base64EncodedString];
    [request setValue:[NSString stringWithFormat:@"Basic %@", encodedAuth] forHTTPHeaderField:@"Authorization"];
  }
}

@end
