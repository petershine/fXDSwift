

import UIKit
import Foundation
import os.log


func FXDLog_Func(_ filename: String = #file, function: String = #function) {
	#if ForDEVELOPER
		if #available(iOS 10.0, *) {
			os_log("\n\n[%s %s]", filename, function)
		} else {
			// Fallback on earlier versions
			debugPrint("\n\n[\((filename as NSString).lastPathComponent) \(function)]")
		}
	#endif
}


//TODO: Adopt better debugging
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
typealias FXDcallback = (Bool?, Any?) -> Void
