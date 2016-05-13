

import UIKit
import CoreData


class FXDAppDelegate: UIResponder, UIApplicationDelegate {

	//MARK: The app delegate must implement the window property if it wants to use a main storyboard file.
	var window: UIWindow?


	//TODO: Evaluate if I need this all the time
	var isAppLaunching: Bool?
	var didFinishLaunching: Bool?

	//MARK: Subclass should initialize according to its requirement
	var coredataModule: FXDmoduleCoredata?


	override init() {	FXDLog_SEPARATE()
		super.init()

		FXDLog(NSBundle.mainBundle().infoDictionary)
	}


	func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {	FXDLog_SEPARATE()
		FXDLog(url)
		FXDLog(sourceApplication)
		FXDLog(annotation)

		return true
	}
	func application(application: UIApplication, willFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {	FXDLog_SEPARATE()
		FXDLog(launchOptions)

		return true
	}
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {	FXDLog_SEPARATE()
		FXDLog(launchOptions)

		// Override point for customization after application launch.

		return true
	}


	func applicationDidBecomeActive(application: UIApplication) {	FXDLog_SEPARATE()

		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	func applicationWillResignActive(application: UIApplication) {	FXDLog_SEPARATE()

		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}
	func applicationDidEnterBackground(application: UIApplication) {	FXDLog_SEPARATE()

		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}
	func applicationWillEnterForeground(application: UIApplication) {	FXDLog_SEPARATE()

		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}
	func applicationWillTerminate(application: UIApplication) {	FXDLog_SEPARATE()

		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
		// Saves changes in the application's managed object context before the application terminates.

		coredataModule?.saveContext()
	}
}
