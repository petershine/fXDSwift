

import UIKit

import CoreLocation
import MapKit


class FXDmoduleGeo: FXDsuperModule, CLLocationManagerDelegate {


	lazy var mainGeoManager : CLLocationManager = {	FXDLog_Func()
		let geoManager = CLLocationManager()
		geoManager.delegate = self
		
		FXDLog(geoManager)

		return geoManager
	}()


	func startGeoModule() {	FXDLog_Func()

		let status = CLLocationManager.authorizationStatus()
		NSLog("\(status.rawValue)")

		if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
			mainGeoManager.startUpdatingLocation()
		}
		else {
			mainGeoManager.requestAlwaysAuthorization()
		}
	}


	func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {	FXDLog_Func()

		NSLog("\(status.rawValue)")


		if (status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
			manager.startUpdatingLocation()
		}
		else {
			manager.stopUpdatingLocation()
		}
	}

	func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		FXDLog(locations.last)
	}
}
