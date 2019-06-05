# ClutchMobileAPI

[![Version](https://img.shields.io/cocoapods/v/ClutchMobileAPI.svg?style=flat)](https://cocoapods.org/pods/ClutchMobileAPI)
[![License](https://img.shields.io/cocoapods/l/ClutchMobileAPI.svg?style=flat)](https://cocoapods.org/pods/ClutchMobileAPI)
[![Platform](https://img.shields.io/cocoapods/p/ClutchMobileAPI.svg?style=flat)](https://cocoapods.org/pods/ClutchMobileAPI)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

ClutchMobileAPI is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ClutchMobileAPI'
```

## Configuration

In your project's Info.plist file, add your Clutch App Key and Secret in `ClutchMobAppKey` and `ClutchMobAppSecret`.

## Usage

To get access to the shared client, use:

```objective-c
#import <ClutchMobileAPI/ClutchMobClient.h>

id client = [ClutchMobClient sharedClient];
```

With this client, you can perform brand-level calls right away, such as:
```objective-c
[client listSubscriptionLists:^(ClutchMobListSubscriptionListsResponse * _Nonnull serverResponse) {
  NSLog(@"Subscription list count: %lu", [serverResponse.subscriptionLists count]);
} failure:nil];
```

To perform actions specific to a user, you need to obtain a user token. User tokens can be obtained by registering for a new Clutch card, or by accessing an existing Clutch card if the card number and pin are known.

The first step to obtain a user token is to let the user complete a captcha image. Obtain a captcha ID first, download the captcha image and show it to the user. The user input is considered the 'captcha secret'.

The captcha ID together with the captcha secret can be used for one register or 'get token for existing card' call. If the call fails, a new captcha is needed.

To obtain a captcha ID and render the captcha image:

```objective-c
[client getCaptchaIDWithSuccess:^(ClutchMobCaptchaResponse * _Nonnull serverResponse) {
  self.captchaID = [NSString stringWithString:serverResponse.captchaId];
  
  NSString *url = [NSString stringWithFormat:@"https://mobile-api.clutch.com/captcha/show/%@", serverResponse.captchaId];
  [self.captchaViewController setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];

} failure:nil];
```

To register for a new card, make sure to specify all fields that are specified as 'required' in your brand configuration with Clutch:

```objective-c
NSMutableDictionary *primaryFields = [[NSMutableDictionary alloc] init];
[primaryFields setValue:@"John" forKey:@"firstName"];
[primaryFields setValue:@"Doe" forKey:@"lastName"];
[primaryFields setValue:@"john.doe.testemail@clutch.com" forKey:@"email"];

NSMutableDictionary *customFields = [[NSMutableDictionary alloc] init];

[client registerNewCardWithPrimaryFields:primaryFields andCustomFields:customFields withCaptchaID:self.captchaID andCaptchaSecret:captchaSecret withSuccess:^(ClutchMobRegisterResponse *serverResponse) {
  NSLog(@"Registered, user token: %@, Created Clutch card number: %@ with PIN %@", serverResponse.token, serverResponse.cardNumber, serverResponse.pin);
  // The token from serverResponse.token should be stored
} failure:nil];
```

To get a user token for an existing card:

```objective-c
[client getTokenForCard:cardNumber withPin:pin
  withCaptchaID: captchaID andCaptchaSecret: captchaSecret
  withSuccess:^(ClutchMobGetTokenResponse *serverResponse) {
    // The token from serverResponse.token should be stored
  } failure:nil];
```

Once you have obtained a user token, it's important to store this somewhere for as long as the app needs to access the user's Clutch card data.

To effectively 'log out', use `[client releaseToken:token withSuccess:nil failure:nil];`

With the token, you can perform the following actions:

 - Get the user profile, returning balances (loyalty, gift and custom), demographics, email opt in status, segment membership
 - Update demographics (only fields specified as 'editable' in your Clutch brand configuration)
 - Change email opt-in status, both global and per individual subscription list
 - Register events
 - Provide APNS token for push notification integration with Clutch campaigns
 
 See `ClutchMobClient.h` for the available signatures.

## Author

Clutch, asksupport@clutch.com

## License

ClutchMobileAPI is available under the MIT license. See the LICENSE file for more info.


## Notes

` open 'ClutchMobileAPI/Example/ClutchMobileAPI.xcworkspace'`
in example: `pod install`
