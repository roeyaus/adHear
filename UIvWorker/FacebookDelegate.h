//
//  FacebookDelegate.h
//  UIvWorker
//
//  Created by user on 2/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Facebook.h"

@interface FacebookDelegate : NSObject <FBSessionDelegate>
////////////////////////////////////////////////////////////////////////////////

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin;

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled;

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken
               expiresAt:(NSDate*)expiresAt;

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout;

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated;

@end
