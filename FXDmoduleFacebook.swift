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

	/*
	lazy var multiAccountArray: Array<Any>? = {
		return self.mainAccountStore.accounts(with:self.mainAccountType)

	}()
*/

	var currentFacebookAccount: Dictionary? =  UserDefaults.standard.dictionary(forKey:userdefaultObjMainFacebookAccountIdentifier)

	var multiAccountArray: Array<Any>?

	var batchFinishedClosure:((Bool?) -> Void)?


	deinit {	FXDLog_Func()

	}

	override init() {
		super.init()
	}


	@objc public func signInBySelectingAccountFor(typeIdentifier: String, presentingScene: UIViewController, callback: @escaping finishedClosure) {	FXDLog_Func()

		FXDLog(typeIdentifier)
		FXDLog(presentingScene)
		FXDLog(FBSDKAccessToken.current() != nil)

		guard (FBSDKAccessToken.current() == nil)
			else {
				self.showActionSheetFor(
					typeIdentifier: typeIdentifier,
					presentingScene: presentingScene,
					callback: callback)

				return
		}


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


		loginManager.logIn(
			withPublishPermissions:["publish_actions",
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


			self.showActionSheetFor(
				typeIdentifier: typeIdentifier,
				presentingScene: presentingScene,
				callback: callback)
		}
	}

	@objc public func showActionSheetFor(typeIdentifier: String, presentingScene: UIViewController, callback: @escaping finishedClosure) {	FXDLog_Func()

		FXDLog(typeIdentifier)
		FXDLog(presentingScene)
		FXDLog(FBSDKAccessToken.current() != nil)
		FXDLog(self.multiAccountArray)


		//FBSDKLog: starting with Graph API v2.4, GET requests for /me/accounts should contain an explicit "fields" parameter
		//https://developers.facebook.com/docs/graph-api/reference/user/

		let graphRequestMe = FBSDKGraphRequest(
			graphPath: facebookGraphMe,
			parameters: ["fields": "id, name"])

		let graphRequestAccounts = FBSDKGraphRequest(
			graphPath: facebookGraphMeAccounts,
			parameters: ["fields": "data"])



		self.multiAccountArray = []

		_ = graphRequestMe?.start(
			completionHandler:
			{ (requested:FBSDKGraphRequestConnection?,
				result:Any?,
				error:Error?) in

				FXDLog((result as Any?))
				FXDLog(error)

				var modified = result as! Dictionary<String, Any>
				modified["category"] = "TIMELINE"

				self.multiAccountArray?.append(modified as Any)
				FXDLog(self.multiAccountArray)


				_ = graphRequestAccounts?.start(
					completionHandler:
					{ (requested:FBSDKGraphRequestConnection?,
						result:Any?,
						error:Error?) in

						FXDLog((result as Any?))
						FXDLog(error)


						let accounts: Array<Any> = (result as! Dictionary<String, Any>)["data"] as! Array
						FXDLog(accounts as Any?)



						var collectedPages: Array<Any> = []

						let batchConnection = FBSDKGraphRequestConnection()
						batchConnection.delegate = self

						for account in accounts {
							let facebookGraphPage: String = (account as! Dictionary<String, Any>)["id"] as! String

							let graphRequestPage = FBSDKGraphRequest(
								graphPath: facebookGraphPage,
								parameters: ["fields": "id, name"])

							batchConnection.add(
								graphRequestPage,
								completionHandler:
								{ (requested:FBSDKGraphRequestConnection?,
									result:Any?,
									error:Error?) in

									FXDLog((result as Any?))
									FXDLog(error)

									var modified = result as! Dictionary<String, Any>
									modified["category"] = "PAGE"

									collectedPages.append(modified as Any)
							})
						}


						self.batchFinishedClosure = { (shouldContinue:Bool?) in

							FXDLog(shouldContinue)

							FXDLog(self.multiAccountArray)
							FXDLog(collectedPages)

							guard shouldContinue == true else {
								callback(false, NSNull())
								return
							}


							self.multiAccountArray?.append(contentsOf: collectedPages)

							self.presentActionSheetWith(
								accounts: self.multiAccountArray,
								presentingScene: presentingScene,
								callback: callback)
						}

						batchConnection.start()
				})
		})
	}

	public func presentActionSheetWith(accounts:Array<Any>?, presentingScene: UIViewController, callback: @escaping finishedClosure) {	FXDLog_Func()

		FXDLog(accounts)
		FXDLog(presentingScene)
		FXDLog(self.multiAccountArray)


		let actionsheetTitle = NSLocalizedString("Please select your Facebook Timeline or Page", comment:"")


		let alertController:FXDAlertController = FXDAlertController(
			title: actionsheetTitle,
			message: nil,
			preferredStyle: .actionSheet)

		let cancelAction = UIAlertAction(
			title: NSLocalizedString("Cancel", comment: ""),
			style: .cancel)
		{ (action:UIAlertAction) in

			callback(false, NSNull())
		}

		let signOutAction = UIAlertAction(
			title: NSLocalizedString("Sign Out", comment: ""),
			style: .destructive)
		{ (action:UIAlertAction) in

			//TODO: resetCredential: Sign Out

			callback(true, NSNull())
		}

		alertController.addAction(cancelAction)
		alertController.addAction(signOutAction)


		for account in accounts! {
			var buttonTitle: String = (account as! Dictionary<String, Any>)["category"] as! String
			buttonTitle.append(": ")
			buttonTitle.append((account as! Dictionary<String, Any>)["name"] as! String)

			let selectAction = UIAlertAction(
				title: buttonTitle,
				style: .default,
				handler:
				{ (action:UIAlertAction) in

					UserDefaults.standard.set(
						account,
						forKey: userdefaultObjMainFacebookAccountIdentifier)


					self.currentFacebookAccount = account as? Dictionary

					callback(true, account)
			})

			alertController.addAction(selectAction)
			
		}
		
		

		presentingScene.present(
			alertController,
			animated: true,
			completion: nil)
	}
}

extension FXDmoduleFacebook: FBSDKGraphRequestConnectionDelegate {

	func requestConnectionDidFinishLoading(_ connection: FBSDKGraphRequestConnection!) {	FXDLog_Func()

		self.batchFinishedClosure?(true)
		self.batchFinishedClosure = nil
	}

	func requestConnection(_ connection: FBSDKGraphRequestConnection!, didFailWithError error: Error!) {	FXDLog_Func()
		FXDLog(error)

		self.batchFinishedClosure?(false)
		self.batchFinishedClosure = nil
	}
}
