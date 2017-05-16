

import UIKit
import Foundation


class FXDViewController: UIViewController {

	deinit {	//MARK: Useful for checking if this instance is correctly deleted
		FXDLog_SEPARATE()
	}

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

		FXDLog(self.storyboard as Any)
		FXDLog(self.nibName as Any)
		FXDLog(self.title as Any)
		FXDLog(self.parent as Any)
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

		FXDLog(self.storyboard as Any)
		FXDLog(self.nibName as Any)
		FXDLog(self.title as Any)
		FXDLog(self.parent as Any)
	}
}
