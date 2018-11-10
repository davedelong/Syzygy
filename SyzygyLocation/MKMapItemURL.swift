//
//  MKMapItemURL.swift
//  SyzygyLocation
//
//  Created by Dave DeLong on 10/29/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation
import MapKit

public struct MapURLComponents {
    
    fileprivate let parameters: Dictionary<String, String>
    
    private init(parameters: Dictionary<String, String>) {
        self.parameters = parameters
    }
    
    public enum MapType: String {
        case standard = "m"
        case satellite = "s"
        case hybrid = "h"
        case transit = "r"
    }
    
    public enum Region {
        case zoomLevel(Float)
        case span(MKCoordinateSpan)
    }
    
    public static func query(_ string: String, near: CLLocationCoordinate2D? = nil, mapType: MapType? = nil, region: Region? = nil) -> MapURLComponents {
        var p = Dictionary<String, String>()
        p["q"] = string
        
        if let n = near {
            p["near"] = "\(n.latitude),\(n.longitude)"
        }
        
        if let t = mapType {
            p["t"] = t.rawValue
        }
        
        switch region {
            case .zoomLevel(let z)?:
                p["z"] = "\(min(max(z, 2), 21))"
            case .span(let s)?:
                p["spn"] = "\(s.latitudeDelta),\(s.longitudeDelta)"
            default: break
        }
        
        return MapURLComponents(parameters: p)
    }
    
}

extension URL {
    
    public init(mapURLComponents: MapURLComponents) {
        let queryItems = mapURLComponents.parameters.map { URLQueryItem(name: $0, value: $1) }
    }
    
}
