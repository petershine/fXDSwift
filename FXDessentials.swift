

import UIKit
import Foundation
import os.log


// @objc can only be used with members of classes, @objc protocols, and concrete extensions of classes

//MARK://TODO: Adopt better debugging

func FXDLog_Func(_ filename: String = #file, function: String = #function) {
	#if ForDEVELOPER
		if #available(iOS 10.0, *) {
			os_log(" ")
			os_log("[%@ %@]", (filename as NSString).lastPathComponent, function)
		} else {
			// Fallback on earlier versions
			debugPrint(" ")
			debugPrint("[\((filename as NSString).lastPathComponent) \(function)]")
		}
	#endif
}

func FXDLog_SEPARATE(_ filename: String = #file, function: String = #function) {
	#if ForDEVELOPER
		if #available(iOS 10.0, *) {
			os_log(" ")
			os_log("\n\n[%@ %@]", (filename as NSString).lastPathComponent, function)
		} else {
			// Fallback on earlier versions
			debugPrint(" ")
			debugPrint("\n\n[\((filename as NSString).lastPathComponent) \(function)]")
		}
	#endif
}


//MARK: Closures
// Until interoperability allows this closure with optionals.
//typealias FXDcallback = (Bool?, Any?) -> Void
typealias FXDcallback = (Bool, Any) -> Void
