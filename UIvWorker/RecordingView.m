//
//  Tab1.m
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RecordingView.h"
#import "ContentDetailsView.h"
#import "Screen2.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "MyContentView.h"
#import "AudioToolbox/AudioToolbox.h"
#import "AudibleMagicSmartSync.h"
#import "ContentTypeCoupon.h"
#import "QuartzCore/CAAnimation.h"
#import "RealTimeFeedView.h"

@implementation RecordingView

@synthesize RealTimeFeedView;

static float const recordLengthSeconds = 15;
static NSString* notIdentifiedMessage = @"Sorry, I don't know that one!";
static NSString* listeningMessage = @"Listening..";

@synthesize LevelMeter;
@synthesize lblNotFound;
@synthesize ivSmallRing;
@synthesize ivLargeRing;
@synthesize ivMediumRing;
@synthesize swRealIdentify;


@synthesize btnStartRecord;
@synthesize scChooseID;
@synthesize scChooseOp;

@synthesize btnCancel;
@synthesize ActivityIndicator, MyContentViewReference;


// The initialize message is sent to each class before it receives any other message, 
// ensuring that the application's defaults are set before the application needs to read them.
+ (void)initialize {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // set the app version preference entry
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    [defaults setObject:appVersion forKey:@"version_title"];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"סנכרן אותי", @"Tab1");
        self.navigationItem.title = @"AdHear";
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"bot-icon-record" ofType: @"png"]];
        
        self.tabBarItem.image = img;
        

    
    }
    return self;
}


-(void)Init
{
    
    
    NSError* error = nil;
    canRecord = FALSE;
    isOnlyMetering = true;
    recorder = [AVAudioRecorder alloc]; //allocate the recorder
    
	// Do any additional setup after loading the view, typically from a nib.
    //setup the audio recorder
    //Instanciate an instance of the AVAudioSession object.
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    //Setup the audioSession for playback and record. 
    //We could just use record and then switch it to playback leter, but
    //since we are going to do both lets set it up once.
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
    //Activate the session
    [audioSession setActive:YES error: &error];
    
    
    recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC  ] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100] forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [recordSetting setValue:[NSNumber numberWithInt: 16] forKey:AVEncoderBitRatePerChannelKey];
    [recordSetting setValue:[NSNumber numberWithInt:AVAudioQualityMax] forKey:AVEncoderAudioQualityKey];
    
    
    [self InitRecorderForMetering];
    
   
}

-(bool)newAMObject
{
    //AM config path
    NSString* configFileName = @"Roey_ForTesting_MediaSyncLookup_Local_HalfPrecision_Normalized_20111128_1603_V4";
    configFilePath = [[NSBundle mainBundle] pathForResource:configFileName ofType:@"config"];
    
    // initialize the MFCBR object
    amObject = [[AudibleMagicSmartSync alloc] init];
    
    
    bool success = [amObject mfcbrInitialize:configFilePath];
    if (!success) {
        
        //lblAppVersion.text = amObject.errorMessage;
        NSLog(@"Failed to init mfcbr!!");
        return FALSE;
        
    } 
    
    // Set the local reference database
    [self setLocalDatabase];
    if (!success) {
        
        NSLog(@"Failed to set database!!");

        //lblAppVersion.text = amObject.errorMessage;
        return FALSE;
        
    }     
    
    NSString *myAppVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];       

    
    // This is the selector that will be called each time an identification is made
    // It might be called as often as specified in the config file LookupFrequencyInSeconds
    [amObject registerCallback:@selector(idMade:) :self];
    
        
    return true;
    
}

							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle



- (void)viewDidLoad
{
    [super viewDidLoad];
    audioLevelTimer = nil;
    
    [self ResetUI];
    [self Init];
    
    
   

    //init the am object
    //bool res = [self newAMObject]; //init active amobject

//    if (!res)
//    {
//        NSLog(@"Failed to init AMObject!!");
//        self.lblNotFound.text = @"Unable to initialize!";
//    }
    
}


-(void)disposeAMObject
{

        [amObject stopListening];
        [amObject mfcbrTerminate];
    amObject = nil;
}




- (BOOL) setLocalDatabase
{
    
    static BOOL localDBToggle = NO;
    localDBToggle = !localDBToggle;
    
    NSString *databaseFileName;
    
    if (localDBToggle) {
        
        databaseFileName = @"AmazingRace";
        
    } else {
        
        databaseFileName = @"AmazingRace";
        
    }
    
    // Get the path to the resource
    NSString *databaseFilePath = [[NSBundle mainBundle] pathForResource:databaseFileName ofType:@"amdb"];
    
    BOOL success = [amObject setLocalDatabase:databaseFilePath];  
    
    return success;
    
}




-(void)startMetering
{
    [recorder record];
    recorder.MeteringEnabled = TRUE;
    if (audioLevelTimer == nil)
    {
        
        audioLevelTimer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(doLevelMetering)
                                               userInfo:nil
                                                repeats:YES];
    }
    
}

