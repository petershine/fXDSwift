

import UIKit
import Foundation


extension UIAlertController {

	//MARK: Re-consider about returing like similar original method
	static func simpleAlert(withTitle title: String? = NSLocalizedString("OK", comment: ""), message: String?, cancelButtonTitle: String?, handler: ((UIAlertAction) -> Swift.Void)? = nil) -> Void {

		//NOTE: Assume this is the condition for simple alerting without choice
		let cancelAction: UIAlertAction = UIAlertAction(title: cancelButtonTitle, style: .cancel, handler: handler)

		let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alertController.addAction(cancelAction)


		let currentWindow: UIWindow = UIApplication.shared.windows.last!
		let rootScene = currentWindow.rootViewController

		rootScene?.present(alertController, animated: true, completion: nil)
	}
}
