//
//  AudibleMagicSmartSync.m
//  SmartSyncSample
//
//  Created 9/9/11.
//  Copyright 2011 AUDIBLE MAGIC CORPORATION. All rights reserved.
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

#import "AudibleMagicSmartSync.h"
#define MF_ERROR_STRING_LENGTH          (100)
#define MF_VERSION_STRING_LENGTH        (20)

//Private interfaces
@interface AudibleMagicSmartSync () 

- (void) setAmItemId :(NSString *)theAmItemId;
- (void) setSigOffset :(NSString *)theSigOffset;
- (NSString *) mfcbrGetErrorDescription :(int)err ;

@end


//Main implementation
@implementation AudibleMagicSmartSync
@synthesize amItemId, sigOffsetSeconds, errorMessage, libraryVersion, callbackObject, callbackSelector;

//Define variables to be used inside the C routine that is called from the library
AudibleMagicSmartSync *myObj; //Used for C to call to Objective-c
SEL         callbackSelector;
id          callbackObject;
void mfcbrMediaIDCallback(void* userData, MFMediaIDResponse* response);

#pragma mark - life cycle

- (void) dealloc {
    
    myObj = nil;
}

#pragma mark - public calls

- (bool) IdentifyNow
{
    MFMediaIDResponse response;
    NSString* foundAmItemId = nil;
    MFError err;
    err = MFMediaID_IdentifyNow(mediaID, &response);
    if (err != MF_SUCCESS)
    {
        NSLog(@"IdentifyNow Failed with error number : %d", err);
        errorMessage = [[NSString alloc] 
                        initWithFormat:@"Identify failed, %@", 
                        [self mfcbrGetErrorDescription:err]];
        NSLog(@"%@", errorMessage);
        return false;
    }

    NSString* responseXML = [myObj getXMLFromResponse:response];
    if (responseXML != nil)
    {
        // Note that each response has only one IdDetail section. Imagine that you have a database with several 
        // episodes of the same TV show, eaching having a common introduction audio segment. In that case, the
        // identification library will return a hit in one of the references, but which one is arbitrary.
        
        // extract the AMItemId
        foundAmItemId = [myObj extractToken:responseXML :@"AMItemId"];
        
        if (foundAmItemId) {
            
            [myObj setAmItemId:foundAmItemId];
            return true;
        }
    }
    else {
        errorMessage = [[NSString alloc] 
                        initWithFormat:@"Identify failed", 
                        [self mfcbrGetErrorDescription:err], err];
        NSLog(@"Identify failed");
    }
    
    return false;
       

}

- (void) registerCallback :(SEL) theCallbackSelector :(NSObject *) theCallbackObject{
    
    callbackObject = theCallbackObject;
    callbackSelector = theCallbackSelector;
    
}

- (NSString *) stopListening {
    
    NSLog(@"AMInfo: Stop Listening");
    
    errorMessage = nil;
    
    if (isMfcbrListening) {

        isMfcbrListening = NO;
        
        MFError err = MFMediaID_StopListening(mediaID);
        if (err != MF_SUCCESS) {
            errorMessage = [[NSString alloc] 
                            initWithFormat:@"MFMediaID_StopListening failed! Error was %@ (%i)", 
                            [self mfcbrGetErrorDescription:err], err];
            NSLog(@"AMERROR in stopListening: %@", errorMessage);
            
        }
        
    } else {
        
        errorMessage = @"AMInfo: stopListening called when not listening";
        NSLog(@"%@",errorMessage);
        
    }
    
    return errorMessage;
}


- (NSString *) startListening {
    
    NSLog(@"AMInfo: Start Listening");
    
    errorMessage = nil;
    
    if (!isMfcbrListening) {
        
        MFError err = MFMediaID_StartListening(mediaID);
        if (err != MF_SUCCESS) {
            errorMessage = [[NSString alloc] 
                            initWithFormat:@"MFMediaID_StartListening failed! Error was %@ (%i)", 
                            [self mfcbrGetErrorDescription:err], err];
            NSLog(@"AMERROR in startListening: %@", errorMessage);
            
            
        } else {
            
            isMfcbrListening = YES;  
            
        }
        
    } else {
        
        errorMessage = @"AMInfo: startListening called when already listening";
        NSLog(@"%@",errorMessage);
        
    }
    
    return errorMessage;
}


#pragma mark - XML Parsing

/*
 * Extract a token's value from an xml string.  Returns nil if token wasn't found or was empty.
 * NOTE: Returns the first instance of the token if there happens to be multiple occurrences in the string.
 * This is a simple parsing function. In reality, your application should use an XML DOM
 */

