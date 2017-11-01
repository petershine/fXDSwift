

import UIKit
import Foundation

import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit


//FIXME: Prepare formatter function
//#define urlrootFacebookAPI	@"https://graph.facebook.com/"
//#define urlhostFacebookVideoGraph	@"https://graph-video.facebook.com/"
//#define urlstringFacebook(method)	[NSString stringWithFormat:@"%@%@", urlrootFacebookAPI, method]
//#define urlstringFacebookVideoGraph(method)	[NSString stringWithFormat:@"%@%@", urlhostFacebookVideoGraph, method]

let userdefaultObjMainFacebookAccountIdentifier: String = "MainFacebookAccountIdentifierObjKey"


class FXDmoduleFacebook: NSObject {

	let reasonForConnecting = NSLocalizedString("Please go to device's Settings and add your Facebook account", comment: "")

	@objc lazy var currentFacebookAccount: Dictionary<String, Any>? =  {
		return UserDefaults.standard.dictionary(forKey: userdefaultObjMainFacebookAccountIdentifier)
	}()


	var batchFinishedClosure:((Bool) -> Void)?


	@objc func signInBySelectingAccount(presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(presentingScene)
		FXDLog(FBSDKAccessToken.current())


		guard FBSDKAccessToken.current() == nil else {
			self.showActionSheet(presentingScene: presentingScene, callback: callback)

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

				FXDLog(result as Any)
				FXDLog(error as Any)

				guard result != nil else {
					callback(false, NSNull())
					return
				}


				FXDLog(result?.token.appID as Any)
				FXDLog(result?.token.expirationDate as Any)
				FXDLog(result?.token.refreshDate as Any)
				FXDLog(result?.token.tokenString as Any)
				FXDLog(result?.token.userID as Any)


				FXDLog(result?.grantedPermissions.description as Any)
				FXDLog(result?.declinedPermissions.description as Any)

				FXDLog(result?.isCancelled as Any)

				guard result?.isCancelled == false else {
					callback(false, NSNull())
					return
				}


				self?.showActionSheet(presentingScene: presentingScene, callback: callback)
		}
	}


	func showActionSheet(presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(presentingScene)
		FXDLog(FBSDKAccessToken.current())

		//FBSDKLog: starting with Graph API v2.4, GET requests for /me/accounts should contain an explicit "fields" parameter
		//https://developers.facebook.com/docs/graph-api/reference/user/


		var multiAccount: Array<Dictionary<String, Any>> = []

		let graphRequestMe = FBSDKGraphRequest(
			graphPath: facebookGraphMe,
			parameters: ["fields": "id, name"])

		_ = graphRequestMe?.start(
			completionHandler: {
				[weak self] (requested:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in

				FXDLog(result as Any)
				FXDLog(error as Any)

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

				multiAccount.append(modified)
				FXDLog(multiAccount)


				//FIXME: Until page updating is approved, just provide Timeline update only
				//self.requestAccountsWith(presentingScene: presentingScene, callback: callback)

				self?.presentActionSheet(multiAccount: multiAccount,
				                         presentingScene: presentingScene,
				                         callback: callback)
		})
	}

	func presentActionSheet(multiAccount:Array<Dictionary<String, Any>>?, presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(multiAccount as Any)
		FXDLog(presentingScene)

		guard multiAccount != nil && multiAccount!.count > 0 else {
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please sign up for a Facebook account", comment: ""),
			                              message: self.reasonForConnecting)

			callback(false, NSNull())
			return
		}


		let actionsheetTitle = NSLocalizedString("Please select your Facebook Timeline or Page", comment:"")

		let alertController:UIAlertController = UIAlertController(
			title: actionsheetTitle,
			message: nil,
			preferredStyle: .actionSheet)

		let cancelAction = UIAlertAction(
			title: NSLocalizedString("Cancel", comment: ""),
			style: .cancel) {
				(action: UIAlertAction) in

				callback(false, NSNull())
		}

		let signOutAction = UIAlertAction(
			title: NSLocalizedString("Sign Out", comment: ""),
			style: .destructive) {
				(action: UIAlertAction) in

				//FIXME: resetCredential: Sign Out

				callback(true, NSNull())
		}

		alertController.addAction(cancelAction)
		alertController.addAction(signOutAction)


		for account in multiAccount! {
			var buttonTitle: String = account["category"] as! String
			buttonTitle.append(": ")
			buttonTitle.append(account["name"] as! String)

			let selectAction = UIAlertAction(
				title: buttonTitle,
				style: .default,
				handler: {
					[weak self] (action:UIAlertAction) in

					UserDefaults.standard.set(account, forKey: userdefaultObjMainFacebookAccountIdentifier)
					UserDefaults.standard.synchronize()

					self?.currentFacebookAccount = account

					callback(true, account)
			})

			alertController.addAction(selectAction)
			
		}
		
		

		(UIApplication.mainWindow() as! FXDWindow).hideInformationView(afterDelay: (1.0/4.0))	//delayQuarterSecond

		presentingScene.present(alertController, animated: true)
	}



