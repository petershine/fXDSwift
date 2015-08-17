

import UIKit

import CoreLocation
import MapKit


class FXDmoduleGeo: NSObject, CLLocationManagerDelegate {

	var didStartLocationManager : Bool = false
	
	var mainLocationManager : CLLocationManager?
	var lastLocation: CLLocation?


	deinit {	FXDLog_Func()
		self.stopLocationManager(mainLocationManager)
	}


	func startGeoModule() {	FXDLog_Func()

		mainLocationManager = CLLocationManager()
		mainLocationManager?.delegate = self


		let status = CLLocationManager.authorizationStatus()
		NSLog("\(status.rawValue)")

		if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
			self.startLocationManager(mainLocationManager)
		}
		else {
			mainLocationManager?.requestAlwaysAuthorization()
		}
	}


	private func startLocationManager(manager: CLLocationManager?) {	FXDLog_Func()

		FXDLog(didStartLocationManager.description)

		if (didStartLocationManager) {
			return
		}


		didStartLocationManager = true


		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest

		if (UIApplication.sharedApplication().applicationState == .Background) {
			mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		}

		manager?.startUpdatingLocation()


		NSNotificationCenter.defaultCenter()
			.addObserver(self,
			selector: "observedUIApplicationDidBecomeActive:",
			name: UIApplicationDidBecomeActiveNotification,
			object: nil)

		NSNotificationCenter.defaultCenter()
			.addObserver(self,
			selector: "observedUIApplicationDidEnterBackground:",
			name: UIApplicationDidEnterBackgroundNotification,
			object: nil)
	}

	private func stopLocationManager(manager: CLLocationManager?) {	FXDLog_Func()

		NSNotificationCenter.defaultCenter().removeObserver(self)

		manager?.stopUpdatingLocation()


		didStartLocationManager = false
	}


	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {	FXDLog_Func()

		NSLog("\(status.rawValue)")


		if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
			self.startLocationManager(manager)
		}
		else {
			self.stopLocationManager(manager)
		}
	}

	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		lastLocation = locations.last
		FXDLog(lastLocation)
	}


	func observedUIApplicationDidBecomeActive(notification: NSNotification) {	FXDLog_Func()
		FXDLog(notification)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
		FXDLog(mainLocationManager?.desiredAccuracy)
	}

	func observedUIApplicationDidEnterBackground(notification: NSNotification) {
		FXDLog_Func()
		FXDLog(notification)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		FXDLog(mainLocationManager?.desiredAccuracy)
	}
}
