//
//  ClutchMobListSubscriptionListsResponse.h
//  Pods
//
//

#import <Foundation/Foundation.h>
#import "ClutchMobModel.h"
#import "ClutchMobSubscriptionList.h"

@interface ClutchMobListSubscriptionListsResponse : ClutchMobModel


@property (nonatomic, strong) NSArray <ClutchMobSubscriptionList *> *subscriptionLists;

@end