	func requestAccounts(presentingScene: UIViewController, callback:@escaping FXDcallback) {	FXDLog_Func()

		let graphRequestAccounts = FBSDKGraphRequest(
			graphPath: facebookGraphMeAccounts,
			parameters: ["fields": "data"])

		_ = graphRequestAccounts?.start(
			completionHandler: {
				[weak self] (requested:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in

				FXDLog(result as Any)
				FXDLog(error as Any)

				guard result != nil else {
					callback(false, NSNull())
					return
				}

				guard error == nil else {
					callback(false, NSNull())
					return
				}


				let multiAccount: Array<Any> = (result as! Dictionary<String, Any>)["data"] as! Array
				FXDLog(multiAccount)

				guard multiAccount.count > 0 else {
					callback(false, NSNull())
					return
				}


				var collectedPages: Array<Dictionary<String, Any>> = []

				let batchConnection = FBSDKGraphRequestConnection()
				batchConnection.delegate = self

				for account in multiAccount {
					let facebookGraphPage: String = (account as! Dictionary<String, Any>)["id"] as! String

					let graphRequestPage = FBSDKGraphRequest(
						graphPath: facebookGraphPage,
						parameters: ["fields": "id, name"])

					batchConnection.add(
						graphRequestPage,
						completionHandler: {
							(requested:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in

							FXDLog(result as Any)
							FXDLog(error as Any)

							if error == nil {
								var modified = result as! Dictionary<String, Any>
								modified["category"] = "PAGE"

								collectedPages.append(modified)
							}
					})
				}


				guard self != nil else {
					callback(false, NSNull())
					return
				}


				self!.batchFinishedClosure = {
					[weak self] (shouldContinue: Bool) in

					FXDLog(shouldContinue)
					FXDLog(collectedPages)

					guard shouldContinue else {
						callback(false, NSNull())
						return
					}


					//FIXME: How to combine accounts and pages?

					self?.presentActionSheet(multiAccount: collectedPages,
					                         presentingScene: presentingScene,
					                         callback: callback)
				}

				batchConnection.start()
		})
	}

	@objc func requestToPost(message: String, mediaLink: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees, callback: @escaping FXDcallback) {	FXDLog_Func()

		self.requestSearch(latitude: latitude, longitude: longitude) {
			[weak self] (shouldContinue: Bool?, placeId: Any?) in

			FXDLog(shouldContinue as Any)

			FXDLog(message)


			let facebookId:String = self?.currentFacebookAccount?["id"] as! String
			let graphPath = "\(facebookId)/feed"
			FXDLog(graphPath)

			var parameters = ["message":message]

			if mediaLink != nil {
				parameters["link"] = mediaLink
			}
			if placeId != nil {
				parameters["place"] = placeId as? String
			}
			FXDLog(parameters)


			let graphRequestPost = FBSDKGraphRequest(
				graphPath: graphPath,
				parameters: parameters,
				httpMethod: "POST")

			FXDLog(graphRequestPost as Any)

			//message = "(#200) Insufficient permission to post to target on behalf of the viewer";
			_ = graphRequestPost?.start(
				completionHandler: {
					(requested:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in

					FXDLog(result as Any)
					FXDLog(error as Any)

					callback(error == nil, result as Any)
			})
			
		}
	}

	func requestSearch(latitude:CLLocationDegrees, longitude:CLLocationDegrees, callback:@escaping FXDcallback) {	FXDLog_Func()

		FXDLog(longitude)
		FXDLog(latitude)

		guard (latitude != 0.0 && longitude != 0.0) else {
			callback(false, NSNull())
			return
		}


		let graphRequestSearch = FBSDKGraphRequest(
			graphPath: "search",
			parameters: ["type": "place",
			             "center":String("\(latitude),\(longitude)"),
			             "distance":String("\(kCLLocationAccuracyKilometer)")])
		FXDLog(graphRequestSearch as Any)

		_ = graphRequestSearch?.start(
			completionHandler:{
				(requested:FBSDKGraphRequestConnection?, result:Any?, error:Error?) in

				FXDLog(result as Any)
				FXDLog(error as Any)

				guard result != nil else {
					callback(false, NSNull())
					return
				}


				let places: Array<Any> = (result as! Dictionary<String, Any>)["data"] as! Array
				FXDLog(places)

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
