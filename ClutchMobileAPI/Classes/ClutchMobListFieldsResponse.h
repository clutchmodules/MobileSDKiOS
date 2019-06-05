//
//  ClutchMobListFieldsResponse.h
//  Pods
//
//

#import <Foundation/Foundation.h>
#import "ClutchMobModel.h"
#import "ClutchMobDemographicField.h"

@interface ClutchMobListFieldsResponse : ClutchMobModel


@property (nonatomic, strong) NSArray <ClutchMobDemographicField *> *primaryFields;
@property (nonatomic, strong) NSArray <ClutchMobDemographicField *> *customFields;

@end
