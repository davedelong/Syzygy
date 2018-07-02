//
//  LocationDelegate.swift
//  SyzygyLocation
//
//  Created by Dave DeLong on 7/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import CoreLocation

internal class LocationDelegate: NSObject, CLLocationManagerDelegate {
    
    private let status: MutableProperty<CLAuthorizationStatus>
    private let location: MutableProperty<CLLocation?>
    
    init(status: MutableProperty<CLAuthorizationStatus>, location: MutableProperty<CLLocation?>) {
        self.status = status
        self.location = location
        super.init()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let sorted = locations.sorted { $0.timestamp > $1.timestamp }
        if let newest = sorted.first {
            location.value = newest
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status.value = status
    }
    
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        
    }
    
}
