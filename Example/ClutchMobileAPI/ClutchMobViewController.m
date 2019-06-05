//
//  ClutchMobViewController.m
//  ClutchMobileAPI
//
//  Copyright (c) 2019 Clutch. All rights reserved.
//

#import "ClutchMobViewController.h"
#import <ClutchMobileAPI/ClutchMobClient.h>

@interface ClutchMobViewController ()

@end

@implementation ClutchMobViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"Starting...");
    id client = [ClutchMobClient sharedClient];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Handle register button click
- (IBAction)buttonClicked:(id)sender {
    NSString *captchaEntry = [_captchaCodeField text];
    NSLog(@"Captcha entry is: %@ for captcha ID %@", captchaEntry, _captchaID);
    
    id client = [ClutchMobClient sharedClient];
    
    NSMutableDictionary *primaryFields = [[NSMutableDictionary alloc] init];
    [primaryFields setValue:@"JohnIOS" forKey:@"firstName"];
    [primaryFields setValue:@"DoeIOS" forKey:@"lastName"];
    [primaryFields setValue:@"john.doe.tester.ios@clutch.com" forKey:@"email"];
    NSMutableDictionary *customFields = [[NSMutableDictionary alloc] init];
    [customFields setValue:@"42" forKey:@"favoriteColor"];
    
    [client registerNewCardWithPrimaryFields:primaryFields andCustomFields:customFields withCaptchaID:_captchaID andCaptchaSecret:captchaEntry withSuccess:^(ClutchMobRegisterResponse *serverResponse) {
        NSLog(@"Registered, token: %@, card: %@, %@", serverResponse.token, serverResponse.cardNumber, serverResponse.pin);
        self.token = serverResponse.token;
        [self.cardNumberLabel setText:serverResponse.cardNumber];
    } failure:nil];
}

// Button click that should refresh the Captcha image, or load one for the first time if there isn't one
- (IBAction)refreshCaptchaButtonClicked:(id)sender {
    id client = [ClutchMobClient sharedClient];
    
    [client getCaptchaIDWithSuccess:^(ClutchMobCaptchaResponse * _Nonnull serverResponse) {
        self.captchaID = [NSString stringWithString:serverResponse.captchaId];
        NSString *url = [NSString stringWithFormat:@"http://localhost:8181/captcha/show/%@", serverResponse.captchaId];
        [self.captchaViewController setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]];
        
    } failure:nil];
}

// Test out demographics field listing
- (IBAction)listFieldsClicked:(id)sender {
    id client = [ClutchMobClient sharedClient];
    [client listFields:^(ClutchMobListFieldsResponse * _Nonnull serverResponse) {
        NSLog(@"Field count: %lu", [serverResponse.primaryFields count]);
    } failure:nil];
}

// Test subscription list listing
- (IBAction)listListsClicked:(id)sender {
    id client = [ClutchMobClient sharedClient];
    [client listSubscriptionLists:^(ClutchMobListSubscriptionListsResponse * _Nonnull serverResponse) {
        NSLog(@"List count: %lu", [serverResponse.subscriptionLists count]);
    } failure:nil];
}

// Test profile views
- (IBAction)getProfileClicked:(id)sender {
    id client = [ClutchMobClient sharedClient];
    [client getProfile:_token withSuccess:^(ClutchMobProfileViewResponse *serverResponse) {
        NSLog(@"Got profile, segment count: %lu", [serverResponse.segments count]);
        if([serverResponse.emailSubscriptionLists[@"0b214c75-f367-44f9-a530-e3061e7f8fcb"] boolValue]) {
            NSLog(@"Opted in to 0b214c75-f367-44f9-a530-e3061e7f8fcb");
        }
        if([serverResponse.balances objectForKey:@"Points"] != nil) {
            double pointsAmount = [serverResponse.balances[@"Points"] doubleValue];
            NSLog(@"Points: %f", pointsAmount);
        } else {
            NSLog(@"Points: 0");
        }
    } failure:nil];
}

// Test demographics updates by updating the first name
- (IBAction)updateFirstNameClicked:(id)sender {
    id client = [ClutchMobClient sharedClient];
    NSString *newFirstName = [_firstNameField text];
    
    NSMutableDictionary *primaryFields = [[NSMutableDictionary alloc] init];
    [primaryFields setValue:newFirstName forKey:@"firstName"];
    NSMutableDictionary *customFields = [[NSMutableDictionary alloc] init];
    
    [client updateDemographics:_token withPrimaryFields:primaryFields andCustomFields:customFields withSuccess:^(ClutchMobBasicResponse *serverResponse) {
        NSLog(@"Updated first name");
    } failure:nil];
}

- (IBAction)inputFieldEdited:(id)sender {
}

@end
