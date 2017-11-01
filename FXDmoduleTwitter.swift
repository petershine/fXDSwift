

import UIKit
import Foundation

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

	@objc lazy var authenticatedSession: TWTRAuthSession? = {
		return Twitter.sharedInstance().sessionStore.session()
	}()


	@objc required init(withTwitterKey twitterKey: String!, twitterSecret: String!) {
		FXDLog_Func()
		super.init()

		Twitter.sharedInstance().start(withConsumerKey: twitterKey!, consumerSecret: twitterSecret!)
	}

	@objc func signInBySelectingAccount(presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(self.authenticatedSession?.authToken as Any)
		FXDLog(self.authenticatedSession?.authTokenSecret as Any)
		FXDLog(self.authenticatedSession?.userID as Any)


		func GrantedAccess() -> Void {
			self.showActionSheet(presentingScene: presentingScene, callback: callback)
		}

		func DeniedAccess() -> Void {
			UIAlertController.simpleAlert(withTitle: NSLocalizedString("Please grant Twitter access in Settings", comment: ""),
			                              message: self.reasonForConnecting)
			callback(false, NSNull())
		}



		guard Twitter.sharedInstance().sessionStore.hasLoggedInUsers() == false else {
			GrantedAccess()
			return
		}


		Twitter.sharedInstance().logIn(completion: { (session, error) in

			if (session != nil) {
				FXDLog("signed in as \(String(describing: session?.userName))")
				GrantedAccess()

			} else {
				FXDLog("error: \(String(describing: error?.localizedDescription))")
				DeniedAccess()
			}
		})
	}


	func showActionSheet(presentingScene: UIViewController, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(self.authenticatedSession as Any)

		guard Twitter.sharedInstance().sessionStore.hasLoggedInUsers() == true else {
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
				(action: UIAlertAction) in

				callback(false, NSNull())
		}
		
		
		let signOutAction: UIAlertAction = UIAlertAction(
			title: NSLocalizedString("Sign Out", comment: ""),
			style: .destructive) {
				[weak self] (action: UIAlertAction) in

				let userID = self?.authenticatedSession?.userID
				Twitter.sharedInstance().sessionStore.logOutUserID(userID!)

				callback(true, NSNull())
		}

		alertController.addAction(cancelAction)
		alertController.addAction(signOutAction)


		for account: TWTRSession in Twitter.sharedInstance().sessionStore.existingUserSessions() as! [TWTRSession] {

			let selectAction: UIAlertAction = UIAlertAction(
				title: String("@\(account.userName)"),
				style: .default,
				handler: {
					(action: UIAlertAction) in

					callback(true, NSNull())
			})

			alertController.addAction(selectAction)
		}

		presentingScene.present(alertController, animated: true, completion: nil)
	}


	//MARK: Twitter specific
	func twitterUserShow(withScreenName screenName: String) {	FXDLog_Func()

		FXDLog(self.authenticatedSession as Any)

		guard Twitter.sharedInstance().sessionStore.hasLoggedInUsers() == true else {
			return
		}


		let method = "GET"
		let requestURL: URL = URL(string: "https://api.twitter.com/1.1/users/show.json")!
		let parameters: Dictionary = [objkeyTwitterScreenName: screenName]

		let client = TWTRAPIClient(userID: self.authenticatedSession?.userID)
		var clientError : NSError?

		let request = client.urlRequest(withMethod: method,
		                                url: requestURL.absoluteString,
		                                parameters: parameters,
		                                error: &clientError)

		client.sendTwitterRequest(request) {
			(response, data, connectionError) in
			
			if connectionError != nil {
				FXDLog("Error: \(String(describing: connectionError))")
			}

			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: [])
				FXDLog("json: \(json)")
			} catch let jsonError as NSError {
				FXDLog("json error: \(jsonError.localizedDescription)")
			}

			FXDLog(data as Any)
			FXDLog(response as Any)
			FXDLog(connectionError as Any)

			//FIXME: Reconsider bringing evaluation to be more generic function
		}
	}

	@objc func twitterStatusUpdate(withTweetText tweetText: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees, placeId: String?, callback: @escaping FXDcallback) {	FXDLog_Func()

		FXDLog(self.authenticatedSession as Any)

		guard Twitter.sharedInstance().sessionStore.hasLoggedInUsers() == true else {
			callback(false, NSNull())
			return
		}


		let method = "POST"
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


		let client = TWTRAPIClient(userID: self.authenticatedSession?.userID)
		var clientError : NSError?

		let request = client.urlRequest(withMethod: method,
		                                url: requestURL.absoluteString,
		                                parameters: parameters,
		                                error: &clientError)

		client.sendTwitterRequest(request) {
			(response, data, connectionError) in

			if connectionError != nil {
				FXDLog("Error: \(String(describing: connectionError))")
			}

			do {
				let json = try JSONSerialization.jsonObject(with: data!, options: [])
				FXDLog("json: \(json)")
			} catch let jsonError as NSError {
				FXDLog("json error: \(jsonError.localizedDescription)")
			}

			FXDLog(data as Any)
			FXDLog(response as Any)
			FXDLog(connectionError as Any)

			//FIXME: Reconsider bringing evaluation to be more generic function

			callback(connectionError == nil, NSNull())
		}
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
