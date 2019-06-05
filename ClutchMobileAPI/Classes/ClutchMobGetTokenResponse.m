//
//  ClutchMobGetTokenResponse.m
//  ClutchMobileAPI
//
//

#import "ClutchMobGetTokenResponse.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobGetTokenResponse

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.success = [info[@"success"] boolValue];
        self.token = CMNotNull(info[@"token"]) ? [[NSString alloc] initWithString:info[@"token"]] : nil;
    }
    return self;
}

@end
