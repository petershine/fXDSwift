//
//  FXDfunctionDeveloper.swift
//  season2016
//
//  Created by petershine on 8/16/15.
//  Copyright © 2015 fXceed. All rights reserved.
//

import Foundation


func FXDLogFunc(file: NSString = __FILE__, function: NSString = __FUNCTION__) {
#if ForDEVELOPER
	var className: NSString = file
	className = className.lastPathComponent
	className = className.stringByReplacingOccurrencesOfString(".swift", withString: "")

	NSLog(" ")
	NSLog("[\(className) \(function)]")
#endif
}
