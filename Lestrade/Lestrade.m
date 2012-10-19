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

@interface Lestrade()
@property (strong, nonatomic) Reachability *reachability;
@end



@implementation Lestrade

-(id)initWithValidationURL:(NSURL*)validationURL {
  self = [super init];
  if (self) {
    self.validationURL = validationURL;
    self.reachability  = [Reachability reachabilityForInternetConnection];
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
