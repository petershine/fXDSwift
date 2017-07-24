

import UIKit
import Foundation


@objc extension UIAlertController {
	//FIXME: Re-consider about returning like similar original method
	static func simpleAlert(withTitle title: String?,
	                        message: String?,
	                        cancelTitle: String? = NSLocalizedString("OK", comment: ""),
	                        handler: ((UIAlertAction) -> Swift.Void)? = nil) {
		
		//MARK: Assume this is the condition for simple alerting without choice
		let alert = UIAlertController(title: title,
		                              message: message,
		                              preferredStyle: .alert)
		
		let cancelAction = UIAlertAction(title: cancelTitle,
		                                 style: .cancel,
		                                 handler: handler)
		
		alert.addAction(cancelAction)
		
		
		var presentingScene = fromScene
		
		if presentingScene == nil {
			let mainWindow: UIWindow = UIApplication.shared.windows.last!
			presentingScene = mainWindow.rootViewController
		}
		
		presentingScene?.present(alert,
		                         animated: true,
		                         completion: nil)
	}
}

@objc extension UIView {
	
	func addGlowingSubview(view: FXDsubviewGlowing?) {
		
		var glowingSubview: FXDsubviewGlowing? = view
		
		if glowingSubview == nil {
			var subviewFrame = self.frame
			subviewFrame.origin = .zero
			
			glowingSubview = FXDsubviewGlowing.init(frame: subviewFrame, withGlowing: nil)
		}
		
		glowingSubview?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		glowingSubview?.isUserInteractionEnabled = false
		
		self.addSubview(glowingSubview!)
	}
}
