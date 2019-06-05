//
//  ClutchMobClient.m
//  ClutchMobileAPI
//
//

#import "ClutchMobClient.h"
#import "AFNetworking.h"
#import <Foundation/Foundation.h>
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>



@interface ClutchMobClient()

@property (nonatomic, copy, nonnull) NSString *endpoint;
@property (nonatomic, copy, nonnull) NSString *appKey;
@property (nonatomic, copy, nonnull) NSString *appSecret;
@property (nonatomic, strong, nonnull) AFHTTPSessionManager *httpManager;


@end

@implementation ClutchMobClient

+ (instancetype)sharedClient {
    static ClutchMobClient *_sharedClient = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sharedClient = [[ClutchMobClient alloc] init];
    });
    return _sharedClient;
}

- (instancetype)init {
    
    if (self = [super init])
    {
        NSURL *baseURL = [NSURL URLWithString:_endpoint];
        self.httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        self.httpManager.responseSerializer = [[AFJSONResponseSerializer alloc] init];
        
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        
        self.endpoint = info[kClutchMobEndpointKey];
        self.appKey = info[kClutchMobAppKeyKey];
        self.appSecret = info[kClutchMobAppSecretKey];
        
        if (!self.endpoint || [self.endpoint isEqualToString:@""]) {
            NSLog(@"[ClutchMob] ERROR : Invalid Endpoint. Please set a valid value for the key \"%@\" in the App's Info.plist file", kClutchMobEndpointKey);
        }
        
        if (!self.appKey || [self.appKey isEqualToString:@""]) {
            NSLog(@"[ClutchMob] ERROR : Invalid App Key. Please set a valid value for the key \"%@\" in the App's Info.plist file", kClutchMobAppKeyKey);
        }
        
        if (!self.appSecret || [self.appSecret isEqualToString:@""]) {
            NSLog(@"[ClutchMob] ERROR : Invalid App Secret. Please set a valid value for the key \"%@\" in the App's Info.plist file", kClutchMobAppSecretKey);
        }
    }
    return self;
}

-(NSString *)createSHA512:(NSString *)string
{
    const char *cstr = [string cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:string.length];
    uint8_t digest[CC_SHA512_DIGEST_LENGTH];
    CC_SHA512(data.bytes, data.length, digest);
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA512_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

-(NSString *)hmacSHA512:(NSString *)plainText withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plainText cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA512_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMACData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString* output = [NSMutableString  stringWithCapacity:CC_SHA512_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < HMACData.length; i++) {
        [output appendFormat:@"%02lx", (unsigned long)buffer[i]];
    }
    return output;
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  responseModel:(Class)modelClass
        success:(ClutchMobResponseBlock)successHandler
          error:(ClutchMobFailureBlock)errorHandler
{
    NSString *fullURL = [NSString stringWithFormat:@"%@%@", _endpoint, path];
    
    NSString *method = @"GET";
    NSString *body = @"";
    
    // In case this is a POST request, convert the dictionary into a JSON request body
    if(parameters != nil) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters
                                                           options:0
                                                             error:&error];
        body = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        method = @"POST";
    }
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:method URLString:fullURL parameters:nil error:nil];
    req.timeoutInterval = 20;
    
    NSString *requestId = [[NSUUID UUID] UUIDString];
    NSString *requestTime = [NSString stringWithFormat:@"%.f", ([[NSDate date] timeIntervalSince1970] * 1000)];
    //NSLog(@"Request time: %@", requestTime);
    
    NSString *contentDigest = @"";
    if([body length] > 0) {
        contentDigest = [self createSHA512:body];
    }
    
    NSString *hmacData = [NSString stringWithFormat:@"[\"%@\",\"%@\",\"%@\",\"%@\"]", requestId, requestTime, path, contentDigest];
    //NSLog(@"HMAC Data: %@", hmacData);
    
    NSString *signature = [self hmacSHA512:hmacData withKey:_appSecret];
    //NSLog(@"Signature: %@", signature);
    
    [req setValue:_appKey forHTTPHeaderField:@"X-Application-Key"];
    [req setValue:requestId forHTTPHeaderField:@"X-Request-Id"];
    [req setValue:requestTime forHTTPHeaderField:@"X-Request-Time"];
    [req setValue:signature forHTTPHeaderField:@"X-Signature"];
    
    //[req setHTTPBody:@"abc"];
    if([body length] > 0) {
        [req setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    id handler = ^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            //NSLog(@"Reply JSON: %@", responseObject);
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            id modelObject = [[modelClass alloc] initWithInfo:responseDictionary];
            if(successHandler != nil) {
                successHandler(modelObject);
            }
        } else {
            NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            if(errorHandler != nil) {
                errorHandler(response, responseObject, error);
            }
        }
    };
    
    NSURLSessionDataTask *dataTask = [self.httpManager dataTaskWithRequest:req uploadProgress:nil downloadProgress:nil completionHandler:handler];
    [dataTask resume];
}

/*!
 Get a captcha ID to render.
 */
- (void)getCaptchaIDWithSuccess:(ClutchMobCaptchaResponseBlock)success
               failure:(ClutchMobFailureBlock)failure
{
    [self getPath:@"/captcha/new" parameters:nil responseModel:[ClutchMobCaptchaResponse class] success:success error:failure];
}

