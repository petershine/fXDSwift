

import UIKit
import Foundation

import Social
import Accounts

import CoreLocation

import TwitterCore
import TwitterKit


//FIXME: Prepare formatter function
//#define urlrootTwitterAPI			@"https://api.twitter.com/1.1/"
//#define urlstringTwitter(method)	[NSString stringWithFormat:@"%@%@", urlrootTwitterAPI, method]
//#define urlstringTwitterUserShow		urlstringTwitter(@"users/show.json")
//#define urlstringTwitterStatusUpdate	urlstringTwitter(@"statuses/update.json")


class FXDmoduleTwitter: NSObject {
	
	let reasonForConnecting = NSLocalizedString("Please go to device's Settings and add your Twitter account", comment: "")

	let mainAccountStore: ACAccountStore = ACAccountStore()

	lazy var mainAccountType: ACAccountType? = {
		return self.mainAccountStore.accountType(withAccountTypeIdentifier:ACAccountTypeIdentifierTwitter)
	}()
    
    @objc lazy var currentMainAccount: ACAccount? = {
		var mainAccount: ACAccount? = nil

		let accountObjKey: String = userdefaultObjMainTwitterAccountIdentifier

		if let identifier: String = UserDefaults.standard.string(forKey: accountObjKey) {

			if (self.mainAccountType != nil && self.mainAccountType!.accessGranted) {
				mainAccount = self.mainAccountStore.account(withIdentifier: identifier)
				UserDefaults.standard.set(identifier, forKey: accountObjKey)
			}
			else {
				UserDefaults.standard.removeObject(forKey: accountObjKey)
			}

		}
		else {
			UserDefaults.standard.removeObject(forKey: accountObjKey)
		}

		UserDefaults.standard.synchronize()

		return mainAccount
	}()


	@objc required init(withTwitterKey twitterKey: String!, twitterSecret: String!) {
		FXDLog_Func()
		super.init()

		//FIXME: Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'TwitterKitResources.bundle resources file not found. Please re-install TwitterKit with CocoaPods to ensure it is properly set-up.'

		Twitter.sharedInstance().start(withConsumerKey: twitterKey!, consumerSecret: twitterSecret!)
	}

	@objc func signInBySelectingAccount(presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(self.mainAccountType?.accountTypeDescription as Any)
		FXDLog(self.mainAccountType?.accessGranted as Any)


		func GrantedAccess() -> Void {
			self.showActionSheet(presentingScene: presentingScene, callback: callback)
		}

		func DeniedAccess() -> Void {
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please grant Twitter access in Settings", comment: ""),
			                              message: self.reasonForConnecting)
			callback(false, NSNull())
		}



		guard self.mainAccountType?.accessGranted != true else {
			GrantedAccess()
			return
		}


