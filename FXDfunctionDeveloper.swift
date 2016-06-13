

import UIKit
import Foundation


func FXDLog(obj: AnyObject?) {
#if ForDEVELOPER
	NSLog("\(obj)")
#endif
}

func FXDLog_Observed(obj: AnyObject?) {
#if ForDEVELOPER
	NSLog("_Observed: \(obj)")
#endif
}


func FXDLog_Func(file: NSString = #file, function: NSString = #function) {
#if ForDEVELOPER
	NSLog(" ")
	NSLog("[\(file.lastPathComponent) \(function)]")
#endif
}


func FXDLog_SEPARATE(file: NSString = #file, function: NSString = #function) {
#if ForDEVELOPER
	NSLog("\n\n    [\(file.lastPathComponent) \(function)]")
#endif
}
