

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

/*
func FXDLog_SEPARATE(_ file: NSString = #file, function: NSString = #function) {
	#if ForDEVELOPER
		debugPrint("\n\n    [\(file.lastPathComponent) \(function)]")
	#endif
}

func FXDLog(_ obj: Any?) {
	#if ForDEVELOPER
		debugPrint("\(String(describing: obj))")
	#endif
}

func FXDLog_Observed(_ obj: Any?) {
	#if ForDEVELOPER
		debugPrint("_Observed: \(String(describing: obj))")
	#endif
}

func FXDLog_OVERRIDE() {
	#if ForDEVELOPER
		FXDLog("SHOULD OVERRIDE")
	#endif
}
*/



//MARK: Closures
// Until interoperability allows this closure with optionals.
//typealias FXDcallback = (Bool?, Any?) -> Void
typealias FXDcallback = (Bool, Any) -> Void
