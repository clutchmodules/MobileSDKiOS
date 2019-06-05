//
//  ClutchMobConstants.h
//  ClutchMobileAPI
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
#define CLUTCHMOB_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define CLUTCHMOB_EXTERN extern __attribute__((visibility ("default")))
#endif

/**
 *  Generic response handler for errors.
 *
 */
typedef void (^ClutchMobFailureBlock)(NSURLResponse * _Nonnull response, id _Nullable responseObject, NSError * _Nullable error);

@class ClutchMobModel;

/**
 *  Generic response handler for success.
 *
 *  @param serverResponse Response JSON in dictionary form
 */
typedef void (^ClutchMobResponseBlock)(id serverResponse);

CLUTCHMOB_EXTERN NSString *const kClutchMobEndpointKey;
CLUTCHMOB_EXTERN NSString *const kClutchMobAppKeyKey;
CLUTCHMOB_EXTERN NSString *const kClutchMobAppSecretKey;


NS_ASSUME_NONNULL_END
