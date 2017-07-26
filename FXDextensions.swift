

import UIKit
import Foundation


@objc extension UIAlertController {
	//FIXME: Re-consider about returning like similar original method
	class func simpleAlert(withTitle title: String?,
	                        message: String? = nil,
	                        cancelTitle: String? = NSLocalizedString("OK", comment: ""),
	                        fromScene: UIViewController? = nil,
	                        handler: ((UIAlertAction) -> Swift.Void)? = nil) {
		
		//MARK: Assume this is the condition for simple alerting without choice
		let alert = UIAlertController(title: title,
		                              message: message,
		                              preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: cancelTitle,
		                                 style: .cancel,
		                                 handler: handler)
		
		alert.addAction(cancelAction)
		
		
		var presentingScene: UIViewController? = fromScene
		
		if presentingScene == nil {
			let mainWindow: UIWindow = UIApplication.shared.windows.last!
			presentingScene = mainWindow.rootViewController!
		}
		
		presentingScene?.present(alert,
		                         animated: true,
		                         completion: nil)
	}
}

