//
//  ClutchMobListFieldsResponse.m
//  ClutchMobileAPI
//
//

#import "ClutchMobListFieldsResponse.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobListFieldsResponse

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        NSMutableArray *mPrimaryFields = [[NSMutableArray alloc] init];
        for (NSDictionary *demographicField in info[@"primaryFields"]) {
            ClutchMobDemographicField *field = [[ClutchMobDemographicField alloc] initWithInfo:demographicField];
            [mPrimaryFields addObject:field];
        }
        self.primaryFields = mPrimaryFields;
        
        NSMutableArray *mCustomFields = [[NSMutableArray alloc] init];
        for (NSDictionary *demographicField in info[@"customFields"]) {
            ClutchMobDemographicField *field = [[ClutchMobDemographicField alloc] initWithInfo:demographicField];
            [mCustomFields addObject:field];
        }
        self.customFields = mCustomFields;
    }
    return self;
}

@end
