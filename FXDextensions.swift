

import UIKit
import Foundation


extension UIAlertController {

	@objc class func simpleAlert(withTitle title: String?, message: String?) {
		self.simpleAlert(withTitle: title,
		                 message: message,
		                 cancelText: nil,
		                 fromScene: nil,
		                 handler: nil)
	}

	@objc class func simpleAlert(withTitle title: String?, message: String?,
	                             cancelText: String?,
	                             fromScene: UIViewController?,
	                             handler: ((UIAlertAction) -> Swift.Void)?) {

		let alert = UIAlertController(title: title,
		                              message: message,
		                              preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: ((cancelText != nil) ? cancelText! : NSLocalizedString("OK", comment: "")),
		                                 style: .cancel,
		                                 handler: handler)

		alert.addAction(cancelAction)


		var presentingScene: UIViewController? = fromScene

		if presentingScene == nil {
			// Traverse to find the right presentingScene (live rootViewController in the most front window)

			for window in UIApplication.shared.windows.reversed() {
				
				if window.rootViewController != nil {
					presentingScene = window.rootViewController!
					break
				}
			}
		}

		DispatchQueue.main.async {
			//Forced dispatch main
			presentingScene?.present(alert,
			                         animated: true,
			                         completion: nil)
		}
	}
}
