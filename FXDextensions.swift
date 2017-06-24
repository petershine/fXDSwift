

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
        
        
        let mainWindows: UIWindow = UIApplication.shared.windows.last!
        let rootScene = mainWindows.rootViewController
        
        rootScene?.present(alert, animated: true, completion: nil)
    }
}
