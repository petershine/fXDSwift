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


		let loginManager: FBSDKLoginManager = FBSDKLoginManager()
		loginManager.loginBehavior = FBSDKLoginBehavior.systemAccount


		/*
		loginManager.logIn(withReadPermissions:
			["public_profile",
			 "user_friends",
			 "email"],
		            from: presentingScene)
		{
			(result:FBSDKLoginManagerLoginResult?,
			error:Error?) in

			callback((result?.isCancelled)! == false, error as Any)
		}
*/

		//2016-12-24 00:39:05.516130 PopToo[10164:2443443] FBSDKLog: ** WARNING: You are requesting permissions inside the completion block of an existing login.This is unsupported behavior. You should request additional permissions only when they are needed, such as requesting for publish_actionswhen the user performs a sharing action.


		loginManager.logIn(withPublishPermissions:["publish_actions",
		                                           "manage_pages",
		                                           "publish_pages"],
		                   from: presentingScene)
		{ (result:FBSDKLoginManagerLoginResult?,
			error:Error?) in


			FXDLog(result?.description)
			FXDLog(error)


			FXDLog(result?.token.appID)
			FXDLog(result?.token.expirationDate)
			FXDLog(result?.token.refreshDate)
			FXDLog(result?.token.tokenString)
			FXDLog(result?.token.userID)

			FXDLog(result?.grantedPermissions.description)
			FXDLog(result?.declinedPermissions.description)

			FXDLog(result?.isCancelled == false)

			callback((result?.isCancelled)! == false, error as Any)
		}
	}

	@objc public func showActionSheetFor(typeIdentifier: String, presentingScene: UIViewController, callback: @escaping finishedClosure) {	FXDLog_Func()

		FXDLog(typeIdentifier)
		FXDLog(presentingScene)
		FXDLog(Bool(FBSDKAccessToken.current() != nil))
		FXDLog(self.multiAccountArray)


		func PresentActionSheet() {
			//TODO:
		}


		/*
		if ((self.multiAccountArray?.count)! > 0) {
			PresentActionSheet()
			callback(true, NSNull())
			return
		}
*/


		//FBSDKLog: starting with Graph API v2.4, GET requests for /me/accounts should contain an explicit "fields" parameter
		//https://developers.facebook.com/docs/graph-api/reference/user/

		var collectedAccounts: Array<Any> = []

		let graphRequestMe = FBSDKGraphRequest.init(
			graphPath: facebookGraphMe,
			parameters: ["fields": "id, name"])

		let graphRequestAccounts = FBSDKGraphRequest.init(
			graphPath: facebookGraphMeAccounts,
			parameters: ["fields": "data"])

		graphRequestMe?.start(completionHandler:
			{ (requestConnection:FBSDKGraphRequestConnection?,
				result:Any?,
				error:Error?) in


				FXDLog((result as Any?))
				FXDLog(error)

				collectedAccounts.append(result as Any)
				FXDLog(collectedAccounts)


				graphRequestAccounts?.start(completionHandler:
					{ (requestCOnnection:FBSDKGraphRequestConnection?,
						result:Any?,
						error:Error?) in


						FXDLog((result as Any?))
						FXDLog(error)


						let accounts: Array<Any> = (result as! Dictionary<String, Any>)["data"] as! Array
						FXDLog(accounts as Any?)

						for account in accounts {
							collectedAccounts.append(account)
						}
						FXDLog(collectedAccounts)


						callback(error == nil, collectedAccounts)
				})
		})
	}


}