-(void)stopMetering
{
    [recorder stop];
    recorder.meteringEnabled = FALSE;
    [audioLevelTimer invalidate];
    audioLevelTimer = nil;
}


-(void)InitRecorderForMetering
{
    //Setup the recorder to use this file and record to it.
    NSURL* dummyFileForMetering = [NSURL fileURLWithPath:@"/dev/null"];
    NSError* error = nil;
    recorder = [recorder initWithURL:dummyFileForMetering settings:recordSetting error:&error];

    //Use the recorder to start the recording.
    recorder.delegate = self;
    
    [recorder prepareToRecord];
    
    
}

-(void)doLevelMetering
{
    [recorder updateMeters];
    float peakPower1 =  [recorder averagePowerForChannel:0];
    float peakPower2 =  [recorder averagePowerForChannel:1];
    float linear1 = pow (10, peakPower1 / 20);
    float linear2 = pow (10, peakPower2 / 20);
    
    linear1 *= 2;
    
    if (linear1 <= 0.1)
    {
        
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dark" ofType: @"png"]];
        [LevelMeter setImage:img];
    }
    else if (linear1 > 0.1 && linear1 <= 0.2)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2-bar" ofType: @"png"]];
        [LevelMeter setImage:img];
    }
    else if (linear1 > 0.2 && linear1 <= 0.3)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"4-bar" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }
    else if (linear1 > 0.3 && linear1 <= 0.4)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"6-bar" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }
    else if (linear1 > 0.4 && linear1 <= 0.5)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"8-bar" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }
    else if (linear1 > 0.5 && linear1 <= 0.6)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"10-bar" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }
    else if (linear1 > 0.6 && linear1 <= 0.7)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"12-bar" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }
    else if (linear1 > 0.7 && linear1 <= 0.8)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"14-bar" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }
    else if (linear1 > 0.8 && linear1 <= 0.9)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"16-bar" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }
    else if (linear1 > 0.9)
    {
        UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"colored" ofType: @"png"]];
        [LevelMeter setImage:img];    
    }

    
}

- (void)viewDidUnload
{
    // stop listening and free MFCBR objects
    [self disposeAMObject];
    
    [self setBtnStartRecord:nil];

    [self setBtnCancel:nil];
    [self setActivityIndicator:nil];
    [self setLevelMeter:nil];

    [self setLblNotFound:nil];
    [self setSwRealIdentify:nil];
    [self setScChooseID:nil];
    [self setIvSmallRing:nil];
    [self setIvLargeRing:nil];
    [self setIvMediumRing:nil];
    [self setScChooseOp:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //change nav bar to purple
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:23/255.0 green:13/255.0 blue:176/255.0 alpha:1.0];//[UIColor colorWithRed:64/255.0 green:0/255.0 blue:128/255.0 alpha:1.0];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
   
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations. Currently portrait and upside down portrait supported.
    if ((interfaceOrientation == UIInterfaceOrientationPortrait) ||
        (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown))
        return YES;
    
    return NO;
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees
{
    
    CABasicAnimation *fullRotation;
    fullRotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    fullRotation.fromValue = [NSNumber numberWithFloat:0];
    fullRotation.toValue = [NSNumber numberWithFloat:((degrees*M_PI)/180)];
    fullRotation.duration = duration;
    fullRotation.repeatCount = MAXFLOAT;
    
    [image.layer addAnimation:fullRotation forKey:@"anim"];

}



- (IBAction)Identify:(id)sender {

    if (scChooseOp.selectedSegmentIndex == 0)
    {
        ContentTypeGeneral* coup = [ContentTypeGeneral GenerateByID:[NSString stringWithFormat:@"%d", self.scChooseID.selectedSegmentIndex + 1]];
        
        [self.MyContentViewReference HandleNewContent:coup];
        
        ContentDetailsView* contentDetailsView = [[ContentDetailsView alloc] initWithNibName:@"ContentDetailsView" bundle:nil];
        // couponScreen.coupon = coup;
        
        [self.navigationController pushViewController:contentDetailsView animated:YES];
        
        return;
    }
    else if (scChooseOp.selectedSegmentIndex == 1)
    {
        realTimeElapsed = 120;
        realTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                         target:self
                                                       selector:@selector(doRealTimeFeedUpdate)
                                                       userInfo:nil
                                                        repeats:YES];
        return;
    }
    
    [self newAMObject];
    
    //this is the sync mechanism between the ID and the timeout threads
    //if false, then in the case where the AM callback has a race condition with the timer, the timer will win.
    wasIdentified = FALSE;
    wasTimedout = FALSE;
    lblNotFound.text = listeningMessage;
    lblNotFound.hidden = FALSE;
    [self startMetering];
    
    
    int ring1Time = recordLengthSeconds;
    int ring2Time = recordLengthSeconds / 2;
    int ring3Time = recordLengthSeconds * 2;
    
    [self rotateImage:ivSmallRing duration:ring1Time
                curve:UIViewAnimationCurveEaseIn degrees:340];
    [self rotateImage:ivMediumRing duration:ring2Time
                curve:UIViewAnimationCurveEaseIn degrees:-340];
    [self rotateImage:ivLargeRing duration:ring3Time
               curve:UIViewAnimationCurveEaseIn degrees:340];
    
    //bool res = [amObject IdentifyNow];
    [amObject startListening];
    
    btnCancel.hidden = FALSE;
    btnStartRecord.hidden = TRUE;
//    identificationTimer = [NSTimer scheduledTimerWithTimeInterval:recordLengthSeconds
//                                                           target:self
//                                                         selector:@selector(HandleNotIdentified)
//                                                         userInfo:nil
//                                                          repeats:NO];
    
}



