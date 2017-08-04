

import UIKit
import Foundation


@objc extension UIAlertController {
	//FIXME: Re-consider about returning like similar original method

	class func simpleAlert(withTitle title: String?,
	                       message: String?) {
		self.simpleAlert(withTitle: title,
		                 message: message,
		                 cancelText: nil,
		                 fromScene: nil,
		                 handler: nil)
	}

	class func simpleAlert(withTitle title: String?,
	                       message: String? = nil,
	                       cancelText: String? = NSLocalizedString("OK", comment: ""),
	                       fromScene: UIViewController? = nil,
	                       handler: ((UIAlertAction) -> Swift.Void)? = nil) {
		//MARK: Assume this is the condition for simple alerting without choice

		let alert = UIAlertController(title: title,
		                              message: message,
		                              preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: cancelText,
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

