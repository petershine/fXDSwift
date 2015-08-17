

import UIKit

import CoreLocation
import MapKit


class FXDmoduleGeo: FXDsuperModule, CLLocationManagerDelegate {


	lazy var mainGeoManager : CLLocationManager = {	FXDLogFunc()
		let geoManager = CLLocationManager()
		geoManager.delegate = self
		NSLog("geoManager: \(geoManager)")

		return geoManager
	}()


	func startGeoModule() {	FXDLogFunc()
		let status = CLLocationManager.authorizationStatus()

		if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
			self.locationManager(self.mainGeoManager, didChangeAuthorizationStatus: status)
		}
		else {
			NSLog("status.rawValue: \(status.rawValue)")
			self.mainGeoManager.requestAlwaysAuthorization()
		}
	}


	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {	FXDLogFunc()

		NSLog("status.rawValue: \(status.rawValue)")


		if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
			manager.startUpdatingLocation()
		}
		else {
			//manager.stopUpdatingLocation()
		}
	}

	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		NSLog("locations.last: \(locations.last)")
	}
}
