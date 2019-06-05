//
//  ClutchMobViewController.h
//  ClutchMobileAPI
//
//  Copyright (c) 2019 Clutch. All rights reserved.
//

@import UIKit;

@interface ClutchMobViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *captchaViewController;
@property (weak, nonatomic) IBOutlet UITextField *captchaCodeField;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;


@property (nonatomic, strong) NSString *captchaID;
@property (nonatomic, strong) NSString *token;

- (IBAction)buttonClicked:(id)sender;
- (IBAction)inputFieldEdited:(id)sender;

@end
