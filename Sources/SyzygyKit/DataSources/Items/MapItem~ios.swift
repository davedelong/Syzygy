//
//  MapItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/9/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import MapKit

open class MapItem: DataSourceItemCell, MKMapViewDelegate {
    
    private let map: MKMapView
    private let pinTintColor: PlatformColor?
    
    public init(annotation: MKAnnotation, pinTintColor: PlatformColor? = nil) {
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        self.pinTintColor = pinTintColor
        super.init()
        embedSubview(map)
        
        #if BUILDING_FOR_UIKIT
        map.isUserInteractionEnabled = false
        #endif
        map.isZoomEnabled = false
        map.isPitchEnabled = false
        map.isRotateEnabled = false
        map.isScrollEnabled = false
        
        map.height.constraint(equalTo: map.width).isActive = true
        
        map.delegate = self
        map.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "pin")
        map.addAnnotation(annotation)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        map.showAnnotations(map.annotations, animated: false)
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = mapView.dequeueReusableAnnotationView(withIdentifier: "pin", for: annotation) as! MKPinAnnotationView
        pin.canShowCallout = false
        pin.pinTintColor = pinTintColor
        return pin
    }
    
}

#endif
