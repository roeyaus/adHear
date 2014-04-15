//
//  Tab1.h
//  UIvWorker
//
//  Created by Igor Nakonetsnoi on 04/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AudibleMagicSmartSync.h"


// This is defined in Math.h
#define M_PI   3.14159265358979323846264338327950288   /* pi */

// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle * M_PI / 180.0 )

@class MyContentView, RealTimeFeedView;

@interface RecordingView : UIViewController <AVAudioRecorderDelegate>
{
    NSTimer *audioLevelTimer;
    NSTimer *identificationTimer;
    NSTimer *realTimeTimer;
    CGFloat realTimeElapsed;
    NSURL* recordedTmpFile;
    AVAudioRecorder* recorder;
   // NSError* error;
    BOOL canRecord;
    NSMutableDictionary* recordSetting;
    bool isOnlyMetering;
    bool wasIdentified;
    bool wasTimedout;
    AudibleMagicSmartSync *amObject;
    NSString* configFilePath;
    
}

- (void)rotateImage:(UIImageView *)image duration:(NSTimeInterval)duration 
              curve:(int)curve degrees:(CGFloat)degrees;

-(void) postIdentifyOperations:(NSString*) identifiedID;
-(void) doLevelMetering;
-(void) doRealTimeFeedUpdate;
-(void) startMetering;
-(void) stopMetering;
-(void) Init;
-(void) ResetUI;
-(void) InitRecorderForMetering;
-(void) resetKnob;
-(void) queryAudioScoutServer;
-(void) uploadRecordedSample;
-(void) dismissKeyboard;
-(void) idMade :(id) obj;
-(void)HandleNotIdentified;
-(BOOL) setLocalDatabase;
-(NSString*) GetIDForMatch:(NSString*)match;
-(bool)newAMObject;

- (IBAction)CancelButton:(id)sender;
- (IBAction)Identify:(id)sender;
- (IBAction)btnHideControlsTouched:(id)sender;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnStartRecord;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scChooseID;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scChooseOp;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *btnCancel;
@property (unsafe_unretained, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (unsafe_unretained, nonatomic) MyContentView *MyContentViewReference; // This is required to change the items displayed in tab3.
@property (strong, nonatomic) RealTimeFeedView *RealTimeFeedView; //this is a reference to the realtime feed view, which we update once we have ID'd the content playing

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *LevelMeter;



@property (weak, nonatomic) IBOutlet UILabel *lblNotFound;
@property (weak, nonatomic) IBOutlet UIImageView *ivSmallRing;
@property (weak, nonatomic) IBOutlet UIImageView *ivLargeRing;
@property (weak, nonatomic) IBOutlet UIImageView *ivMediumRing;

@property (weak, nonatomic) IBOutlet UISwitch *swRealIdentify;

@end
