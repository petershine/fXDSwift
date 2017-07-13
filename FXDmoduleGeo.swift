

import UIKit
import Foundation

import CoreLocation
import MapKit

import ReactiveSwift
import Result
/*
import ReactiveCocoa
 */


class FXDmoduleGeo {

	let (lastLocationSignal, lastLocationObserver) = Signal<CLLocation?, NoError>.pipe()

	var didStartLocationManager: Bool? = false
	
	var mainLocationManager: CLLocationManager?
	var lastLocation: CLLocation?


	deinit {	FXDLog_Func()
		stopLocationManager(mainLocationManager)
	}


	func startGeoModule() {	FXDLog_Func()
		FXDLog(CLLocationManager.locationServicesEnabled().description)
		FXDLog(CLLocationManager.significantLocationChangeMonitoringAvailable().description)
		FXDLog(CLLocationManager.isRangingAvailable().description)
		FXDLog(CLLocationManager.deferredLocationUpdatesAvailable().description)

		guard CLLocationManager.locationServicesEnabled() != false else {
			return
		}


		self.mainLocationManager = CLLocationManager()
		self.mainLocationManager?.delegate = self
		self.mainLocationManager?.distanceFilter = 100

		self.mainLocationManager?.pausesLocationUpdatesAutomatically = false
		/*
		*      With UIBackgroundModes set to include "location" in Info.plist, you must
		*      also set this property to YES at runtime whenever calling
		*      -startUpdatingLocation with the intent to continue in the background.
		*
		*      Setting this property to YES when UIBackgroundModes does not include
		*      "location" is a fatal error.
		*/
		self.mainLocationManager?.allowsBackgroundLocationUpdates = true


		let status = CLLocationManager.authorizationStatus()
		FXDLog(String(status.rawValue))

		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(self.mainLocationManager)
		}
		else {
			//MARK: If the NSLocationAlwaysUsageDescription key is not specified in your Info.plist, this method will do nothing, as your app will be assumed not to support Always authorization.

			self.mainLocationManager?.requestAlwaysAuthorization()
		}
	}


	func startLocationManager(_ manager: CLLocationManager?) {	FXDLog_Func()

		guard manager != nil else {
			return
		}
		

		FXDLog(self.didStartLocationManager as Any)

		guard self.didStartLocationManager != true else {
			return
		}


		self.didStartLocationManager = true


		manager?.desiredAccuracy = kCLLocationAccuracyBest

		if (UIApplication.shared.applicationState == .background) {
			manager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers
		}

		manager?.startUpdatingLocation()


		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(observedUIApplicationDidBecomeActive(_:)),
		                                       name: NSNotification.Name.UIApplicationDidBecomeActive,
		                                       object: nil)

		NotificationCenter.default.addObserver(self,
		                                       selector: #selector(observedUIApplicationDidEnterBackground(_:)),
		                                       name: NSNotification.Name.UIApplicationDidEnterBackground,
		                                       object: nil)
	}

	func stopLocationManager(_ manager: CLLocationManager?) {	FXDLog_Func()

		NotificationCenter.default.removeObserver(self)

		manager?.stopUpdatingLocation()


		didStartLocationManager = false
	}

	func updatePlacemarks() {	FXDLog_Func()

		guard self.mainLocationManager?.location != nil else {
			return
		}


		let geocoder: CLGeocoder = CLGeocoder()

		geocoder.reverseGeocodeLocation((self.mainLocationManager?.location)!) {
			[weak self] (placemarks, error) in

			FXDLog(error as Any)

			FXDLog(placemarks as Any)
			
		}
	}


	func observedUIApplicationDidBecomeActive(_ notification: Notification) {	FXDLog_Func()
		FXDLog(notification)

		self.mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
		FXDLog(self.mainLocationManager?.desiredAccuracy as Any)
	}

	func observedUIApplicationDidEnterBackground(_ notification: Notification) {
		FXDLog_Func()
		FXDLog(notification)

		self.mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers*2.0
		FXDLog(self.mainLocationManager?.desiredAccuracy as Any)
	}
}

extension FXDmoduleGeo: CLLocationManagerDelegate {
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {	FXDLog_Func()

		FXDLog(String(status.rawValue))


		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(manager)
		}
		else {
			self.stopLocationManager(manager)
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		/*
		if (self.lastLocation == nil ||
		(locations.last?.distance(from: self.lastLocation!))! > 10.0 as CLLocationDistance) {
		*/

		self.lastLocation = locations.last
		FXDLog(self.lastLocation as Any)

		self.lastLocationObserver.send(value: self.lastLocation!)
		//		}
	}
}
