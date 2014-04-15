//
//  AudibleMagicSmartSync.h
//  SmartSyncSample
//
/*
 *----------------------------------------------------------------------------
 * Copyright notice:
 * (c) Copyright 2011 Audible Magic
 * All rights reserved.
 *
 * This program is protected as an unpublished work under the U.S. copyright
 * laws. The above copyright notice is not intended to effect a publication of
 * this work.
 *
 * This program is the confidential and proprietary information of Audible
 * Magic.  Neither the binaries nor the source code may be redistributed 
 * without prior written permission from Audible Magic. 
 *----------------------------------------------------------------------------
 */

//  NOTE: This file is a reference implementation of how to call the Audible Magic identification engine
//        for media synchronization applications. It is distributed under the Audible Magic Corporation
//        software licenses. You should modify this file as needed to suit your application.
//

//  NOTE: You must modify the MainViewController viewDidLoad to set your config file correctly.


/* NOTE
    Projects which include this module and libmfcbroem_ios.h MUST include the following
    frameworks and libraries in the Build/Link step
 
    CFNetwork
    AVFoundation
    CoreAudio
    MobileCoreServices
    MessageUI
    SystemConfiguration
    AudioToolbox
    libz.1.2.3
 
*/

#import <Foundation/Foundation.h>
#include "mfErrors_oem.h"
#include "MF_MediaID_api.h"

@interface AudibleMagicSmartSync : NSObject {
    
@public
        
    NSString    *libraryVersion;
    NSString    *amItemId;
    NSString    *sigOffsetSeconds;
    NSString    *errorMessage;
    
@private
    
    bool isMfcbrListening;     
    MFMediaID mediaID;
    char *mfcbrUserData;
    MFMediaIDResponse mfcbrResponse;    
    
}

@property (readonly, strong, nonatomic) NSString *amItemId;
@property (readonly, strong, nonatomic) NSString *sigOffsetSeconds;
@property (readonly, strong, nonatomic) NSString *libraryVersion;
@property (readonly, strong, nonatomic) NSString *errorMessage;
@property (readonly) SEL callbackSelector;
@property (readonly, strong, nonatomic) id callbackObject;

- (BOOL) mfcbrInitialize :(NSString *)configResourcePath ;
- (BOOL) setLocalDatabase  :(NSString *)databaseResourcePath;
- (void) registerCallback :(SEL) theCallbackSelector :(NSObject *) theCallbackObject;
- (NSString *) startListening;
- (NSString *) stopListening;
- (NSString *) getXMLFromResponse: (MFMediaIDResponse*) response;
- (void) mfcbrTerminate;
- (bool) IdentifyNow;

@end
