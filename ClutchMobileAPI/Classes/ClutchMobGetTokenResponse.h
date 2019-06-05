//
//  ClutchMobGetTokenResponse.h
//  Pods
//
//

#import <Foundation/Foundation.h>
#import "ClutchMobModel.h"

@interface ClutchMobGetTokenResponse : ClutchMobModel

@property (nonatomic) BOOL success;
@property (nonatomic, strong) NSString *token;


@end
