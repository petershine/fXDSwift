//
//  FXDmoduleFacebook.swift
//  PopToo
//
//  Created by petershine on 12/22/16.
//  Copyright © 2016 fXceed. All rights reserved.
//

import UIKit
import Foundation


@objc
class FXDmoduleFacebook: NSObject {

	deinit {	FXDLog_Func()

	}


	public func checkSession() {	FXDLog_Func()
		FXDLog(FBSDKAccessToken.current())
	}

}
