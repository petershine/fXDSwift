//
//  FXDViewController.swift
//  poptoo2017
//
//  Created by petershine on 2/6/17.
//  Copyright © 2017 fXceed. All rights reserved.
//

import UIKit
import Foundation

class FXDViewController: UIViewController {

	override func didReceiveMemoryWarning() {	FXDLog_SEPARATE()
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


	required init?(coder aDecoder: NSCoder) {	FXDLog_SEPARATE()
		super.init(coder: aDecoder)
	}

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {	FXDLog_SEPARATE()
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
	}

	override func loadView() {	FXDLog_Func()
		super.loadView()
	}

	override func viewDidLoad() {	FXDLog_Func()
		super.viewDidLoad()

		FXDLog(self.storyboard)
		FXDLog(self.nibName)
		FXDLog(self.title)
		FXDLog(self.parent)
	}

	//1
	override func viewWillAppear(_ animated: Bool) {	FXDLog_Func()
		super.viewWillAppear(animated)
	}

	//2
	override func viewWillLayoutSubviews() {	FXDLog_Func()
		super.viewWillLayoutSubviews()

	}

	//3
	override func viewDidLayoutSubviews() {	FXDLog_Func()
		super.viewWillLayoutSubviews()

	}

	//4
	override func viewDidAppear(_ animated: Bool) {	FXDLog_Func()
		super.viewDidAppear(animated)

		FXDLog(self.storyboard)
		FXDLog(self.nibName)
		FXDLog(self.title)
		FXDLog(self.parent)
	}
}
