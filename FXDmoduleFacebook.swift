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


	var currentFacebookAccount: Dictionary? =  UserDefaults.standard.dictionary(forKey:userdefaultObjMainFacebookAccountIdentifier)

	var multiAccountArray: Array<Any>?

	var batchFinishedClosure:((Bool?) -> Void)?


	deinit {	FXDLog_Func()

	}

	override init() {
		super.init()
	}



	public func signInBySelectingAccountFor(typeIdentifier: String, presentingScene: UIViewController, callback: @escaping finishedClosure) {	FXDLog_Func()

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

			FXDLog(result)
			FXDLog(error)

			FXDLog(result?.token.appID)
			FXDLog(result?.token.expirationDate)
			FXDLog(result?.token.refreshDate)
			FXDLog(result?.token.tokenString)
			FXDLog(result?.token.userID)

			FXDLog(result?.grantedPermissions.description)
			FXDLog(result?.declinedPermissions.description)

			FXDLog(result?.isCancelled)

			guard result?.isCancelled == false
			else {
				callback(false, NSNull())
				return
			}


			self.showActionSheetFor(
				typeIdentifier: typeIdentifier,
				presentingScene: presentingScene,
				callback: callback)
		}
	}


	public func showActionSheetFor(typeIdentifier: String, presentingScene: UIViewController, callback: @escaping finishedClosure) {	FXDLog_Func()

		FXDLog(typeIdentifier)
		FXDLog(presentingScene)
		FXDLog(FBSDKAccessToken.current() != nil)
		FXDLog(self.multiAccountArray)


		//FBSDKLog: starting with Graph API v2.4, GET requests for /me/accounts should contain an explicit "fields" parameter
		//https://developers.facebook.com/docs/graph-api/reference/user/


		self.multiAccountArray = []

		let graphRequestMe = FBSDKGraphRequest(
			graphPath: facebookGraphMe,
			parameters: ["fields": "id, name"])

		_ = graphRequestMe?.start(
			completionHandler:
			{ (requested:FBSDKGraphRequestConnection?,
				result:Any?,
				error:Error?) in

				FXDLog((result as Any?))
				FXDLog(error)

				guard error == nil
					else {
						callback(false, NSNull())
						return
				}


				var modified = result as! Dictionary<String, Any>
				modified["category"] = "TIMELINE"

				self.multiAccountArray?.append(modified as Any)
				FXDLog(self.multiAccountArray)


				let graphRequestAccounts = FBSDKGraphRequest(
					graphPath: facebookGraphMeAccounts,
					parameters: ["fields": "data"])

				_ = graphRequestAccounts?.start(
					completionHandler:
					{ (requested:FBSDKGraphRequestConnection?,
						result:Any?,
						error:Error?) in

						FXDLog((result as Any?))
						FXDLog(error)

						guard error == nil
							else {
								callback(false, NSNull())
								return
						}


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

									if error == nil {
										var modified = result as! Dictionary<String, Any>
										modified["category"] = "PAGE"

										collectedPages.append(modified as Any)
									}
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
					UserDefaults.standard.synchronize()


					self.currentFacebookAccount = account as? Dictionary

					callback(true, account)
			})

			alertController.addAction(selectAction)
			
		}
		
		

		(UIApplication.mainWindow() as! FXDWindow).hideInformationView(afterDelay: (1.0/4.0))	//delayQuarterSecond

		presentingScene.present(
			alertController,
			animated: true)
	}



	public func requestAccountsWith(presentingScene: UIViewController, callback:@escaping finishedClosure) {	FXDLog_Func()

		self.requestSearchWith(
			latitude: latitude,
			longitude: longitude)
		{ (shouldContinue:Bool,
			placeId:Any) in

			FXDLog(shouldContinue)


			let optionalMediaLink:String? = mediaLink
			let optionalPlaceId:String? = placeId as? String

			FXDLog(message)
			FXDLog(optionalMediaLink)
			FXDLog(optionalPlaceId)


			let facebookId:String = self.currentFacebookAccount?["id"] as! String
			let graphPath = "\(facebookId)/feed"
			FXDLog(graphPath)

			var parameters = ["message":message]
			if optionalMediaLink != nil {parameters["link"] = optionalMediaLink}
			if optionalPlaceId != nil {parameters["place"] = optionalPlaceId}
			FXDLog(parameters)


			let graphRequestPost = FBSDKGraphRequest(
				graphPath: graphPath,
				parameters: parameters,
				httpMethod: "POST")

			FXDLog(graphRequestPost)

			//message = "(#200) Insufficient permission to post to target on behalf of the viewer";
			_ = graphRequestPost?.start(
				completionHandler:
				{ (requested:FBSDKGraphRequestConnection?,
					result:Any?,
					error:Error?) in

				FXDLog((result as Any?))
				FXDLog(error)

				callback(error == nil, result as Any)
			})

		}
	}

	public func requestSearchWith(latitude:CLLocationDegrees, longitude:CLLocationDegrees, callback:@escaping finishedClosure) {	FXDLog_Func()

		FXDLog(longitude)
		FXDLog(latitude)

		guard (latitude != 0.0 && longitude != 0.0)
			else {
				callback(false, NSNull())
				return
		}


		let graphRequestSearch = FBSDKGraphRequest(
			graphPath: "search",
			parameters: ["type": "place",
			             "center":String("\(latitude),\(longitude)") ?? "",
			             "distance":String("\(kCLLocationAccuracyKilometer)") ?? ""])
		FXDLog(graphRequestSearch)

		_ = graphRequestSearch?.start(
			completionHandler:
			{ (requested:FBSDKGraphRequestConnection?,
				result:Any?,
				error:Error?) in

				FXDLog((result as Any?))
				FXDLog(error)

				let places: Array<Any> = (result as! Dictionary<String, Any>)["data"] as! Array
				FXDLog(places as Any?)

				var placeId:String? = nil

				for place in places {
					placeId = (place as! Dictionary<String, Any>)["id"] as? String

					if placeId != nil {
						break
					}
				}

				callback(placeId != nil, placeId as Any)
		})
	}
}




extension FXDmoduleFacebook: FBSDKGraphRequestConnectionDelegate {

	func requestConnectionDidFinishLoading(_ connection: FBSDKGraphRequestConnection!) {	FXDLog_Func()

		assert(self.batchFinishedClosure != nil)
		self.batchFinishedClosure?(true)
		self.batchFinishedClosure = nil
		assert(self.batchFinishedClosure == nil)
	}

	func requestConnection(_ connection: FBSDKGraphRequestConnection!, didFailWithError error: Error!) {	FXDLog_Func()
		FXDLog(error)

		assert(self.batchFinishedClosure != nil)
		self.batchFinishedClosure?(false)
		self.batchFinishedClosure = nil
		assert(self.batchFinishedClosure == nil)
	}
}
