libLestrade
===========

Simple iOS library to validate receipts using [Lestrade][lestrade].
This project use [nicklockwood/Base64][base64] to encode the receipt bytes and [tonymillion/Reachability][reachability] to check for connectivity.


Installation
------------

#### Compile

Get the code:

    git clone https://github.com/TotenDev/libLestrade.git
    cd libLestrade
    open Lestrade.xcodeproj

#### or

Use the pre-compiled libs:

- Download [libLestradeFull][libfull]: include [tonymillion/Reachability][reachability] and [nicklockwood/Base64][base64], so only use this if your project does NOT use them too, or you will get a duplication error.

- Download [libLestradeMinimal][libmin]: use this if your project already uses [tonymillion/Reachability][reachability] or [nicklockwood/Base64][base64].


Usage
-----

Add the files to your project, `#import "Lestrade.h"`.
Validation example:

    NSURL *validationURL = [NSURL URLWithString:@"http://example.com/sandbox/validate"];
    Lestrade *lestrade   = [[Lestrade alloc] initWithValidationURL:validationURL];
    lestrade.username    = @"sherlock";
    lestrade.password    = @"secret";
    [lestrade validateReceipt:transaction.transactionReceipt validationBlock:^(BOOL isValid, NSError *error) {
      if (error) { NSLog(@"error: %@", [error localizedDescription]); }
      NSLog(@"is receipt valid?(%d)", isValid);
    }];


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

[MIT][]


[MIT]: https://github.com/TotenDev/libLestrade/blob/master/LICENSE
[lestrade]: https://github.com/TotenDev/Lestrade
[base64]: https://github.com/nicklockwood/Base64
[reachability]: https://github.com/tonymillion/Reachability
[libfull]: https://github.com/downloads/TotenDev/libLestrade/libLestradeFull-v0.0.1-0.0005.zip
[libmin]: https://github.com/downloads/TotenDev/libLestrade/libLestradeMinimal-v0.0.1-0.0005.zip
