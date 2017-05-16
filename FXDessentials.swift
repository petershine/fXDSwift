

import UIKit
import Foundation
import os.log


// @objc can only be used with members of classes, @objc protocols, and concrete extensions of classes

//MARK://TODO: Adopt better debugging

func FXDLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
	#if ForDEVELOPER
		debugPrint(items, separator: separator, terminator: terminator)

		if #available(iOS 10.0, *) {
			//MARK://TODO: How to use os_log for general cases?
		} else {
		}
	#endif
}

func FXDLog_Func(_ filename: String = #file, function: String = #function) {
	#if ForDEVELOPER
		if #available(iOS 10.0, *) {
			os_log(" ")
			os_log("[%@ %@]", (filename as NSString).lastPathComponent, function)
		} else {
			FXDLog(" ")
			FXDLog("[\((filename as NSString).lastPathComponent) \(function)]")
		}
	#endif
}

func FXDLog_SEPARATE(_ filename: String = #file, function: String = #function) {
	#if ForDEVELOPER
		if #available(iOS 10.0, *) {
			os_log(" ")
			os_log("\n\n[%@ %@]", (filename as NSString).lastPathComponent, function)
		} else {
			FXDLog(" ")
			FXDLog("\n\n[\((filename as NSString).lastPathComponent) \(function)]")
		}
	#endif
}


//MARK: Closures
// Until interoperability allows this closure with optionals.
//typealias FXDcallback = (Bool?, Any?) -> Void
typealias FXDcallback = (Bool, Any) -> Void
