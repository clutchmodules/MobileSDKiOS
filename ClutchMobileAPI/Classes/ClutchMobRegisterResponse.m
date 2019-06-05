//
//  ClutchMobRegisterResponse
//  ClutchMobileAPI
//
//

#import "ClutchMobRegisterResponse.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobRegisterResponse

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.success = [info[@"success"] boolValue];
        self.token = CMNotNull(info[@"token"]) ? [[NSString alloc] initWithString:info[@"token"]] : nil;
        self.cardNumber = CMNotNull(info[@"cardNumber"]) ? [[NSString alloc] initWithString:info[@"cardNumber"]] : nil;
        self.pin = CMNotNull(info[@"pin"]) ? [[NSString alloc] initWithString:info[@"pin"]] : nil;
    }
    return self;
}

@end
