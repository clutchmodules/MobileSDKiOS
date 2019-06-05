//
//  ClutchMobCaptchaResponse.m
//  ClutchMobileAPI
//
//

#import "ClutchMobCaptchaResponse.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobCaptchaResponse

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.captchaId = CMNotNull(info[@"captchaId"]) ? [[NSString alloc] initWithString:info[@"captchaId"]] : nil;
    }
    return self;
}

@end
