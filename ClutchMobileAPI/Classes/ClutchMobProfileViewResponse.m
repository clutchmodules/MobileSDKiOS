//
//  ClutchMobProfileViewResponse.m
//  ClutchMobileAPI
//
//

#import "ClutchMobProfileViewResponse.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobProfileViewResponse

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        self.success = [info[@"success"] boolValue];
        self.emailOptIn = [info[@"emailOptIn"] boolValue];
        
        NSMutableArray *mSegments = [[NSMutableArray alloc] init];
        if(CMNotNull(info[@"segments"])) {
            for (NSDictionary *segmentData in info[@"segments"]) {
                ClutchMobSegment *field = [[ClutchMobSegment alloc] initWithInfo:segmentData];
                [mSegments addObject:field];
            }
        }
        self.segments = mSegments;
        
        NSDictionary *balancesDictionary = info[@"balances"];
        self.balances = [[NSMutableDictionary alloc] init];
        if ([balancesDictionary isKindOfClass:[NSDictionary class]]) {
            for(NSString *key in [balancesDictionary keyEnumerator]) {
                double value = [balancesDictionary[key] doubleValue];
                [self.balances setValue:[NSNumber numberWithDouble:value] forKey:key];
            }
        }
        
        NSDictionary *primaryDictionary = info[@"primaryDemographics"];
        self.primaryDemographics = [[NSMutableDictionary alloc] init];
        if ([primaryDictionary isKindOfClass:[NSDictionary class]]) {
            for(NSString *key in [primaryDictionary keyEnumerator]) {
                NSString *value = [self getStringFromDictonary:primaryDictionary forKey:key];
                [self.primaryDemographics setValue:value forKey:key];
            }
        }
        
        NSDictionary *customDictionary = info[@"customDemographics"];
        self.customDemographics = [[NSMutableDictionary alloc] init];
        if ([customDictionary isKindOfClass:[NSDictionary class]]) {
            for(NSString *key in [customDictionary keyEnumerator]) {
                NSString *value = [self getStringFromDictonary:customDictionary forKey:key];
                [self.customDemographics setValue:value forKey:key];
            }
        }
        
        NSDictionary *listsDictionary = info[@"emailSubscriptionLists"];
        self.emailSubscriptionLists = [[NSMutableDictionary alloc] init];
        if ([listsDictionary isKindOfClass:[NSDictionary class]]) {
            for(NSString *key in [listsDictionary keyEnumerator]) {
                NSNumber *value = [NSNumber numberWithBool:[listsDictionary[key] boolValue]];
                [self.emailSubscriptionLists setValue:value forKey:key];
            }
        }
    }
    return self;
}

-(NSString *)getStringFromDictonary:(NSDictionary *)dictionary forKey:(NSString *)key {
    NSObject *value = [dictionary objectForKey:key];
    if([value isKindOfClass:[NSString class]]) {
        return [NSString stringWithString:((NSString *) value)];
    } else if([value isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithString:[((NSNumber *) value) stringValue]];
    } else {
        return @"";
    }
}

@end
