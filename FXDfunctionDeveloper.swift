//
//  FXDfunctionDeveloper.swift
//  season2016
//
//  Created by petershine on 8/16/15.
//  Copyright © 2015 fXceed. All rights reserved.
//

import Foundation


func FXDLog(obj: AnyObject?) {
#if ForDEVELOPER
	if (obj != nil) {
		NSLog("\(obj)")
	}
#endif
}


func FXDLog_Func(file: NSString = __FILE__, function: NSString = __FUNCTION__) {
#if ForDEVELOPER
	NSLog(" ")
	NSLog("[\(file.lastPathComponent) \(function)]")
#endif
}


func FXDLog_SEPARATE(file: NSString = __FILE__, function: NSString = __FUNCTION__) {
#if ForDEVELOPER
	NSLog("\n\n    [\(file.lastPathComponent) \(function)]")
#endif
}
