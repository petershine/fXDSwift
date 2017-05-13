

import UIKit
import Foundation


extension UIAlertController {

	//MARK: Re-consider about returning like similar original method
	static func simpleAlert(withTitle title: String?,
	                        message: String?,
	                        cancelTitle: String? = NSLocalizedString("OK", comment: ""),
	                        handler: ((UIAlertAction) -> Swift.Void)? = nil) {

		//NOTE: Assume this is the condition for simple alerting without choice
		let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

		let cancelAction: UIAlertAction = UIAlertAction(title: cancelTitle,
		                                                style: .cancel,
		                                                handler: handler)

		alert.addAction(cancelAction)


		let mainWindows: UIWindow = UIApplication.shared.windows.last!
		let rootScene = mainWindows.rootViewController

		rootScene?.present(alert, animated: true, completion: nil)
	}
}
