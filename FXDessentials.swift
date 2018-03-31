

import UIKit
import Foundation
import os.log


//MARK: Closures
//Use it until interoperability allows this closure with optionals.
//e.g. typealias FXDcallback = (Bool?, Any?) -> Void
typealias FXDcallback = (_ result: Bool, _ object: Any) -> Void


//MARK: Logging
func FXDLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
	#if ForDEVELOPER
	//FIXME: How to use os_log for general cases?
		debugPrint(items, separator: separator, terminator: terminator)
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

