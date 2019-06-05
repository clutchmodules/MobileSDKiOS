//
//  ClutchMobDemographicField.h
//  Pods
//
//

#import <Foundation/Foundation.h>
#import "ClutchMobModel.h"

@interface ClutchMobDemographicField : ClutchMobModel

@property (nonatomic) BOOL required;
@property (nonatomic) BOOL editable;
@property (nonatomic, strong) NSString *apiName;
@property (nonatomic, strong) NSString *displayName;


@end
