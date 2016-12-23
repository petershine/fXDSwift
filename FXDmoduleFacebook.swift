//
//  FXDmoduleFacebook.swift
//  PopToo
//
//  Created by petershine on 12/22/16.
//  Copyright © 2016 fXceed. All rights reserved.
//


import UIKit
import Foundation

import Social
import Accounts


@objc
class FXDmoduleFacebook: NSObject {

	let typeIdentifier = ACAccountTypeIdentifierFacebook
	let reasonForConnecting = NSLocalizedString("Please go to device's Settings and add your Facebook account", comment: "")

	let initialAccessOptions: [String:Any] = [
		ACFacebookAppIdKey:	apikeyFacebookAppId,
		ACFacebookPermissionsKey: [facebookPermissionEmail]
	]

	let additionalAccessOptions: [String:Any] = [
		ACFacebookAppIdKey:	apikeyFacebookAppId,
		ACFacebookPermissionsKey: [facebookPermissionPublicProfile,
		                           facebookPermissionUserFriends,
		                           facebookPermissionPublishActions,
		                           facebookPermissionManagePages,
		                           facebookPermissionPublishStream],
		ACFacebookAudienceKey: ACFacebookAudienceEveryone
	]

	let mainAccountStore: ACAccountStore = ACAccountStore()

	lazy var mainAccountType: ACAccountType = {
		return self.mainAccountStore.accountType(withAccountTypeIdentifier:self.typeIdentifier)
	}()

	lazy var multiAccountArray: Array<Any>? = {
		return self.mainAccountStore.accounts(with:self.mainAccountType)

	}()

	var currentMainAccount: ACAccount?



	deinit {	SWIFTLog_Func()

	}

	override init() {
		super.init()
	}


	public func checkSession() {	SWIFTLog_Func()
		if (FBSDKAccessToken.current() != nil) {
			//TODO:
		}

		SWIFTLog("\(FBSDKAccessToken.current() != nil)")
	}


	public func signInBySelectingAccountForTypeIdentifier(typeIdentifier: String, presentingScene: UIViewController, callback: finishedClosure) {	SWIFTLog_Func()

		SWIFTLog(typeIdentifier)
		SWIFTLog(presentingScene)

		// Must be Facebook account
		guard typeIdentifier == self.typeIdentifier
			else {
				callback(false, nil)
				return
		}





		callback(false, nil)
	}
}