		self.mainAccountStore.requestAccessToAccounts(with: self.mainAccountType, options: nil) {
			[weak self] (granted: Bool, error: Error?) in

			DispatchQueue.main.async {
				guard granted else {
					DeniedAccess()
					return
				}

				GrantedAccess()
			}
		}
	}


	func showActionSheet(presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		let multiAccount: [ACAccount] = self.mainAccountStore.accounts(with:self.mainAccountType) as! [ACAccount]
		FXDLog(multiAccount)

		guard multiAccount.count > 0 else {
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please sign up for a Twitter account", comment: ""),
			                              message: self.reasonForConnecting)

			callback(false, NSNull())
			return
		}
		

		let alertController: UIAlertController = UIAlertController(
			title: NSLocalizedString("Please select your Twitter Account", comment: ""),
			message: nil,
			preferredStyle: .actionSheet)

		let cancelAction: UIAlertAction = UIAlertAction(
			title: NSLocalizedString("Cancel", comment: ""),
			style: .cancel) {
				[weak self] (action: UIAlertAction) in

				callback(false, NSNull())
		}
		
		
		let signOutAction: UIAlertAction = UIAlertAction(
			title: NSLocalizedString("Sign Out", comment: ""),
			style: .destructive) {
				[weak self] (action: UIAlertAction) in

				UserDefaults.standard.removeObject(forKey: userdefaultObjMainTwitterAccountIdentifier)
				UserDefaults.standard.synchronize()

				self?.currentMainAccount = nil

				callback(true, NSNull())
		}

		alertController.addAction(cancelAction)
		alertController.addAction(signOutAction)


		for account: ACAccount in multiAccount {

			let selectAction: UIAlertAction = UIAlertAction(
				title: String("@\(account.username!)"),
				style: .default,
				handler: {
					[weak self] (action: UIAlertAction) in

					self?.currentMainAccount = account
					FXDLog(self?.currentMainAccount as Any)

					UserDefaults.standard.set(account.identifier, forKey: userdefaultObjMainTwitterAccountIdentifier)
					UserDefaults.standard.synchronize()

					callback(true, NSNull())
			})

			alertController.addAction(selectAction)
		}

		presentingScene.present(alertController, animated: true, completion: nil)
	}


	func socialComposeController(initialText: String?, imageArray: Array<Any>?, URLarray: Array<Any>?) -> SLComposeViewController? {	FXDLog_Func()

		guard SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) else {
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please connect to Twitter", comment: ""),
			                              message: self.reasonForConnecting)

			return nil
		}


		let socialComposeController: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)


		if initialText != nil {
			socialComposeController.setInitialText(initialText!)
		}

		if imageArray != nil {
			for image: UIImage in imageArray as! [UIImage] {
				socialComposeController.add(image)
			}
		}

		if URLarray != nil {
			for url: URL in URLarray as! [URL] {
				socialComposeController.add(url)
			}
		}

		return socialComposeController
	}


	func didRenewAccountCredential(_ callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(self.currentMainAccount as Any)

		guard self.currentMainAccount == nil else {
			callback(true, NSNull())
			return
		}


		self.mainAccountStore.renewCredentials(for: self.currentMainAccount) {
			[weak self] (renewResult:ACAccountCredentialRenewResult, error:Error?) in

			FXDLog(renewResult)
			FXDLog(error as Any)

			callback(renewResult == .renewed, NSNull())
		}
	}



	//MARK: Twitter specific
	func twitterUserShow(withScreenName screenName: String) {	FXDLog_Func()

		FXDLog(self.currentMainAccount as Any)

		guard self.currentMainAccount != nil else {
			return
		}


		self.didRenewAccountCredential({
			[weak self] (shouldRequest: Bool?, nothing: Any?) in

			let requestURL: URL = URL(string: "https://api.twitter.com/1.1/users/show.json")!
			let parameters: Dictionary = [objkeyTwitterScreenName: screenName]

			let defaultRequest: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter,
			                                          requestMethod: .GET,
			                                          url: requestURL,
			                                          parameters: parameters)

			defaultRequest.account = self?.currentMainAccount

			defaultRequest.perform(handler: {
				[weak self] (responseData: Data?, urlResponse: HTTPURLResponse?, error: Error?) in

				FXDLog(responseData as Any)
				FXDLog(urlResponse as Any)
				FXDLog(error as Any)

				//FIXME: Reconsider bring evaluation to be more generic function
			})
		})
	}

	@objc func twitterStatusUpdate(withTweetText tweetText: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees, placeId: String?, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(self.currentMainAccount as Any)

		guard self.currentMainAccount != nil else {
			callback(false, NSNull())
			return
		}


		self.didRenewAccountCredential({
			[weak self] (shouldContinue: Bool, nothing: Any) in

			FXDLog(shouldContinue)

			guard shouldContinue else {
				callback(false, NSNull())
				return
			}


			let requestURL: URL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!

			var parameters: Dictionary<String, Any> = [objkeyTwitterStatus: tweetText ?? ""]
			parameters[objkeyTwitterDisplayCoordinates] = "true"

			if latitude != 0.0 && longitude != 0.0 {
				parameters[objkeyTwitterLat] = latitude
				parameters[objkeyTwitterLong] = longitude
			}

			if placeId != nil {
				parameters[objkeyTwitterPlaceId] = placeId
			}


			let defaultRequest: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter,
			                                          requestMethod: .POST,
			                                          url: requestURL,
			                                          parameters: parameters)

			defaultRequest.account = self?.currentMainAccount

			defaultRequest.perform(handler: {
				[weak self] (responseData: Data?, urlResponse: HTTPURLResponse?, error: Error?) in

				FXDLog(responseData as Any)
				FXDLog(urlResponse as Any)
				FXDLog(error as Any)

				//FIXME: Reconsider bringing evaluation to be more generic function

				callback(error == nil, NSNull())
			})
		})
	}
}


//SAMPLE
/*
<NSHTTPURLResponse: 0x1766314a0> { URL: https://api.twitter.com/1.1/statuses/update.json } { status code: 200, headers {
	"Cache-Control" = "no-cache, no-store, must-revalidate, pre-check=0, post-check=0";
	"Content-Disposition" = "attachment; filename=json.json";
	"Content-Encoding" = gzip;
	"Content-Type" = "application/json;charset=utf-8";
	Date = "Tue, 16 May 2017 15:47:18 GMT";
	Expires = "Tue, 31 Mar 1981 05:00:00 GMT";
	"Last-Modified" = "Tue, 16 May 2017 15:47:18 GMT";
	Pragma = "no-cache";
	Server = "tsa_b";
	"Set-Cookie" = "lang=en; Path=/";
	Status = "200 OK";
	"Strict-Transport-Security" = "max-age=631138519";
	"x-access-level" = "read-write";
	"x-connection-hash" = a40778e45c427ca3d4e09d8ede483dec;
	"x-content-type-options" = nosniff;
	"x-frame-options" = SAMEORIGIN;
	"x-response-time" = 271;
	"x-transaction" = 0073b35900912373;
	"x-tsa-request-body-time" = 1;
	"x-twitter-response-tags" = BouncerCompliant;
	"x-xss-protection" = "1; mode=block";
} }
*/
