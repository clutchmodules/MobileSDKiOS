//
//  ClutchMobRegisterResponse
//  Pods
//
//

#import <Foundation/Foundation.h>
#import "ClutchMobModel.h"

@interface ClutchMobRegisterResponse : ClutchMobModel

@property (nonatomic) BOOL success;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *cardNumber;
@property (nonatomic, strong) NSString *pin;


@end