/*!
 List all subscription lists that exist for this brand.
 */
-(void)listSubscriptionLists:(ClutchMobListSubscriptionListsResponseBlock)success
                     failure:(ClutchMobFailureBlock)failure
{
    [self getPath:@"/brand/lists" parameters:nil responseModel:[ClutchMobListSubscriptionListsResponse class] success:success error:failure];
}

/*!
 List all demographic and custom fields that exist for this brand.
 */
-(void)listFields:(ClutchMobListFieldsResponseBlock)success
                     failure:(ClutchMobFailureBlock)failure
{
    [self getPath:@"/brand/fields" parameters:nil responseModel:[ClutchMobListFieldsResponse class] success:success error:failure];
}

-(void)getTokenForCard:(NSString *) cardNumber withPin:(NSString *)pin
        withCaptchaID:(NSString *) captchaID andCaptchaSecret:(NSString *) captchaSecret
        withSuccess:(ClutchMobGetTokenResponseBlock)success
        failure:(ClutchMobFailureBlock)failure
{
    NSDictionary *params = @{
                             @"cardNumber": cardNumber,
                             @"pin": pin,
                             @"captchaId": captchaID,
                             @"captchaSecret": captchaSecret
                             };
    [self getPath:@"/auth/token/existing" parameters:params responseModel:[ClutchMobGetTokenResponse class] success:success error:failure];
}

-(void)registerNewCardWithPrimaryFields:(NSDictionary *) primaryFields andCustomFields:(NSDictionary *)customFields
         withCaptchaID:(NSString *) captchaID andCaptchaSecret:(NSString *) captchaSecret
           withSuccess:(ClutchMobRegisterResponseBlock)success
               failure:(ClutchMobFailureBlock)failure
{
    NSDictionary *params = @{
                             @"primaryFields": primaryFields,
                             @"customFields": customFields,
                             @"captchaId": captchaID,
                             @"captchaSecret": captchaSecret
                             };
    [self getPath:@"/auth/token/register" parameters:params responseModel:[ClutchMobRegisterResponse class] success:success error:failure];
}

-(void)releaseToken:(NSString *) token
        withSuccess:(ClutchMobBasicResponseBlock)success
            failure:(ClutchMobFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"/auth/token/release/%@", token] parameters:nil responseModel:[ClutchMobBasicResponse class] success:success error:failure];
}

-(void)updateDemographics:(NSString *) token withPrimaryFields:(NSDictionary *) primaryFields andCustomFields:(NSDictionary *)customFields
              withSuccess:(ClutchMobBasicResponseBlock)success
                  failure:(ClutchMobFailureBlock)failure
{
    NSDictionary *params = @{
                             @"token": token,
                             @"primaryFields": primaryFields,
                             @"customFields": customFields
                             };
    [self getPath:@"/profile/demographics" parameters:params responseModel:[ClutchMobBasicResponse class] success:success error:failure];
}

-(void)updatePushToken:(NSString *) token withPushToken:(NSString *) pushToken
           withSuccess:(ClutchMobBasicResponseBlock)success
               failure:(ClutchMobFailureBlock)failure
{
    NSDictionary *params = @{
                             @"token": token,
                             @"pushTokenType": @"apns",
                             @"pushToken": pushToken
                             };
    [self getPath:@"/profile/pushToken" parameters:params responseModel:[ClutchMobBasicResponse class] success:success error:failure];
}

-(void)logEvent:(NSString *) token withCategoryID:(NSString *) categoryID
           withSuccess:(ClutchMobBasicResponseBlock)success
               failure:(ClutchMobFailureBlock)failure
{
    NSDictionary *params = @{
                             @"token": token,
                             @"categoryId": categoryID
                             };
    [self getPath:@"/profile/event" parameters:params responseModel:[ClutchMobBasicResponse class] success:success error:failure];
}

-(void)updateOptInStatus:(NSString *) token forList:(NSString *) subscriptionListId
       withNewListStatus:(NSNumber *) newListStatus andGlobalOptInStatus:(NSNumber *)newGlobalOptIn
    withSuccess:(ClutchMobBasicResponseBlock)success
        failure:(ClutchMobFailureBlock)failure
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:token forKey:@"token"];
    if(subscriptionListId != nil) {
        [params setValue:subscriptionListId forKey:@"subscriptionListId"];
    }
    if(newListStatus != nil) {
        [params setValue:newListStatus forKey:@"newOptIn"];
    }
    if(newGlobalOptIn != nil) {
        [params setValue:newGlobalOptIn forKey:@"globalOptIn"];
    }
    
    [self getPath:@"/profile/optInStatus" parameters:params responseModel:[ClutchMobBasicResponse class] success:success error:failure];
}

-(void)getProfile:(NSString *) token
             withSuccess:(ClutchMobProfileViewResponseBlock)success
                 failure:(ClutchMobFailureBlock)failure
{
    [self getPath:[NSString stringWithFormat:@"/profile/token/%@", token] parameters:nil responseModel:[ClutchMobProfileViewResponse class] success:success error:failure];
}

@end
