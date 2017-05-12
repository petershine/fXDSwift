

import UIKit
import Foundation


class FXDViewController: UIViewController {

	override func didReceiveMemoryWarning() {	FXDLog_SEPARATE()
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	deinit {	FXDLog_SEPARATE()
		//MARK: Useful for checking if this instance is correctly deleted
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

		debugPrint(self.storyboard as Any)
		debugPrint(self.nibName as Any)
		debugPrint(self.title as Any)
		debugPrint(self.parent as Any)
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

		debugPrint(self.storyboard as Any)
		debugPrint(self.nibName as Any)
		debugPrint(self.title as Any)
		debugPrint(self.parent as Any)
	}
}
