//
//  ClutchMobSubscriptionList.m
//  ClutchMobileAPI
//
//

#import "ClutchMobSubscriptionList.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobSubscriptionList

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.id = CMNotNull(info[@"id"]) ? [[NSString alloc] initWithString:info[@"id"]] : nil;
		self.name = CMNotNull(info[@"name"]) ? [[NSString alloc] initWithString:info[@"name"]] : nil;
    }
    return self;
}

@end
