//
//  LocationProvider.swift
//  SyzygyLocation
//
//  Created by Dave DeLong on 7/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

import CoreLocation

public class LocationProvider {
    
    public enum DesiredAuthorizationLevel {
        case whenInUse
        case always
    }
    
    public enum DesiredAccuracy {
        case forNavigation
        case best
        case within10Meters
        case within100Meters
        case within1000Meters
        case within3000Meters
        
        fileprivate init(value: CLLocationAccuracy) {
            switch value {
                case kCLLocationAccuracyBestForNavigation: self = .forNavigation
                case kCLLocationAccuracyBest: self = .best
                case kCLLocationAccuracyNearestTenMeters: self = .within10Meters
                case kCLLocationAccuracyHundredMeters: self = .within100Meters
                case kCLLocationAccuracyKilometer: self = .within1000Meters
                case kCLLocationAccuracyThreeKilometers: self = .within3000Meters
                default: self = .within100Meters
            }
        }
        
        fileprivate var clAccuracy: CLLocationAccuracy {
            switch self {
                case .forNavigation: return kCLLocationAccuracyBestForNavigation
                case .best: return kCLLocationAccuracyBest
                case .within10Meters: return kCLLocationAccuracyNearestTenMeters
                case .within100Meters: return kCLLocationAccuracyHundredMeters
                case .within1000Meters: return kCLLocationAccuracyKilometer
                case .within3000Meters: return kCLLocationAccuracyThreeKilometers
            }
        }
    }
 
    public static let `default` = LocationProvider(level: .whenInUse)
    
    private let _latestLocation = MutableProperty<CLLocation?>(nil)
    private let _authorizationStatus = MutableProperty<CLAuthorizationStatus>(.notDetermined)
    
    public let latestLocation: Property<CLLocation?>
    
    private let level: DesiredAuthorizationLevel
    private let locationMananger: CLLocationManager
    private let locationDelegate: LocationDelegate
    
    private var requestCount = 0
    private var updatingLocation = false
    
    public var desiredAccuracy: DesiredAccuracy {
        get { return DesiredAccuracy(value: locationMananger.desiredAccuracy) }
        set { locationMananger.desiredAccuracy = newValue.clAccuracy }
    }
    
    public init(level: DesiredAuthorizationLevel = .whenInUse) {
        let mainInfo = Bundle.main.infoPlist
        let whenInUse = mainInfo["NSLocationWhenInUseUsageDescription"]
        let always = mainInfo["NSLocationAlwaysUsageDescription"]
        let either = mainInfo["NSLocationAlwaysAndWhenInUseUsageDescription"]
        
        if whenInUse.isString == false && always.isString == false && either.isString == false {
            Abort.because("Missing Info.plist keys about Location usage")
        }
        if level == .always && (always.isString == false && either.isString == false) {
            Abort.because("Missing Info.plist key explaining Always location usage")
        }
        if level == .whenInUse && (whenInUse.isString == false && either.isString == false) {
            Abort.because("Missing Info.plist key explaining When In Use location usage")
        }
        
        self.level = level
        
        latestLocation = _latestLocation.combine(_authorizationStatus).map { (l, s) -> CLLocation? in
            if s == .authorizedAlways || s == .authorizedWhenInUse { return l }
            return nil
        }.skipRepeats(==)
        
        locationDelegate = LocationDelegate(status: _authorizationStatus, location: _latestLocation)
        locationMananger = CLLocationManager()
        locationMananger.delegate = self.locationDelegate
    }
    
    deinit {
        if updatingLocation {
            locationMananger.stopUpdatingLocation()
        }
    }
    
    public func beginLocationUpdates() {
        Assert.isMainThread()
        requestCount += 1
        
        if updatingLocation == false {
            if level == .whenInUse {
                locationMananger.requestWhenInUseAuthorization()
            } else {
                locationMananger.requestAlwaysAuthorization()
            }
            updatingLocation = true
            locationMananger.startUpdatingLocation()
        }
    }
    
    public func stopLocationUpdates() {
        Assert.isMainThread()
        requestCount -= 1
        if requestCount == 0 {
            locationMananger.stopUpdatingLocation()
            updatingLocation = false
        }
    }
    
}
