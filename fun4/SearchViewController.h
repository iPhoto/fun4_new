//
//  SearchViewController.h
//  fun4
//
//  Created by Ni Yan on 4/13/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "searchCriteriaProtocol.h"
#import <AVFoundation/AVFoundation.h>
#import <Slt/Slt.h>
#import <OpenEars/FliteController.h>
#import "DynamicSpeechRecognition.h"

@interface SearchViewController : UIViewController <SearchCriteriaProtocol, UITextFieldDelegate, DynamicSpeechRecognitionDelegate>

@property (strong, nonatomic) FliteController *fliteController;
@property (strong, nonatomic) Slt *slt;
@property (nonatomic, strong) DynamicSpeechRecognition *voiceRecognition;

@property (strong, nonatomic) IBOutlet UITextField *destInput;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
- (IBAction)goAction:(id)sender;
- (IBAction)searchAction:(id)sender;

@property (strong, nonatomic) NSString *destionation;

@end
