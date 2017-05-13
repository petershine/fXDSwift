

import UIKit
import Foundation

import Social
import Accounts

import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


//MARK://TODO: Prepare formatter function
//#define urlrootFacebookAPI	@"https://graph.facebook.com/"
//#define urlhostFacebookVideoGraph	@"https://graph-video.facebook.com/"
//#define urlstringFacebook(method)	[NSString stringWithFormat:@"%@%@", urlrootFacebookAPI, method]
//#define urlstringFacebookVideoGraph(method)	[NSString stringWithFormat:@"%@%@", urlhostFacebookVideoGraph, method]


class FXDmoduleFacebook: NSObject {

	let reasonForConnecting = NSLocalizedString("Please go to device's Settings and add your Facebook account", comment: "")

	let mainAccountStore: ACAccountStore = ACAccountStore()

	lazy var mainAccountType: ACAccountType? = {
		return self.mainAccountStore.accountType(withAccountTypeIdentifier:ACAccountTypeIdentifierFacebook)
	}()


	lazy var currentFacebookAccount: Dictionary? =  {
		return UserDefaults.standard.dictionary(forKey: userdefaultObjMainFacebookAccountIdentifier)
	}()


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


	var multiAccountArray: Array<Any>?

	var batchFinishedClosure:((Bool) -> Void)?



	func signInBySelectingAccount(forIdentifier identifier: String = ACAccountTypeIdentifierFacebook, presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		debugPrint(identifier)
		debugPrint(presentingScene)
		debugPrint(FBSDKAccessToken.current())


		guard FBSDKAccessToken.current() == nil else {
			self.showActionSheet(forIdentifier: identifier,
			                     presentingScene: presentingScene,
			                     callback: callback)

			return
		}


		let loginManager: FBSDKLoginManager = FBSDKLoginManager()
		//loginManager.loginBehavior = FBSDKLoginBehavior.systemAccount

		//MARK: For some reason system account login is not working
		loginManager.loginBehavior = FBSDKLoginBehavior.native


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

		//FBSDKLog: ** WARNING: You are requesting permissions inside the completion block of an existing login.This is unsupported behavior. You should request additional permissions only when they are needed, such as requesting for publish_actionswhen the user performs a sharing action.


		loginManager.logIn(
			withPublishPermissions:["publish_actions",
			                        "manage_pages",
			                        "publish_pages"],
			from: presentingScene) {
				[weak self] (result:FBSDKLoginManagerLoginResult?, error:Error?) in

				debugPrint(result as Any)
				debugPrint(error as Any)

				guard result != nil else {
					callback(false, NSNull())
					return
				}


				debugPrint(result?.token.appID as Any)
				debugPrint(result?.token.expirationDate as Any)
				debugPrint(result?.token.refreshDate as Any)
				debugPrint(result?.token.tokenString as Any)
				debugPrint(result?.token.userID as Any)


				debugPrint(result?.grantedPermissions.description as Any)
				debugPrint(result?.declinedPermissions.description as Any)

				debugPrint(result?.isCancelled as Any)

				guard result?.isCancelled == false else {
					callback(false, NSNull())
					return
				}


				self?.showActionSheet(forIdentifier: identifier,
				                      presentingScene: presentingScene,
				                      callback: callback)
		}
	}


	func showActionSheet(forIdentifier identifier: String = ACAccountTypeIdentifierFacebook, presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		debugPrint(identifier)
		debugPrint(presentingScene)
		debugPrint(FBSDKAccessToken.current())

		debugPrint(self.multiAccountArray as Any)

		//FBSDKLog: starting with Graph API v2.4, GET requests for /me/accounts should contain an explicit "fields" parameter
		//https://developers.facebook.com/docs/graph-api/reference/user/


		self.multiAccountArray = []

		let graphRequestMe = FBSDKGraphRequest(
			graphPath: facebookGraphMe,
			parameters: ["fields": "id, name"])

		_ = graphRequestMe?.start(
			completionHandler: {
				(requested:FBSDKGraphRequestConnection?,
				result:Any?,
				error:Error?) in

				debugPrint(result as Any)
				debugPrint(error as Any)

				guard result != nil else {
					callback(false, NSNull())
					return
				}

				guard error == nil else {
					callback(false, NSNull())
					return
				}


				var modified = result as! Dictionary<String, Any>
				modified["category"] = "TIMELINE"

				self.multiAccountArray?.append(modified as Any)

				debugPrint(self.multiAccountArray as Any)


				//MARK://TODO: Until page updating is approved, just provide Timeline update only
				//self.requestAccountsWith(presentingScene: presentingScene, callback: callback)

				self.presentActionSheet(withAccounts: self.multiAccountArray,
				                        presentingScene: presentingScene,
				                        callback: callback)
		})
	}

