

import UIKit
import Foundation

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
		FXDLog(CLLocationManager.locationServicesEnabled().description)
		FXDLog(CLLocationManager.significantLocationChangeMonitoringAvailable().description)
		FXDLog(CLLocationManager.isRangingAvailable().description)
		FXDLog(CLLocationManager.deferredLocationUpdatesAvailable().description)

		if (CLLocationManager.locationServicesEnabled() == false) {
			return
		}


		mainLocationManager = CLLocationManager()
		mainLocationManager?.delegate = self
		mainLocationManager?.distanceFilter = 100
		mainLocationManager?.allowsBackgroundLocationUpdates = true


		let status = CLLocationManager.authorizationStatus()
		FXDLog(String(status.rawValue))

		if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
			self.startLocationManager(mainLocationManager)
		}
		else {
			//MARK: If the NSLocationAlwaysUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support Always authorization.

			mainLocationManager?.requestAlwaysAuthorization()
		}
	}


	private func startLocationManager(manager: CLLocationManager?) {	FXDLog_Func()

		if (manager == nil) {
			return
		}
		

		FXDLog(didStartLocationManager.description)

		if (didStartLocationManager) {
			return
		}


		didStartLocationManager = true


		manager?.desiredAccuracy = kCLLocationAccuracyBest

		if (UIApplication.sharedApplication().applicationState == .Background) {
			manager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		}

		manager?.startUpdatingLocation()


		NSNotificationCenter.defaultCenter()
			.addObserver(self,
			selector: #selector(observedUIApplicationDidBecomeActive(_:)),
			name: UIApplicationDidBecomeActiveNotification,
			object: nil)

		NSNotificationCenter.defaultCenter()
			.addObserver(self,
			selector: #selector(observedUIApplicationDidEnterBackground(_:)),
			name: UIApplicationDidEnterBackgroundNotification,
			object: nil)
	}

	private func stopLocationManager(manager: CLLocationManager?) {	FXDLog_Func()

		NSNotificationCenter.defaultCenter().removeObserver(self)

		manager?.stopUpdatingLocation()


		didStartLocationManager = false
	}


	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {	FXDLog_Func()

		FXDLog(String(status.rawValue))


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

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers*2.0
		FXDLog(mainLocationManager?.desiredAccuracy)
	}
}