- (NSString *)extractToken :(NSString *)xml :(NSString *)token {
    NSString *value = nil;
    
    // Setup an NSError object to catch any failures
    NSError *error = NULL;	
    
    // construct the pattern
    NSString *pattern = [[NSString alloc] initWithFormat:@"<%@>(.+)</%@>", token, token];
    
    // create a NSRegularExpression object and initialize it with a pattern, with option case insensitive
    NSRegularExpression *regex = [NSRegularExpression 
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive 
                                  error:&error];
    
    // use firstMatchInString because we're only looking for one match
    NSTextCheckingResult *result = [regex firstMatchInString:xml options:0 range:NSMakeRange(0, [xml length])];
    if (result) {
        // [match rangeAtIndex:1] gives the range of the group in parentheses
        NSRange range = [result rangeAtIndex:1];            
        if (!NSEqualRanges(range, NSMakeRange(NSNotFound, 0))) {
            // Since we know that we found a match, get the substring from the parent string by using our NSRange object
            value = [xml substringWithRange:range];
            //NSLog(@"Extracted '%@' token: %@", token, value);
        }
    }
    
    return value;
}


#pragma mark - MFCBR to Objective-C 

// Called by MFCBR Callback.

- (void) setAmItemId :(NSString *)theAmItemId {
    

    amItemId = theAmItemId;
    
}

- (void) setSigOffset :(NSString *)theSigOffset {
    

    sigOffsetSeconds = theSigOffset; 

}


#pragma mark - MFCBR API

- (NSString *) mfcbrGetErrorDescription :(int)err {
    
    NSString *errorDescription = nil;
    
    char bufErrDesc[MF_ERROR_STRING_LENGTH];
    
    MFGetErrorDescription(err, (MFString) bufErrDesc, MF_ERROR_STRING_LENGTH);
    
    errorDescription = [[NSString alloc] initWithCString:bufErrDesc encoding:NSMacOSRomanStringEncoding];
    
    return errorDescription;
}

- (BOOL) mfcbrInitialize :(NSString *)configResourcePath {
    
    MFError err = MF_SUCCESS;
    errorMessage = nil;
    
    if (!configResourcePath) {
        
        errorMessage = [[NSString alloc] initWithFormat:@"AMError in mfcbrInitialize: configResourcePath is nil"];
        NSLog(@"mfcbrInitialize ERROR: %@", errorMessage);
        return NO;
        
    }    
    
    if (myObj) {
        

        errorMessage = @"AMERROR in mfcbrInitialize: AudibleMagicSmartSync Object has already been initialized";
        return NO;
        
    } else {
        
        myObj = self;
        
    }
    
    isMfcbrListening = NO;
    
    // get the MFCBR version
    char bufVersion[MF_VERSION_STRING_LENGTH];
    
    MFGetLibraryVersion(bufVersion, MF_VERSION_STRING_LENGTH);
    
    NSString *appVersion = [[NSString alloc] initWithCString:bufVersion encoding:NSMacOSRomanStringEncoding];

    libraryVersion = appVersion;
    
    // create the MFCBR MediaID object using the config file
    NSLog(@"AMInfo: Loading config file \n'%@'", configResourcePath);
    const char* pStrFilePath1 = [configResourcePath UTF8String];
    
    
    err = MFMediaID_CreateUsingConfigFile(&mediaID, (MFFilePath) pStrFilePath1);
    if (err != MF_SUCCESS) {
        errorMessage = [[NSString alloc] 
                         initWithFormat:@"MFMediaID_CreateUsingConfigFile failed! Error was %@ (%i)", 
                         [self mfcbrGetErrorDescription:err], err];
        NSLog(@"mfcbrInitialize ERROR: %@", errorMessage);
        return NO;
    }
    
    // register the callback routine that is invoked when a lookup results in a hit
    //
    // This call sets up a callback to receive ID notifications in a continuous manner. 
    // If a remote ID server is specified in the configuration file, it will be used as well.
    //
    //
    err = MFMediaID_RegisterCallback(mediaID, &mfcbrMediaIDCallback, mfcbrUserData);
    if (err != MF_SUCCESS) {
        errorMessage = [[NSString alloc] 
                         initWithFormat:@"MFMediaID_RegisterCallback failed! Error was %@ (%i)", 
                         [self mfcbrGetErrorDescription:err], err];
        NSLog(@"AMERROR in mfcbrInitialize: %@", errorMessage);
        return NO;
    }

    
    return YES;
}

- (BOOL) setLocalDatabase  :(NSString *)databaseResourcePath {
    
    // Set the local reference database - create this file with the amDBGen utility in the SDK
    
    MFError err = MF_SUCCESS;
    errorMessage = nil;
    
    if (!databaseResourcePath) {
        
        errorMessage = [[NSString alloc] initWithFormat:@"AMError in setLocalDatabase: databaseResourcePath is nil"];
        NSLog(@"AMERROR in setLocalDatabase: %@", errorMessage);
        return NO;
        
    }
    
    
    // if we are listening, then stop listening before updating the local database
    
    BOOL wasListening = NO;
    
    if (isMfcbrListening) {
        
        wasListening = YES;
        
        NSString *errString = [self stopListening];
        if (errString != nil) {
            
            return NO;
            
        }
            
    }
    
    NSLog(@"AMInfo: Loading database file \n'%@'", databaseResourcePath);
    const char* pStrFilePath2 = [databaseResourcePath UTF8String];
    
    err = MFMediaID_SetDatabase(mediaID, (MFFilePath) pStrFilePath2);
    if (err != MF_SUCCESS) {
        errorMessage = [[NSString alloc] 
                        initWithFormat:@"MFMediaID_SetDatabase failed! Error was %@ (%i)", 
                        [self mfcbrGetErrorDescription:err], err];
        NSLog(@"AMERROR in setLocalDatabase: %@", errorMessage);
        return NO;
    }   
    
    
    if (wasListening) {
        
        NSString *errString = [self startListening];
        if (errString != nil) 
            return NO;
        
    }
    
    return YES;
    
}

