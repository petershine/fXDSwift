

import UIKit
import Foundation

import CoreLocation
import MapKit

import ReactiveSwift
import ReactiveCocoa
import Result


class FXDmoduleGeo: NSObject, CLLocationManagerDelegate {

	let (lastLocationSignal, lastLocationObserver) = Signal<CLLocation, NoError>.pipe()

	var didStartLocationManager : Bool = false
	
	var mainLocationManager : CLLocationManager?
	var lastLocation: CLLocation?


	deinit {	FXDLog_Func()
		stopLocationManager(mainLocationManager)
	}


	func startGeoModule() {	FXDLog_Func()
		debugPrint(CLLocationManager.locationServicesEnabled().description)
		debugPrint(CLLocationManager.significantLocationChangeMonitoringAvailable().description)
		debugPrint(CLLocationManager.isRangingAvailable().description)
		debugPrint(CLLocationManager.deferredLocationUpdatesAvailable().description)

		if (CLLocationManager.locationServicesEnabled() == false) {
			return
		}


		mainLocationManager = CLLocationManager()
		mainLocationManager?.delegate = self
		mainLocationManager?.distanceFilter = 100

		mainLocationManager?.pausesLocationUpdatesAutomatically = false
		/*
		*      With UIBackgroundModes set to include "location" in Info.plist, you must
		*      also set this property to YES at runtime whenever calling
		*      -startUpdatingLocation with the intent to continue in the background.
		*
		*      Setting this property to YES when UIBackgroundModes does not include
		*      "location" is a fatal error.
		*/
		mainLocationManager?.allowsBackgroundLocationUpdates = true


		let status = CLLocationManager.authorizationStatus()
		debugPrint(String(status.rawValue))

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
		

		debugPrint(didStartLocationManager.description)

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

	func updatePlacemarks() {	FXDLog_Func()
		let geocoder: CLGeocoder = CLGeocoder()

		geocoder.reverseGeocodeLocation(
		(self.mainLocationManager?.location)!) {
			(placemarks, error) in

			debugPrint(error)

			debugPrint(placemarks)
			
		}
	}


	public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {	FXDLog_Func()

		debugPrint(String(status.rawValue))


		if (status == .authorizedAlways || status == .authorizedWhenInUse) {
			self.startLocationManager(manager)
		}
		else {
			self.stopLocationManager(manager)
		}
	}

	public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		/*
		if (self.lastLocation == nil ||
			(locations.last?.distance(from: self.lastLocation!))! > 10.0 as CLLocationDistance) {
*/

			self.lastLocation = locations.last
			debugPrint(self.lastLocation)

			self.lastLocationObserver.send(value: self.lastLocation!)
//		}
	}


	func observedUIApplicationDidBecomeActive(_ notification: Notification) {	FXDLog_Func()
		debugPrint(notification)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyBest
		debugPrint(mainLocationManager?.desiredAccuracy)
	}

	func observedUIApplicationDidEnterBackground(_ notification: Notification) {
		FXDLog_Func()
		debugPrint(notification)

		mainLocationManager?.desiredAccuracy = kCLLocationAccuracyThreeKilometers*2.0
		debugPrint(mainLocationManager?.desiredAccuracy)
	}
}