-(void)ResetUI
{
    [self stopMetering];
    [self.view.layer removeAllAnimations];
    [ivLargeRing.layer removeAllAnimations];
    [ivMediumRing.layer removeAllAnimations];
    [ivSmallRing.layer removeAllAnimations];
    UIImage *img = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"dark" ofType: @"png"]];
    [LevelMeter setImage:img];
    self.btnStartRecord.hidden = false;
    self.btnCancel.hidden = true;
    lblNotFound.hidden = TRUE;
    
}

-(void)HandleNotIdentified
{
    @synchronized(self)
    {
        if (wasIdentified)
        {
            //we already have an ID - disregard the timeout
            
            [identificationTimer invalidate];
            identificationTimer = nil;
            return;
        }
        [self disposeAMObject];
        //[self newAMObject];
        wasTimedout = TRUE;

    }
    
    [self ResetUI];
    lblNotFound.text = notIdentifiedMessage;    
    lblNotFound.hidden = FALSE;
        
    
}

// This is the callback registered with the AudibleMagicSmartSync object
- (void) idMade :(id) obj {
    
    //[self performSelectorOnMainThread:@selector(postIdentifyOperations:) withObject:obj waitUntilDone:NO];
    NSString* identifiedID = ((AudibleMagicSmartSync*)obj)->amItemId;
    NSString* ID = [self GetIDForMatch:identifiedID];
    NSLog(@"offset : %@" , ((AudibleMagicSmartSync*)obj)->sigOffsetSeconds);
    [self.RealTimeFeedView FeedForSecondsOffset: [((NSString*)((AudibleMagicSmartSync*)obj)->sigOffsetSeconds) intValue]];
    //@synchronized(self)
    //{
    
    
    
    //handle the response
    // }
}



-(NSString*) GetIDForMatch:(NSString*)match
{
    if ([match isEqualToString:@"Cariot - Commercial.mp3"])
    {
        match = @"1";
    }
    if ([match isEqualToString:@"Bauman - Bazooka Joe.mp3"])
    {
        match = @"2";
    }
    if ([match isEqualToString:@"MasterChefKids.mp3"])
    {
        match = @"3";
    }
    return match;
}


-(void) postIdentifyOperations:(id)obj
{
    if (wasIdentified)
    {
        return;
    }
    wasIdentified = TRUE;
    
    //stop the timer immediately.
    //[identificationTimer invalidate];
    //identificationTimer = nil;
    
    //[self stopMetering];
    
    if (scChooseOp.selectedSegmentIndex == 2)
    {
        
        NSString* identifiedID = ((AudibleMagicSmartSync*)obj)->amItemId;
        NSString* ID = [self GetIDForMatch:identifiedID];
        NSLog(@"offset : %@" , ((AudibleMagicSmartSync*)obj)->sigOffsetSeconds);
        [self.RealTimeFeedView FeedForSecondsOffset: [((NSString*)((AudibleMagicSmartSync*)obj)->sigOffsetSeconds) intValue]];

//        ContentTypeGeneral* coup = [ContentTypeGeneral GenerateByID:ID];
//        
//        [self.MyContentViewReference HandleNewContent:coup];
//        
//        ContentDetailsView* contentDetailsView = [[ContentDetailsView alloc] initWithNibName:@"ContentDetailsView" bundle:nil];
//        
//        [self.navigationController pushViewController:contentDetailsView animated:YES];
    }
    else {
        
        
        
    }
    
    
        
}
         
- (void)doRealTimeFeedUpdate
{
    realTimeElapsed++;
    [self.RealTimeFeedView FeedForSecondsOffset:realTimeElapsed];
}

- (IBAction)CancelButton:(id)sender {
    
    @synchronized(self)
    {
        if (wasIdentified)
        {
            return;
        }
    }
    [self disposeAMObject];
    //[self newAMObject];
    [self ResetUI];
    
}
- (IBAction)btnHideControlsTouched:(id)sender {
    
    if (swRealIdentify.hidden)
        swRealIdentify.hidden = false;
    else {
        swRealIdentify.hidden = true;
    }
    if (scChooseID.hidden)
        scChooseID.hidden = false;
    else {
        scChooseID.hidden = true;
    }
    if  (scChooseOp.hidden)
        scChooseOp.hidden = false;
    else {
        scChooseOp.hidden = true;
    }
}
@end
