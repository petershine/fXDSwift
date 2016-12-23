

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
		FXDLog(CLLocationManager.locationServicesEnabled().description as AnyObject)
		FXDLog(CLLocationManager.significantLocationChangeMonitoringAvailable().description as AnyObject)
		FXDLog(CLLocationManager.isRangingAvailable().description as AnyObject)
		FXDLog(CLLocationManager.deferredLocationUpdatesAvailable().description as AnyObject)

		if (CLLocationManager.locationServicesEnabled() == false) {
			return
		}


		mainLocationManager = CLLocationManager()
		mainLocationManager?.delegate = self
		mainLocationManager?.distanceFilter = 100
		mainLocationManager?.allowsBackgroundLocationUpdates = true


		let status = CLLocationManager.authorizationStatus()
		FXDLog(String(status.rawValue) as AnyObject)

		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(mainLocationManager)
		}
		else {
			//MARK: If the NSLocationAlwaysUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support Always authorization.

			mainLocationManager?.requestAlwaysAuthorization()
		}
	}


	private func startLocationManager(_ manager: CLLocationManager?) {	FXDLog_Func()

		if (manager == nil) {
			return
		}
		

		FXDLog(didStartLocationManager.description as AnyObject)

		if (didStartLocationManager) {
			return
		}


		didStartLocationManager = true


		manager?.desiredAccuracy = kCLLocationAccuracyBest

		if (UIApplication.shared.applicationState == .background) {
			manager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		}

		manager?.startUpdatingLocation()


		NotificationCenter.default
			.addObserver(self,
			selector: #selector(observedUIApplicationDidBecomeActive(_:)),
			name: NSNotification.Name.UIApplicationDidBecomeActive,
			object: nil)

		NotificationCenter.default
			.addObserver(self,
			selector: #selector(observedUIApplicationDidEnterBackground(_:)),
			name: NSNotification.Name.UIApplicationDidEnterBackground,
			object: nil)
	}

	private func stopLocationManager(_ manager: CLLocationManager?) {	FXDLog_Func()

		NotificationCenter.default.removeObserver(self)

		manager?.stopUpdatingLocation()


		didStartLocationManager = false
	}


	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {	FXDLog_Func()

		FXDLog(String(status.rawValue) as AnyObject)


		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(manager)
		}
		else {
			self.stopLocationManager(manager)
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		lastLocation = locations.last
		FXDLog(lastLocation)
	}


	func observedUIApplicationDidBecomeActive(_ notification: Notification) {	FXDLog_Func()
		FXDLog(notification as AnyObject)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
		FXDLog(mainLocationManager?.desiredAccuracy as AnyObject)
	}

	func observedUIApplicationDidEnterBackground(_ notification: Notification) {
		FXDLog_Func()
		FXDLog(notification as AnyObject)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers*2.0
		FXDLog(mainLocationManager?.desiredAccuracy as AnyObject)
	}
}
