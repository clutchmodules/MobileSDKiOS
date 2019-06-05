//
//  ClutchMobProfileViewResponse.h
//  Pods
//
//

#import <Foundation/Foundation.h>
#import "ClutchMobModel.h"
#import "ClutchMobSegment.h"

@interface ClutchMobProfileViewResponse : ClutchMobModel

@property (nonatomic) BOOL success;
@property (nonatomic) BOOL emailOptIn;
@property (nonatomic, strong) NSDictionary *balances;
@property (nonatomic, strong) NSDictionary *primaryDemographics;
@property (nonatomic, strong) NSDictionary *customDemographics;
@property (nonatomic, strong) NSDictionary *emailSubscriptionLists;
@property (nonatomic, strong) NSArray <ClutchMobSegment *> *segments;

@end
