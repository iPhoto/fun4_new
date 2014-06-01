//
//  SearchViewController.m
//  fun4
//
//  Created by Ni Yan on 4/13/14.
//  Copyright (c) 2014 Ni Yan. All rights reserved.
//

#import "SearchViewController.h"
#import "AttractionsTableViewController.h"

@interface SearchViewController ()

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    self.voiceRecognition.delegate = self;
    
    _destInput.delegate = self;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"launch.png"]]];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self performSegueWithIdentifier:@"searchSegue" sender:self];
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *) destination
{
    return [self.destInput text];
}

- (IBAction)goAction:(id)sender {
}

- (IBAction)searchAction:(id)sender {
    //apple
    AVSpeechUtterance *utterance = [AVSpeechUtterance
                                    speechUtteranceWithString:@"Where do you want to go?"];
    AVSpeechSynthesizer *synth = [[AVSpeechSynthesizer alloc] init];
    [synth speakUtterance:utterance];
    
    //openears, not working for now
    //[self.fliteController say:@"Where do you want to go?" withVoice:self.slt];
    //[self.voiceRecognition startVoiceRecognition];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"searchSegue"])
    {
        AttractionsTableViewController *nextController;
        nextController = segue.destinationViewController;
        nextController.delegate = self;
    }
    
}

- (FliteController *) fliteController
{
    if (_fliteController == nil
        )
    {
        _fliteController = [[FliteController alloc]init];
    }
    
    return _fliteController;
}

- (Slt *)slt {
	if (_slt == nil) {
		_slt = [[Slt alloc] init];
	}
	return _slt;
}

//openears, not working for now
//- (DynamicSpeechRecognition *) voiceRecognition{
//    if (!_voiceRecognition) {
//        _voiceRecognition = [[DynamicSpeechRecognition alloc] init];
//        // All capital letters.
//        _voiceRecognition.words2Recognize = [NSArray arrayWithObjects:@"HOLD", @"HISTORY", @"MAX", @"MIN", @"CHART", @"TABLE", @"CLEAR", @"EXIT", nil];
//        _voiceRecognition.filenameToSave = @"OpenEarsDynamicGrammar";
//        _voiceRecognition.debug = NO;
//        _voiceRecognition.instantSpeak = NO;
//    }
//    return _voiceRecognition;
//}

- (void) getHypothesis:(NSString *)hypothesis{
    NSLog(@"Get the word %@", hypothesis);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


@end
