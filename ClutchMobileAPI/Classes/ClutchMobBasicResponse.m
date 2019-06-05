//
//  ClutchMobBasicResponse.m
//  ClutchMobileAPI
//
//

#import "ClutchMobBasicResponse.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobBasicResponse

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.success = [info[@"success"] boolValue];
    }
    return self;
}

@end
