

import UIKit
import Foundation

import CoreLocation
import MapKit


class FXDmoduleGeo: NSObject, CLLocationManagerDelegate {

	var didStartLocationManager : Bool = false
	
	var mainLocationManager : CLLocationManager?
	var lastLocation: CLLocation?


	deinit {	SWIFTLog_Func()
		self.stopLocationManager(mainLocationManager)
	}


	func startGeoModule() {	SWIFTLog_Func()
		SWIFTLog(CLLocationManager.locationServicesEnabled().description)
		SWIFTLog(CLLocationManager.significantLocationChangeMonitoringAvailable().description)
		SWIFTLog(CLLocationManager.isRangingAvailable().description)
		SWIFTLog(CLLocationManager.deferredLocationUpdatesAvailable().description)

		if (CLLocationManager.locationServicesEnabled() == false) {
			return
		}


		mainLocationManager = CLLocationManager()
		mainLocationManager?.delegate = self
		mainLocationManager?.distanceFilter = 100
		mainLocationManager?.allowsBackgroundLocationUpdates = true


		let status = CLLocationManager.authorizationStatus()
		SWIFTLog(String(status.rawValue))

		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(mainLocationManager)
		}
		else {
			//MARK: If the NSLocationAlwaysUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support Always authorization.

			mainLocationManager?.requestAlwaysAuthorization()
		}
	}


	private func startLocationManager(_ manager: CLLocationManager?) {	SWIFTLog_Func()

		if (manager == nil) {
			return
		}
		

		SWIFTLog(didStartLocationManager.description)

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

	private func stopLocationManager(_ manager: CLLocationManager?) {	SWIFTLog_Func()

		NotificationCenter.default.removeObserver(self)

		manager?.stopUpdatingLocation()


		didStartLocationManager = false
	}


	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {	SWIFTLog_Func()

		SWIFTLog(String(status.rawValue))


		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(manager)
		}
		else {
			self.stopLocationManager(manager)
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		lastLocation = locations.last
		SWIFTLog(lastLocation)
	}


	func observedUIApplicationDidBecomeActive(_ notification: Notification) {	SWIFTLog_Func()
		SWIFTLog(notification)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
		SWIFTLog(mainLocationManager?.desiredAccuracy)
	}

	func observedUIApplicationDidEnterBackground(_ notification: Notification) {
		SWIFTLog_Func()
		SWIFTLog(notification)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers*2.0
		SWIFTLog(mainLocationManager?.desiredAccuracy)
	}
}