	func presentActionSheet(withAccounts accounts:Array<Any>?, presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		debugPrint(accounts as Any)
		debugPrint(presentingScene)
		debugPrint(self.multiAccountArray as Any)


		let actionsheetTitle = NSLocalizedString("Please select your Facebook Timeline or Page", comment:"")

		let alertController:UIAlertController = UIAlertController(
			title: actionsheetTitle,
			message: nil,
			preferredStyle: .actionSheet)

		let cancelAction = UIAlertAction(
			title: NSLocalizedString("Cancel", comment: ""),
			style: .cancel) {
				(action:UIAlertAction) in

				callback(false, NSNull())
		}

		let signOutAction = UIAlertAction(
			title: NSLocalizedString("Sign Out", comment: ""),
			style: .destructive) {
				(action:UIAlertAction) in

				//MARK://TODO: resetCredential: Sign Out

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
				handler: {
					(action:UIAlertAction) in

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

		presentingScene.present(alertController, animated: true)
	}



	func requestAccounts(withPresentingScene presentingScene: UIViewController, callback:@escaping FXDcallback) {	FXDLog_Func()

		let graphRequestAccounts = FBSDKGraphRequest(
			graphPath: facebookGraphMeAccounts,
			parameters: ["fields": "data"])

		_ = graphRequestAccounts?.start(
			completionHandler:
			{ (requested:FBSDKGraphRequestConnection?,
				result:Any?,
				error:Error?) in

				debugPrint(result as Any)
				debugPrint(error as Any)

				guard result != nil else {
					callback(false, NSNull())
					return
				}

				guard error == nil else {
					callback(false, NSNull())
					return
				}


				let accounts: Array<Any> = (result as! Dictionary<String, Any>)["data"] as! Array
				debugPrint(accounts)

				guard accounts.count > 0 else {
					callback(false, NSNull())
					return
				}


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
						completionHandler: {
							(requested:FBSDKGraphRequestConnection?,
							result:Any?,
							error:Error?) in

							debugPrint(result as Any)
							debugPrint(error as Any)

							if error == nil {
								var modified = result as! Dictionary<String, Any>
								modified["category"] = "PAGE"

								collectedPages.append(modified as Any)
							}
					})
				}


				self.batchFinishedClosure = { (shouldContinue: Bool) in

					debugPrint(shouldContinue)
					debugPrint(self.multiAccountArray as Any)
					debugPrint(collectedPages)

					guard shouldContinue else {
						callback(false, NSNull())
						return
					}


					self.multiAccountArray?.append(contentsOf: collectedPages)

					self.presentActionSheet(withAccounts: self.multiAccountArray,
					                        presentingScene: presentingScene,
					                        callback: callback)
				}

				batchConnection.start()
		})
	}

	func requestToPost(withMessage message:String, mediaLink:String?, latitude:CLLocationDegrees, longitude:CLLocationDegrees, callback:@escaping FXDcallback) {	FXDLog_Func()

		self.requestSearch(withLatitude: latitude, longitude: longitude) {
			(shouldContinue: Bool?, placeId: Any?) in

			debugPrint(shouldContinue as Any)

			debugPrint(message)


			let facebookId:String = self.currentFacebookAccount?["id"] as! String
			let graphPath = "\(facebookId)/feed"
			debugPrint(graphPath)

			var parameters = ["message":message]

			if mediaLink != nil {
				parameters["link"] = mediaLink
			}
			if placeId != nil {
				parameters["place"] = placeId as? String
			}
			debugPrint(parameters)


			let graphRequestPost = FBSDKGraphRequest(
				graphPath: graphPath,
				parameters: parameters,
				httpMethod: "POST")

			debugPrint(graphRequestPost as Any)

			//message = "(#200) Insufficient permission to post to target on behalf of the viewer";
			_ = graphRequestPost?.start(
				completionHandler:
				{ (requested:FBSDKGraphRequestConnection?,
					result:Any?,
					error:Error?) in

					debugPrint(result as Any)
					debugPrint(error as Any)

					callback(error == nil, result as Any)
			})
			
		}
	}

	func requestSearch(withLatitude latitude:CLLocationDegrees, longitude:CLLocationDegrees, callback:@escaping FXDcallback) {	FXDLog_Func()

		debugPrint(longitude)
		debugPrint(latitude)

		guard (latitude != 0.0 && longitude != 0.0) else {
			callback(false, NSNull())
			return
		}


		let graphRequestSearch = FBSDKGraphRequest(
			graphPath: "search",
			parameters: ["type": "place",
			             "center":String("\(latitude),\(longitude)")!,
			             "distance":String("\(kCLLocationAccuracyKilometer)")!])
		debugPrint(graphRequestSearch as Any)

		_ = graphRequestSearch?.start(
			completionHandler:
			{ (requested:FBSDKGraphRequestConnection?,
				result:Any?,
				error:Error?) in

				debugPrint(result as Any)
				debugPrint(error as Any)

				guard result != nil else {
					callback(false, NSNull())
					return
				}


				let places: Array<Any> = (result as! Dictionary<String, Any>)["data"] as! Array
				debugPrint(places)

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
		debugPrint(error)

		assert(self.batchFinishedClosure != nil)
		self.batchFinishedClosure?(false)
		self.batchFinishedClosure = nil
		assert(self.batchFinishedClosure == nil)
	}
}
