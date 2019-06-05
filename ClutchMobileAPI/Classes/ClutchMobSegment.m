//
//  ClutchMobSegment.m
//  ClutchMobileAPI
//
//

#import "ClutchMobSegment.h"

#define CMNotNull(obj) (obj && obj != nil && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobSegment

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.id = CMNotNull(info[@"id"]) ? [[NSString alloc] initWithString:info[@"id"]] : nil;
        self.name = CMNotNull(info[@"name"]) ? [[NSString alloc] initWithString:info[@"name"]] : nil;
        self.desc = CMNotNull(info[@"description"]) ? [[NSString alloc] initWithString:info[@"description"]] : nil;
    }
    return self;
}

@end
