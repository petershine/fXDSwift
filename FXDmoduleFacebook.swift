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

	lazy var currentFacebookAccount: Dictionary? = {
		return UserDefaults.standard.dictionary(forKey:userdefaultObjMainFacebookAccountIdentifier)
	}()



	deinit {	FXDLog_Func()

	}

	override init() {
		super.init()
	}


	@objc public func signInBySelectingAccountFor(typeIdentifier: String, presentingScene: UIViewController, callback: @escaping finishedClosure) {	FXDLog_Func()

		FXDLog(typeIdentifier)
		FXDLog(presentingScene)
		FXDLog(Bool(FBSDKAccessToken.current() != nil))

		// Must be Facebook account
		guard typeIdentifier == self.typeIdentifier
			else {
				callback(false, NSNull())
				return
		}


		let loginManager: FBSDKLoginManager = FBSDKLoginManager()
		loginManager.loginBehavior = FBSDKLoginBehavior.systemAccount


		let login: FBSDKLoginManager = FBSDKLoginManager()

		login.logIn(withReadPermissions: [facebookPermissionPublicProfile],
		            from: presentingScene)
		{
			(result:FBSDKLoginManagerLoginResult?,
			error:Error?) in

			FXDLog(result?.description)

			SWIFTLog(result?.isCancelled)

			callback((result?.isCancelled)! == false, error as Any)
		}
	}
}
