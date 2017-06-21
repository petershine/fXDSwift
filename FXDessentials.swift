

import UIKit
import Foundation
import os.log


//MARK: @objc can only be used with members of classes, @objc protocols, and concrete extensions of classes

//FIXME: Adopt better debugging

func FXDLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
	#if ForDEVELOPER
		debugPrint(items, separator: separator, terminator: terminator)

        //FIXME: How to use os_log for general cases?
		if #available(iOS 10.0, *) {
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
//Use it until interoperability allows this closure with optionals.
//e.g. typealias FXDcallback = (Bool?, Any?) -> Void
typealias FXDcallback = (Bool, Any) -> Void
