//
//  ClutchMobClient.h
//  ClutchMobileAPI
//
//

#ifndef ClutchMobClient_h
#define ClutchMobClient_h


#endif /* ClutchMobClient_h */

#import <Foundation/Foundation.h>
#import "ClutchMobConstants.h"
#import "ClutchMobGetTokenResponse.h"
#import "ClutchMobCaptchaResponse.h"
#import "ClutchMobListSubscriptionListsResponse.h"
#import "ClutchMobListFieldsResponse.h"
#import "ClutchMobBasicResponse.h"
#import "ClutchMobRegisterResponse.h"
#import "ClutchMobProfileViewResponse.h"

typedef void (^ClutchMobGetTokenResponseBlock)(ClutchMobGetTokenResponse *serverResponse);
typedef void (^ClutchMobCaptchaResponseBlock)(ClutchMobCaptchaResponse *serverResponse);
typedef void (^ClutchMobListSubscriptionListsResponseBlock)(ClutchMobListSubscriptionListsResponse *serverResponse);
typedef void (^ClutchMobListFieldsResponseBlock)(ClutchMobListFieldsResponse *serverResponse);
typedef void (^ClutchMobBasicResponseBlock)(ClutchMobBasicResponse *serverResponse);
typedef void (^ClutchMobRegisterResponseBlock)(ClutchMobRegisterResponse *serverResponse);
typedef void (^ClutchMobProfileViewResponseBlock)(ClutchMobProfileViewResponse *serverResponse);

@interface ClutchMobClient : NSObject

/*!
 @abstract Gets the singleton instance.
 */
+ (instancetype) sharedClient;

/**
 *  Endpoint to reach the Clutch Mobile API.
 */
@property (nonatomic, copy, readonly) NSString *endpoint;

/**
 *  App Key registered with Clutch.
 */
@property (nonatomic, copy, readonly) NSString *appKey;

/**
 *  App Secret registered with Clutch.
 */
@property (nonatomic, copy, readonly) NSString *appSecret;


- (void)getCaptchaIDWithSuccess:(ClutchMobCaptchaResponseBlock)success
                        failure:(ClutchMobFailureBlock)failure;


-(void)listSubscriptionLists:(ClutchMobListSubscriptionListsResponseBlock)success
                     failure:(ClutchMobFailureBlock)failure;

-(void)listFields:(ClutchMobListFieldsResponseBlock)success
          failure:(ClutchMobFailureBlock)failure;

/*!
 Get a token for an existing card.
 Provide the card number and pin, plus a never-used captcha ID and the captcha Secret
 (being the value that the user could read from the captcha image).
 If successful, will return with a token that can be used for further API calls for this card.
 
 If a token is returned, it's recommended to store this, so the user can access their Clutch card
 in the future without having to enter a card number and captcha again.
 */
-(void)getTokenForCard:(NSString *) cardNumber withPin:(NSString *)pin
         withCaptchaID:(NSString *) captchaID andCaptchaSecret:(NSString *) captchaSecret
           withSuccess:(ClutchMobGetTokenResponseBlock)success
               failure:(ClutchMobFailureBlock)failure;


/*!
 Register for a new Clutch card.
 Provide the primary fields and custom fields that are required for registration.
 Also provide a never-used captcha ID and the captcha Secret
 (being the value that the user could read from the captcha image).
 
 If successful, will return wuth a token that can be used for further API calls for this card.
 
 If a token is returned, it's recommended to store this, so the user can access their Clutch card
 in the future without having to enter a card number and captcha.
 
 If the registration is successful, a card number and PIN will also be returned.
 It's recommended to show this to the customer, as they will not be able to find their PIN later on in any other way.
 
 */
-(void)registerNewCardWithPrimaryFields:(NSDictionary *) primaryFields andCustomFields:(NSDictionary *)customFields
                          withCaptchaID:(NSString *) captchaID andCaptchaSecret:(NSString *) captchaSecret
                            withSuccess:(ClutchMobRegisterResponseBlock)success
                                failure:(ClutchMobFailureBlock)failure;

/*!
 Release a token, indicating it should no longer be possible to place API calls with this token.
 To get a new token, the customer will have to enter their card number and PIN again,
 or register for a new Clutch card.
 
 */
-(void)releaseToken:(NSString *) token
        withSuccess:(ClutchMobBasicResponseBlock)success
            failure:(ClutchMobFailureBlock)failure;

/*!
 Update demographics for a customer.
 */
-(void)updateDemographics:(NSString *) token withPrimaryFields:(NSDictionary *) primaryFields andCustomFields:(NSDictionary *)customFields
              withSuccess:(ClutchMobBasicResponseBlock)success
                  failure:(ClutchMobFailureBlock)failure;

/*!
 Update push token with new APNS push token value.
 */
-(void)updatePushToken:(NSString *) token withPushToken:(NSString *) pushToken
           withSuccess:(ClutchMobBasicResponseBlock)success
               failure:(ClutchMobFailureBlock)failure;

/*!
 Log an event for the current card with Clutch.
 The categoryID specifies the type of custom event to log.
 */
-(void)logEvent:(NSString *) token withCategoryID:(NSString *) categoryID
    withSuccess:(ClutchMobBasicResponseBlock)success
        failure:(ClutchMobFailureBlock)failure;

/*!
 Update the opt in status for a given subscription list.
 Set newGlobalOptIn to the global opt in status. If the global opt in is false, individual list opt ins won't actually result in the user being opted in.
 */
-(void)updateOptInStatus:(NSString *) token forList:(NSString *) subscriptionListId
       withNewListStatus:(NSNumber *) newListStatus andGlobalOptInStatus:(NSNumber *)newGlobalOptIn
             withSuccess:(ClutchMobBasicResponseBlock)success
                 failure:(ClutchMobFailureBlock)failure;

/*!
 Request to view a profile.
 */
-(void)getProfile:(NSString *) token
      withSuccess:(ClutchMobProfileViewResponseBlock)success
          failure:(ClutchMobFailureBlock)failure;

@end
