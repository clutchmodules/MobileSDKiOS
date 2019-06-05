//
//  ClutchMobListSubscriptionListsResponse.m
//  ClutchMobileAPI
//
//

#import "ClutchMobListSubscriptionListsResponse.h"

#define CMNotNull(obj) (obj && (![obj isEqual:[NSNull null]]) )

@implementation ClutchMobListSubscriptionListsResponse

- (instancetype)initWithInfo:(NSDictionary *)info {
    self = [super initWithInfo:info];
    if(self && CMNotNull(info)) {
        NSMutableArray *mLists = [[NSMutableArray alloc] init];
        for (NSDictionary *list in info[@"subscriptionLists"]) {
            ClutchMobSubscriptionList *subscriptionList = [[ClutchMobSubscriptionList alloc] initWithInfo:list];
            [mLists addObject:subscriptionList];
        }
        self.subscriptionLists = mLists;
        
    }
    return self;
}

@end
