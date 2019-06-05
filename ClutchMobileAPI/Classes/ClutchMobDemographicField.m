//
//  ClutchMobDemographicField.m
//  ClutchMobileAPI
//
//

#import "ClutchMobDemographicField.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobDemographicField

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.required = [info[@"required"] boolValue];
		self.editable = [info[@"editable"] boolValue];
        self.apiName = CMNotNull(info[@"apiName"]) ? [[NSString alloc] initWithString:info[@"apiName"]] : nil;
		self.displayName = CMNotNull(info[@"displayName"]) ? [[NSString alloc] initWithString:info[@"displayName"]] : nil;
    }
    return self;
}

@end
