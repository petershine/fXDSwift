

import UIKit
import Foundation


func FXDLog(_ obj: AnyObject?) {
#if ForDEVELOPER
	NSLog("\(obj)")
#endif
}

func FXDLog_Observed(_ obj: AnyObject?) {
#if ForDEVELOPER
	NSLog("_Observed: \(obj)")
#endif
}


func FXDLog_Func(_ file: NSString = #file, function: NSString = #function) {
#if ForDEVELOPER
	NSLog(" ")
	NSLog("[\(file.lastPathComponent) \(function)]")
#endif
}


func FXDLog_SEPARATE(_ file: NSString = #file, function: NSString = #function) {
#if ForDEVELOPER
	NSLog("\n\n    [\(file.lastPathComponent) \(function)]")
#endif
}
