

import UIKit
import Foundation

import Social
import Accounts

import CoreLocation


//TODO: Prepare formatter function
//#define urlrootTwitterAPI			@"https://api.twitter.com/1.1/"
//#define urlstringTwitter(method)	[NSString stringWithFormat:@"%@%@", urlrootTwitterAPI, method]
//#define urlstringTwitterUserShow		urlstringTwitter(@"users/show.json")
//#define urlstringTwitterStatusUpdate	urlstringTwitter(@"statuses/update.json")


@objc
class FXDmoduleTwitter: NSObject {

	let typeIdentifier = ACAccountTypeIdentifierTwitter
	let reasonForConnecting = NSLocalizedString("Please go to device's Settings and add your Twitter account", comment: "")

	let mainAccountStore: ACAccountStore = ACAccountStore()


	//TODO: Reconsider lazy updated variables
	lazy var mainAccountType: ACAccountType? = {
		return self.mainAccountStore.accountType(withAccountTypeIdentifier:self.typeIdentifier)
	}()

	lazy var currentMainAccount: ACAccount? = {

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


	lazy var multiAccountArray: Array<Any> = {
		return self.mainAccountStore.accounts(with:self.mainAccountType)
	}()


	deinit {	FXDLog_Func()

	}

	override init() {
		super.init()
	}



	public func signInBySelectingAccount(forTypeIdentifier typeIdentifier: String = ACAccountTypeIdentifierTwitter, presentingScene: UIViewController, callback: @escaping FXDclosureFinished) {	FXDLog_Func()

		debugPrint(self.mainAccountType?.accountTypeDescription as Any)
		debugPrint(self.mainAccountType?.accessGranted as Any)


		func GrantedAccess() -> Void {
			self.showActionSheet(fromPresentingScene: presentingScene, typeIdentifier: typeIdentifier, callback: callback)
		}

		func DeniedAccess() -> Void {

			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please grant Twitter access in Settings", comment: ""), message: self.reasonForConnecting, cancelButtonTitle: nil, handler: nil)

			callback(false, NSNull())
		}



		guard self.mainAccountType?.accessGranted != true else {
			GrantedAccess()
			return
		}


		self.mainAccountStore.requestAccessToAccounts(with: self.mainAccountType, options: nil) {
			(granted: Bool, error: Error?) in

			DispatchQueue.main.async {
				guard granted else {
					DeniedAccess()
					return
				}

				GrantedAccess()
			}
		}
	}


	func showActionSheet(fromPresentingScene presentingScene: UIViewController, typeIdentifier: String = ACAccountTypeIdentifierTwitter, callback: @escaping FXDclosureFinished) {	FXDLog_Func()

		debugPrint(self.multiAccountArray)

		guard self.multiAccountArray.count > 0 else {
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please sign up for a Twitter account", comment: ""), message: self.reasonForConnecting, cancelButtonTitle: nil, handler: nil)

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
				(action: UIAlertAction) in

				//TODO:
				//multiAccountArray = nil

				callback(false, NSNull())
		}
		
		
		let signOutAction: UIAlertAction = UIAlertAction(
			title: NSLocalizedString("Sign Out", comment: ""),
			style: .destructive) {
				(action: UIAlertAction) in

				UserDefaults.standard.removeObject(forKey: userdefaultObjMainTwitterAccountIdentifier)
				UserDefaults.standard.synchronize()

				//TODO:
				self.currentMainAccount = nil

				//TODO:
				//multiAccountArray = nil

				callback(true, NSNull())
		}

		alertController.addAction(cancelAction)
		alertController.addAction(signOutAction)


		for account: ACAccount in self.multiAccountArray as! [ACAccount] {

			let selectAction: UIAlertAction = UIAlertAction(
				title: String("@\(account.username!)"),
				style: .default,
				handler: {
					(action: UIAlertAction) in

					//TODO:
					self.currentMainAccount = account
					debugPrint(self.currentMainAccount as Any)


					UserDefaults.standard.set(account.identifier, forKey: userdefaultObjMainTwitterAccountIdentifier)
					UserDefaults.standard.synchronize()

					//TODO:
					//multiAccountArray = nil

					callback(true, NSNull())
			})

			alertController.addAction(selectAction)
		}

		presentingScene.present(alertController, animated: true, completion: nil)
	}


	func socialComposeController(forServiceIdentifier serviceIdentifier: String, initialText: String?, imageArray: Array<Any>?, URLarray: Array<Any>?) -> SLComposeViewController? {	FXDLog_Func()

		guard SLComposeViewController.isAvailable(forServiceType: serviceIdentifier) else {

			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please connect to Twitter", comment: ""), message: self.reasonForConnecting, cancelButtonTitle: nil, handler: nil)

			return nil
		}


		let socialComposeController: SLComposeViewController = SLComposeViewController(forServiceType: serviceIdentifier)


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


	func renewAccountCredential(forTypeIdentifier typeIdentifier: String, callback: @escaping FXDclosureFinished) {	FXDLog_Func()

		debugPrint(self.currentMainAccount as Any)

		guard self.currentMainAccount?.username == nil else {
			callback(true, NSNull())
			return
		}


		self.mainAccountStore.renewCredentials(for: self.currentMainAccount) {
			(renewResult:ACAccountCredentialRenewResult, error:Error?) in

			debugPrint(renewResult)
			debugPrint(error as Any)

			callback(renewResult == .renewed, NSNull())
		}
	}



	//MARK: Twitter specific
	public func twitterUserShow(withScreenName screenName: String) {	FXDLog_Func()

		debugPrint(self.currentMainAccount as Any)

		guard self.currentMainAccount != nil else {
			return
		}


		self.renewAccountCredential(forTypeIdentifier: ACAccountTypeIdentifierTwitter) {
			(shouldRequest: Bool, nothing: Any) in

			let requestURL: URL = URL(string: "https://api.twitter.com/1.1/users/show.json")!
			let parameters: Dictionary = [objkeyTwitterScreenName: screenName]

			let defaultRequest: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: requestURL, parameters: parameters)

			defaultRequest.account = self.currentMainAccount

			defaultRequest.perform(handler: {
				(responseData: Data?, urlResponse: HTTPURLResponse?, error: Error?) in

				debugPrint(responseData as Any)
				debugPrint(urlResponse as Any)
				debugPrint(error as Any)

				//TODO: Reconsider bring evaluation to be more generic function
			})
		}
	}

	public func twitterStatusUpdate(withTweetText tweetText: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees, placeId: String?, callback: @escaping FXDclosureFinished) {	FXDLog_Func()

		debugPrint(self.currentMainAccount as Any)

		guard self.currentMainAccount != nil else {
			callback(false, NSNull())
			return
		}


		self.renewAccountCredential(forTypeIdentifier: ACAccountTypeIdentifierTwitter) {
			(shouldRequest: Bool, nothing: Any) in

			guard shouldRequest else {
				callback(false, NSNull())
				return
			}


			let requestURL: URL = URL(string: "https://api.twitter.com/1.1/statuses/update.json")!
			var parameters: Dictionary<String, Any> = [objkeyTwitterStatus: tweetText ?? ""]

			if latitude != 0.0 && longitude != 0.0 {
				parameters[objkeyTwitterDisplayCoordinates] = "true"
				parameters[objkeyTwitterLat] = latitude
				parameters[objkeyTwitterLong] = longitude
			}

			if placeId != nil {
				parameters[objkeyTwitterPlaceId] = placeId
			}


			let defaultRequest: SLRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, url: requestURL, parameters: parameters)

			defaultRequest.account = self.currentMainAccount

			defaultRequest.perform(handler: {
				(responseData: Data?, urlResponse: HTTPURLResponse?, error: Error?) in

				debugPrint(responseData as Any)
				debugPrint(urlResponse as Any)
				debugPrint(error as Any)

				//TODO: Reconsider bringing evaluation to be more generic function

				callback(error == nil, NSNull())
			})
		}
	}
}