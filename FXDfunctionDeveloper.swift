

import UIKit
import Foundation


func FXDLog_Func(_ file: NSString = #file, function: NSString = #function) {
	#if ForDEVELOPER
		debugPrint(" ")
		debugPrint("[\(file.lastPathComponent) \(function)]")
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
typealias FXDclosureFinished = (Bool, Any) -> Void
