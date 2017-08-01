

import UIKit
import Foundation


class FXDViewController: UIViewController {

    deinit {    FXDLog_SEPARATE()
        //FIXME: Allow subclass to do it by themselves
        NotificationCenter.default.removeObserver(self)
	}

	override func didReceiveMemoryWarning() {	FXDLog_SEPARATE()
		super.didReceiveMemoryWarning()
	}


    //MARK: INITIALIZATION
    //FIXME: Review about need for required init?()
	required init?(coder aDecoder: NSCoder) {	FXDLog_SEPARATE()
		super.init(coder: aDecoder)
	}
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		FXDLog_SEPARATE()
        //FIXME: Developer different overriding(overloading)

        //MARK: Should use nib instead of xib for file type
        let resourcePath = Bundle.main.path(forResource: nibNameOrNil, ofType: "nib")

        let nibExists = FileManager.default.fileExists(atPath: resourcePath!)

        if (nibExists == false) {
            //FIXME: Try using super class name could be used.
			//FIXME: Should warn
        }

        FXDLog("\(String(describing: nibNameOrNil)) \(String(describing: nibBundleOrNil))")

		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        //FIXME: Re-consider if this manual execution is necessary
        self.awakeFromNib()
	}
    override func awakeFromNib() {  FXDLog_Func()
        super.awakeFromNib()
        FXDLog("\(String(describing: self.storyboard)) \(String(describing: self.nibName))")
    }
	override func loadView() {	FXDLog_Func()
		super.loadView()
	}


    //MARK: VIEW LOADING Logging
	override func viewDidLoad() {	FXDLog_Func()
		super.viewDidLoad()

		FXDLog(self.storyboard as Any)
		FXDLog(self.nibName as Any)
		FXDLog(self.title as Any)
		FXDLog(self.parent as Any)

        FXDLog("\(self.view.frame) \(self.view.bounds)")
	}


    //MARK: StatusBar Logging
    override func setNeedsStatusBarAppearanceUpdate() { FXDLog_Func()
        super.setNeedsStatusBarAppearanceUpdate()
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return super.preferredStatusBarUpdateAnimation
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return super.preferredStatusBarStyle
    }
    override var prefersStatusBarHidden: Bool {
        return super.prefersStatusBarHidden
    }


    //MARK: AutoRotating Logging
    override var shouldAutorotate: Bool {
        return super.shouldAutorotate
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return super.supportedInterfaceOrientations
    }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return super.preferredInterfaceOrientationForPresentation
    }


    //MARK: VIEW APPEARING Logging
    override func willMove(toParentViewController parent: UIViewController?) {
        if (parent == nil) {    FXDLog_Func()
        }

        super.willMove(toParentViewController: parent)
    }
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)

        if (parent != nil) {   FXDLog_Func()
        }
    }
    //1
    override func viewWillAppear(_ animated: Bool) {    FXDLog_Func()
        super.viewWillAppear(animated)
    }
    //2
    override func viewWillLayoutSubviews() {    FXDLog_Func()
        super.viewWillLayoutSubviews()
    }
    //3
    override func viewDidLayoutSubviews() {    FXDLog_Func()
        super.viewWillLayoutSubviews()
    }
    //4
    override func viewDidAppear(_ animated: Bool) {    FXDLog_Func()
        super.viewDidAppear(animated)

        FXDLog("\(animated)")
        FXDLog(self.storyboard as Any)
        FXDLog(self.nibName as Any)
        FXDLog(self.title as Any)
        FXDLog(self.parent as Any)
    }
    //5
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    //6
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }


    //MARK: Segues Logging
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool { FXDLog_Func()
        // This method is not invoked when -performSegueWithIdentifier:sender: is manually executed.

        FXDLog("\(String(describing: sender)) \(identifier)")

        let shouldPerform = super.shouldPerformSegue(withIdentifier: identifier, sender: sender)
        FXDLog("\(shouldPerform)")

        return shouldPerform
    }
    override func performSegue(withIdentifier identifier: String, sender: Any?) {   FXDLog_Func()

        FXDLog("\(String(describing: sender)) \(identifier)")

        super.performSegue(withIdentifier: identifier, sender: sender)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { FXDLog_Func()
        FXDLog("\(segue.fullDescription)")

        super.prepare(for: segue, sender: sender)
    }
    override func canPerformUnwindSegueAction(_ action: Selector, from fromViewController: UIViewController, withSender sender: Any) -> Bool {
        FXDLog_Func()

        //FIXME: Confirm if this is going to be avoidable
        // View controllers will receive this message during segue unwinding. The default implementation returns the result of -respondsToSelector: - controllers can override this to perform any ancillary checks, if necessary.

        FXDLog("\(action) \(fromViewController) \(sender)")

        let canPerform = super.canPerformUnwindSegueAction(action, from: fromViewController, withSender: sender)
        FXDLog("\(canPerform)")

        return canPerform
    }

    //MARK: Transition
    //FIXME: Reconsider if this overriding is needed
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {    FXDLog_Func()
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: {
            (context: UIViewControllerTransitionCoordinatorContext) in

            //FIXME: Replaced. sceneTransition
        }) {
            (context: UIViewControllerTransitionCoordinatorContext) in
            //FXDLog_BLOCK(coordinator, @selector(animateAlongsideTransition:completion:));
            //FXDLog(@"%@ %@ %@ %@", _Size(size), _Object([context containerView]), _Variable([context percentComplete]), _Variable([context completionVelocity]));
        }
    }
}

//MARK: Find the good way to use extensions
extension UIViewController {

    @IBAction func dismissSceneForEventSender(sender: Any) {  FXDLog_Func()

        FXDLog("\(String(describing: self.parent)) \(String(describing: self.presentingViewController))")

        if (self.parent != nil) {
            self.parent?.dismiss(animated: true, completion: nil)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

	func sceneOwnedView(fromNibName nibName: String? = nil, owner: Any? = nil) -> UIView? {
		FXDLog_Func()

        var fromNibName = nibName

        if (fromNibName == nil) {
            fromNibName = String(describing: self)
        }

		let fromNib: UINib? = UINib.init(nibName:fromNibName!, bundle: nil)

        //MARK: self must be the owner
        let viewArray: [UIView]? = fromNib?.instantiate(withOwner: self, options: nil) as? [UIView]

        FXDLog("\(String(describing: viewArray?.first))")

        return viewArray?.first
    }

}
