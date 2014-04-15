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
 *
 * File: MF_MediaID_api.h
 */

#ifndef _mf_mediaid_api_h
#define _mf_mediaid_api_h

#include "mfGlobals.h"
#include "mfErrors_oem.h"
#include "mfMacros.h"

#ifdef __cplusplus
extern "C" {
#endif

/*--------------------- Media Identification Request API ----------------------*/

#define MF_ERROR_STRING_LENGTH 		(100)
#define MF_VERSION_STRING_LENGTH 	(20)

typedef void* MFMediaID;	   /* this object holds information about the client application */
				   /* it can be initialized once and used to identify many files */

typedef void* MFMediaIDResponse;   /* this object represents the response from the server */
				   /* There are a few routines to help extract the nature of the response */

typedef void* MFMediaIDRequest;    /* this object represents the ID request that will be sent to the server */

/* 
 * This defines a callback function, used in a continuous-monitoring scenario of the "embedded API." 
 * It receives the result of a positive identification ("hit") whenever one is available.
 * See MFMediaID_RegisterCallback() below.
 * The API user must invoke MFMediaIDResponseDestroy() when done using the response object.
 */
typedef void (*MFMediaIDCallback)(void* userData, MFMediaIDResponse* response); 

typedef enum 
{
    MF_MEDIAID_RESPONSE_UNKNOWN = 0,	/* the server returned some sort of error condition */
    MF_MEDIAID_RESPONSE_NOT_FOUND,	/* we did not find this file in our database */
    MF_MEDIAID_RESPONSE_FOUND		/* this file matched a known file in our database */
} MFResponseStatus;

typedef enum
{
    MF_16BIT_SIGNED_LINEAR_PCM
} MFSampleFormat;


/***************************************************************/
/* General utility functions
 ***************************************************************/
/*
 * Get the version of the library.
 * We recommend this function called and the string displayed so that it can be returned in
 * when issues are reported back to Audible Magic.
 * length should be at least MF_VERSION_STRING_LENGTH to return the full string.
 * If less, the string will be truncated.
 */
MFError MF_CALLCONV MFGetLibraryVersion(MFString strVersion, int strLen);

/*
 * Convert an error number to a human-readable string.
 * length should be at least MF_ERROR_STRING_LENGTH to return the full string.
 * If less, the string will be truncated.
 */
MFError MF_CALLCONV MFGetErrorDescription(MFError err, MFString strDescription, int strLen);


/***************************************************************/
/* MFMediaID object: functions to create and destroy
 ***************************************************************/

/* 
 * The create routines to construct the MFMediaID object require a configuration file supplied 
 * by Audible Magic. The first form will use the first .config file found in the current directory.  
 * The second form lets the caller specify a particular file.
 */
MFError MF_CALLCONV MFMediaID_Create(MFMediaID* mediaID);
MFError MF_CALLCONV MFMediaID_CreateUsingConfigFile(MFMediaID* mediaID, MFFilePath strPathToConfigFile);
MFError MF_CALLCONV MFMediaID_CreateUsingXMLString(MFMediaID* mediaID, const char* strXML);

/* 
 * When you are all done identifying media, call MFMediaID_Destroy() to clean up the 
 * memory allocated for this object.  Notice that you will be sending the ADDRESS of the MFMediaID 
 * pointer.  This is so that MFMediaID_Destroy() can set your local variable to NULL after the
 * memory is freed.
 */
MFError MF_CALLCONV MFMediaID_Destroy(MFMediaID* mediaID);

/***************************************************************/
/* MFMediaID object: functions to request identification of user-supplied media
 ***************************************************************/

/* 
 * This is the main call to identify a file. A variety of errors can occur that can prevent 
 * an identification. Error codes are listed in the file mfErrors_oem.h.
 * If no error is returned (MF_SUCCESS), then the response structure will have more information 
 * about the file. However, sometimes, a server error, or other problem will occur which will not 
 * be returned as an error.  You must call MFMediaIDResponse_GetIDStatus() to find out the 
 * dispensation of the file (as an MFResponseStatus enum - defined above).
 * Call MFMediaIDResponse_GetAsString() to get the server response in an ascii string format.  
 * If the file was FOUND in our database, then the string will contain an xml object representing 
 * the metadata associated with that file.  It is up to the user to parse the xml object to extract 
 * the specific fields that he/she is interested in.  
 * You must supply the complete path to the filename in strMediaFile, and you must create a unique 
 * string that helps you uniquely identify the file that you are requesting identification of.  
 * The strAssetID will be associated with this request and will be returned in the XML metadata 
 * structure.
 * The MFMediaIDResponse will be created by this function, you will need to call 
 * MFMediaIDResponse_Destroy() when you are done with the response data.
 */
MFError MF_CALLCONV MFMediaID_GenerateAndPostRequest(MFMediaID mediaID, MFFilePath strMediaFile, 
  MFString strAssetID, MFMediaIDResponse* response);

/*
 * Same as the call above but takes a buffer of samples instead of a path to a file.
 *
 * This sample-based API does not use FFMPEG.  If you use the no-FFMPEG library configuration
 * then you must use this variation of the API. Calling  MFMediaID_GenerateAndPostRequest()
 * will result in MF_CALLING_PROGRAM_ERROR (error return code = 4).
 */
MFError MF_CALLCONV MFMediaID_GenerateAndPostRequestFromSamples(MFMediaID mediaID, const void* samples, 
  int numFrames, float sampleRate, int numChannels, MFSampleFormat sampleFormat, MFConstString strAssetID, 
  MFMediaIDResponse* response);

/*
 * Some users need to handle the posting themselves. The following two calls are 
 * similar to the two calls above, but produce an MFMediaIDRequest object which can 
 * then be posted with the MFMediaID_PostRequest call.
 *
 * Note that you will need to call MFMediaIDRequest_Destroy() when you are done 
 * calling MFMediaID_PostRequest().
 */
MFError MF_CALLCONV MFMediaID_GenerateRequest(MFMediaID mediaID, MFFilePath strMediaFile, 
  MFConstString strAssetID, MFMediaIDRequest* request);

/*
 * Same as the call above but takes a buffer of samples instead of a path to a file.
 *
 * This sample-based API does not use FFMPEG.  If you use the no-FFMPEG library configuration
 * then you must use this variation of the API. Calling  MFMediaID_GenerateAndPostRequest()
 * will result in MF_CALLING_PROGRAM_ERROR (error return code = 4).
 */
MFError MF_CALLCONV MFMediaID_GenerateRequestFromSamples(MFMediaID mediaID, const void* samples, 
  int numFrames, float sampleRate, int numChannels, MFSampleFormat sampleFormat, 
  MFConstString strAssetID, MFMediaIDRequest* request);

/*
 * Used to perform the post operation. Returns an MFMediaIDResponse object.
 *
 * Note that it's the caller's responsibility to deallocate the request and the 
 * response by calling the MFMediaIDRequest_Destroy() and MF_MediaIDResponse_Destroy() 
 * when done with them.
 */
MFError MF_CALLCONV MFMediaID_PostRequest(MFMediaID mediaID, MFMediaIDRequest request, 
  MFMediaIDResponse* response);


/***************************************************************/
/* MFMediaID object: functions to request identification of audio input
 * captured by the library itself (a.k.a. "embedded API" functions)
 *
 * The following functions are for situations where the caller does not 
 * supply the input media but instead lets the library generate audio 
 * fingerprints from the platform's default audio input 
 * (typically a microphone).  Identifications can be made from a remote 
 * ID server (depending on a configuration file setting) and/or from a locally 
 * maintained database.  The identification requests can be made either 
 * automatically on a continuous basis (at a frequency specified by the 
 * configuration file) or else "manually" by the caller, one at a time.
 */
/***************************************************************/

/*
 * Tell the library the callback function to invoke whenever a positive ID
 * has been made.  
 * mediaID must have been created using the MFMediaID_Create call (or one of its variants). 
 * userData is a pointer to caller-provided data that the library ignores but returns 
 * in the callback; it may be NULL.
 * This function sets up the continuous-monitoring scenario, as opposed to
 * the on-demand ID request of MFMediaID_IdentifyNow().  However, the callback will not be
 * invoked until MFMediaID_StartListening() has been called.
 */
MFError MF_CALLCONV MFMediaID_RegisterCallback(MFMediaID mediaID, MFMediaIDCallback callback, void* userData); 

/*
 * Optionally tell the library to do local lookups by specifying the path to a local
 * database file.   This option may be disallowed by the configuration file.
 * The database file must have been already created using the amDbGen application, 
 * included with the OEM SDK. 
 * If the configuration file also specifies remote lookups, both will be done
 * in the continuous-monitoring case (in which case the callback will be invoked twice for
 * any fingerprint that happens to gets a positive ID both locally and remotely).  
 * However, only local lookups will be done in the on-demand case, once MFMediaID_SetDatabase() 
 * has been invoked.
 */
MFError MF_CALLCONV MFMediaID_SetDatabase(MFMediaID mediaID, MFFilePath strPathToDatabase);

/*
 * Tell the library to start continuously fingerprinting the default audio input and
 * to start returning any positive IDs via the previously specified callback.
 */
MFError MF_CALLCONV MFMediaID_StartListening(MFMediaID mediaID);

/*
 * Tell the library to stop continuously fingerprinting the default audio input and
 * to stop invoking the callback.
 */
MFError MF_CALLCONV MFMediaID_StopListening(MFMediaID mediaID);

/*
 * Request identification of a single piece of audio from the default audio input.
 * The audio starts at the present moment and lasts for a duration specified in the 
 * configuration file.  The call will block until that duration has passed. 
 * Unlike the continuous-monitoring case, responses are returned whether or not 
 * a positive ID (a "hit") was made.  
 * After invoking this function, you can invoke MFMediaIDResponse functions to detect 
 * whether a hit was made and to get a string describing the results.  You must
 * invoke MFMediaIDResponse_Destroy() when done using the response object.
 */
MFError MF_CALLCONV MFMediaID_IdentifyNow(MFMediaID mediaID, MFMediaIDResponse* response);

/***************************************************************/
/* MFMediaIDRequest object: destroy function
 ***************************************************************/

/*
 * Destroys and deallocates an MFMediaID_PostRequest object that was created and returned
 * by reference in one of the MFMediaID_GenerateRequest... functions.
 */
MFError MF_CALLCONV MFMediaIDRequest_Destroy(MFMediaIDRequest* request);


/***************************************************************/
/* MFMediaIDResponse object: functions to either
 * (1) get information out of the MFMediaIDResponse object that
 * various MFMediaID_ functions create and return by reference or 
 * by callback, or 
 * (2) destroy the MFMediaIDResponse object.
 */
/***************************************************************/

/*
 * Call this function to get the length of the string that will be returned by MFMediaIDResponseGetAsString.
 * You will need to provide your own pre-allocated string to pass into that function, and it should be
 * at least as long as this length to fit all of the response 
 */
MFError MF_CALLCONV MFMediaIDResponse_GetStringLength(MFMediaIDResponse response, int* length);

/*
 * Returns the response as a string to your pre-allocated string.  If the string storage you provide is
 * not large enough an error code will be returned.  The string could be the XML metadata structure, if
 * the file has been FOUND in our database.  Or it could be other responses from the server, such as 
 * 404 error codes, or other error conditions....
 */
MFError MF_CALLCONV MFMediaIDResponse_GetAsString(MFMediaIDResponse response, MFString strResponse, int strLength);

/*
 * If you just want to find out if the file has been FOUND, NOT_FOUND, or the state is NOT_KNOWN,
 * call this function and examine the status value (MFResponseStatus) as an enum defined above.
 */
MFError MF_CALLCONV MFMediaIDResponse_GetIDStatus(MFMediaIDResponse response, MFResponseStatus* status);

/*
 * Each response object is created by API functions and returned to the user by reference.
 * It is up to the API user to call this destroy function when they are done
 * with the response data. 
 * Notice that you are sending the address of the MFMediaIDResponse pointer to the destroy function.
 * This allows the destroy function to set the value of the pointer to NULL.
 */
MFError MF_CALLCONV MFMediaIDResponse_Destroy(MFMediaIDResponse* response);


#ifdef __cplusplus
}
#endif

#endif /* _mf_mediaid_api_h */
