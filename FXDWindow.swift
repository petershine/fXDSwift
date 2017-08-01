

import UIKit
import Foundation

/*
class FXDWindow: UIWindow {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
}
*/

@objc extension UIWindow {
	class func newWindow(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIWindow? {
		FXDLog_Func()

		//MARK: Customized initialization
		//FIXME: Should update this method to use Self class, for subclasses.
		//https://github.com/apple/swift-evolution/blob/master/proposals/0068-universal-self.md

		// Exploit that UIWindow is UIView
		guard nibName == nil
			else {
				let newWindow: UIWindow? = self.view(fromNibName: nibName!, owner: owner) as! UIWindow?
				return newWindow
		}

		let screenBounds = UIScreen.main.bounds
		FXDLog("screenBounds: \(screenBounds)")
		FXDLog("UIScreen.main.nativeBounds: \(UIScreen.main.nativeBounds)")
		FXDLog("UIScreen.main.nativeScale: \(UIScreen.main.nativeScale)")

		let newWindow: UIWindow? = self.init(frame: screenBounds)
		newWindow?.autoresizesSubviews = true

		return newWindow
	}
}
