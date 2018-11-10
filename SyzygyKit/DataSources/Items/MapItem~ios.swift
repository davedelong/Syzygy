//
//  MapItem~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 11/9/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import MapKit

open class MapItem: DataSourceItemCell, MKMapViewDelegate {
    
    private let map: MKMapView
    
    public init(annotation: MKAnnotation) {
        map = MKMapView(frame: CGRect(x: 0, y: 0, width: 320, height: 320))
        super.init()
        embedSubview(map)
        
        map.isUserInteractionEnabled = false
        map.isZoomEnabled = false
        map.isPitchEnabled = false
        map.isRotateEnabled = false
        map.isScrollEnabled = false
        
        map.heightAnchor.constraint(equalTo: map.widthAnchor, multiplier: 1.0).isActive = true
        
        map.delegate = self
        map.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "store")
        map.addAnnotation(annotation)
    }
    
    public required init?(coder aDecoder: NSCoder) { Abort.because(.shutUpXcode) }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        map.showAnnotations(map.annotations, animated: false)
    }
    
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pin = mapView.dequeueReusableAnnotationView(withIdentifier: "store", for: annotation)
        pin.canShowCallout = false
        return pin
    }
    
}
