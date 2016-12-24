

import UIKit
import Foundation


func SWIFTLog(_ obj: Any?) {
#if ForDEVELOPER
	NSLog("\(obj)")
#endif
}

func SWIFTLog_Observed(_ obj: Any?) {
#if ForDEVELOPER
	NSLog("_Observed: \(obj)")
#endif
}


func SWIFTLog_Func(_ file: NSString = #file, function: NSString = #function) {
#if ForDEVELOPER
	NSLog(" ")
	NSLog("[\(file.lastPathComponent) \(function)]")
#endif
}


func SWIFTLog_SEPARATE(_ file: NSString = #file, function: NSString = #function) {
#if ForDEVELOPER
	NSLog("\n\n    [\(file.lastPathComponent) \(function)]")
#endif
}



//MARK: Closures
//typedef void (^FXDcallbackFinish)(SEL caller, BOOL didFinish, id responseObj);
typealias finishedClosure = (Bool, Any) -> Void