- (void) mfcbrTerminate {
    
    if (mediaID) {
        if (isMfcbrListening) {
            MFMediaID_StopListening(mediaID);
        }
        
        MFMediaID_Destroy(&mediaID);
    }
    myObj = nil;
    
}

- (NSString *) getXMLFromResponse: (MFMediaIDResponse*) response;
{
    int length = 0;
    MFError err = MF_SUCCESS;
    MFString strResponse = 0;
    NSString *responseXML = nil;
    
    MFError MF_CALLCONV MFMediaIDResponse_GetIDStatus(MFMediaIDResponse response, MFResponseStatus* status);
    
    if (!response)
    {
        err = MF_NULL_POINTER;
        errorMessage = [[NSString alloc] 
                        initWithString:@"Could not allocate memory for the response string."];
    }
    else {
        
        err = MFMediaIDResponse_GetStringLength(*response, &length);
        if (err == MF_SUCCESS) {
            
            strResponse = (char*) calloc(length, sizeof(char)); // free this before exiting below
            
            if (strResponse) {
                
                err = MFMediaIDResponse_GetAsString(*response, strResponse, length);
                
                if (err == MF_SUCCESS) {
                    
                    responseXML = [[NSString alloc] initWithCString:strResponse encoding:NSMacOSRomanStringEncoding] ;
                    
                    
                } else {
                    // MFMediaIDResponse_GetAsString failed 
                    errorMessage = [[NSString alloc] 
                                    initWithFormat:@"MFMediaIDResponse_GetAsString failed! Error was %@ (%i)", 
                                    [myObj mfcbrGetErrorDescription:err], err];
                }
                
            } else {
                // calloc failed
                errorMessage = [[NSString alloc] 
                                initWithString:@"Could not allocate memory for the response string."];
            }
            
        } else {
            // MFMediaIDResponse_GetStringLength failed
            errorMessage = [[NSString alloc] 
                            initWithFormat:@"MFMediaIDResponse_GetStringLength failed! Error was %@ (%i)", 
                            [myObj mfcbrGetErrorDescription:err], err];
        }
    }
    if (strResponse) {
        
        free(strResponse);
    }
    return responseXML;
}



// This is where the magic happens
// Called when the audio identification library makes a positive identification

void mfcbrMediaIDCallback(void* userData, MFMediaIDResponse* response) { 
    
    // NOTE: This callback will be running on a second thread. Any calls back to the main object 
    // need to use the performSelectorOnMainThread or else you will not see the GUI change.
    
  
    NSString *foundAmItemId = nil;
    NSString *errorMessage = nil;
    NSString* responseXML = [myObj getXMLFromResponse:response]; 
    if (responseXML != nil)
    {
    //NSLog(@"mfcbrMediaIDCallback Entered.");
    
                      // Note that each response has only one IdDetail section. Imagine that you have a database with several 
                    // episodes of the same TV show, eaching having a common introduction audio segment. In that case, the
                    // identification library will return a hit in one of the references, but which one is arbitrary.
                    
                    // extract the AMItemId
                    foundAmItemId = [myObj extractToken:responseXML :@"AMItemId"];
                    
                    if (foundAmItemId) {
                        
                        [myObj setAmItemId:foundAmItemId];
                        
                        NSString *sigOffset = [myObj extractToken:responseXML :@"SigOffset"];
                        NSString *matchDuration = [myObj extractToken:responseXML :@"MatchDuration"];
                        float offsetAtEnd = [sigOffset floatValue] + [matchDuration floatValue];
                        //NSLog(@"Id Engine Match: %@ at offset %6.2f", foundAmItemId, offsetAtEnd);
                        
                        NSString *offsetAtEndString = [[NSString alloc] initWithFormat:@"%6.2f", offsetAtEnd];
                        [myObj setSigOffset:offsetAtEndString];
                        
                        [[myObj callbackObject] performSelectorOnMainThread:[myObj callbackSelector]  withObject:myObj waitUntilDone:NO];
                        
                    } else {
                        // couldn't extract the AMItemID token from the response
                        errorMessage = [[NSString alloc] 
                                         initWithString:@"Could not extract the AMItemId from the response."];
                    }
    }
    else {
        errorMessage = [[NSString alloc] 
                        initWithString:@"response XML is nil"];
    }
    if (!foundAmItemId) 
        NSLog(@"AMWARNING: mfcbrMediaIdCallback ended without finding an AmItemId");
    
    if (errorMessage) 
        NSLog(@"AMERROR in mfcbrMediaIdCallback:%@",errorMessage);
    
   
    

}

@end

