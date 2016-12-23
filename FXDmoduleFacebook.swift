//
//  FXDmoduleFacebook.swift
//  PopToo
//
//  Created by petershine on 12/22/16.
//  Copyright © 2016 fXceed. All rights reserved.
//

/* From Old setup
#ifndef apikeyFacebookAppId
#define apikeyFacebookAppId	@"000000000000000"
#endif

#define facebookPermissionBasicInfo	@"basic_info"	//TODO: Obsolete. Update appropriately
#define facebookPermissionPublishStream	@"publish_stream"

#define	facebookPermissionEmail			@"email"
#define facebookPermissionPublicProfile	@"public_profile"
#define facebookPermissionUserFriends	@"user_friends"

#define	facebookPermissionPublishActions	@"publish_actions"
#define	facebookPermissionManagePages		@"manage_pages"

#define facebookGraphMe				@"me"
#define facebookGraphMeAccounts		@"me/accounts"
#define facebookGraphProfileFeed	@"%@/feed"
#define facebookGraphProfileVideos	@"%@/videos"
#define facebookGraphAccessToken	@"%@?fields=access_token"

#define urlrootFacebookAPI	@"https://graph.facebook.com/"
#define urlhostFacebookVideoGraph	@"https://graph-video.facebook.com/"

#define urlstringFacebook(method)	[NSString stringWithFormat:@"%@%@", urlrootFacebookAPI, method]
#define urlstringFacebookVideoGraph(method)	[NSString stringWithFormat:@"%@%@", urlhostFacebookVideoGraph, method]

#define objkeyFacebookAccessToken	@"access_token"
#define objkeyFacebookID	@"id"
#define objkeyFacebookName	@"name"
#define objkeyFacebookLocale	@"locale"
#define objkeyFacebookUsername	@"username"
#define objkeyFacebookCategory	@"category"
*/



import UIKit
import Foundation


@objc
class FXDmoduleFacebook: NSObject {

	deinit {	FXDLog_Func()

	}


	public func checkSession() {	FXDLog_Func()
		if (FBSDKAccessToken.current() != nil) {
			//TODO:
		}

		NSLog("\(FBSDKAccessToken.current() != nil)")
	}

}
