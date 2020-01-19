//
//  SyzygyRangeSlider.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/27/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

#if BUILDING_FOR_UIKIT

import UIKit
import QuartzCore

public class SyzygyRangeSlider: UIControl {
    private static let thumbDimension: CGFloat = 32
    private static let halfThumb: CGFloat = thumbDimension / 2.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        _ = extantTrack
        _ = minThumb
        _ = maxThumb
        _ = valueTrack
        
        // move thumbs to front
        addSubview(minThumb)
        addSubview(maxThumb)
        
        isUserInteractionEnabled = true
        isEnabled = true
    }
    
    private var _actualValue: ClosedRange<Double> = 0...1
    public var value: ClosedRange<Double> {
        get { return _actualValue }
        set {
            _actualValue = newValue.clamped(to: 0...1)
            setNeedsUpdateConstraints()
        }
    }
    private func _setValue(_ newValue: ClosedRange<Double>) {
        if value != newValue {
            _actualValue = newValue
            sendActions(for: .valueChanged)
        }
    }
    
    private lazy var extantTrack: UIView = {
        var f = bounds
        let v = ShapeView(frame: f)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.shape = Shape.horizontalPill
        v.shapeColor = UIColor(white: 0.9, alpha: 1.0)
        addSubview(v)
        v.leading.constraint(equalTo: leadingAnchor).isActive = true
        v.trailing.constraint(equalTo: trailingAnchor).isActive = true
        v.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        v.height.constraint(equalToConstant: 8).isActive = true
        return v
    }()
    
    private lazy var valueTrack: UIView = {
        let v = UIView(frame: extantTrack.bounds)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = Color(hexString: "3378F6")?.color
        addSubview(v)
        v.top.constraint(equalTo: extantTrack.top).isActive = true
        v.bottom.constraint(equalTo: extantTrack.bottom).isActive = true
        v.leading.constraint(equalTo: minThumb.centerXAnchor).isActive = true
        v.trailing.constraint(equalTo: maxThumb.centerXAnchor).isActive = true
        return v
    }()
    
    private var minPosition: NSLayoutConstraint?
    private var maxPosition: NSLayoutConstraint?
    
    private lazy var minThumb: ShapeView = {
        let p = allowedMinPositionRange().lowerBound
        let v = ShapeView(frame: CGRect(x: p, y: 0, width: SyzygyRangeSlider.thumbDimension, height: SyzygyRangeSlider.thumbDimension))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.shape = .circle
        v.shapeColor = .white
        v.lineColor = .lightGray
        v.lineWidth = 1.0 / UIScreen.main.scale
        addSubview(v)
        
        minPosition = v.centerXAnchor.constraint(equalTo: leadingAnchor)
        minPosition?.constant = p
        minPosition?.isActive = true
        v.centerYAnchor.constraint(equalTo: extantTrack.centerYAnchor).isActive = true
        v.height.constraint(equalToConstant: SyzygyRangeSlider.thumbDimension).isActive = true
        v.width.constraint(equalToConstant: SyzygyRangeSlider.thumbDimension).isActive = true
        return v
    }()
    
    private lazy var maxThumb: ShapeView = {
        let p = allowedMaxPositionRange().upperBound
        let v = ShapeView(frame: CGRect(x: p, y: 0, width: SyzygyRangeSlider.thumbDimension, height: SyzygyRangeSlider.thumbDimension))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.shape = .circle
        v.shapeColor = .white
        v.lineColor = .lightGray
        v.lineWidth = 1.0 / UIScreen.main.scale
        addSubview(v)
        
        maxPosition = v.centerXAnchor.constraint(equalTo: leadingAnchor)
        maxPosition?.constant = p
        maxPosition?.isActive = true
        v.centerYAnchor.constraint(equalTo: extantTrack.centerYAnchor).isActive = true
        v.height.constraint(equalToConstant: SyzygyRangeSlider.thumbDimension).isActive = true
        v.width.constraint(equalToConstant: SyzygyRangeSlider.thumbDimension).isActive = true
        return v
    }()
    
    private func unclampedPosition(for value: Double) -> CGFloat {
        let trackWidth = extantTrack.frame.width
        let actualTrackWidth = trackWidth - SyzygyRangeSlider.thumbDimension
        
        let proportionalPosition = actualTrackWidth * CGFloat(value)
        let position = proportionalPosition + SyzygyRangeSlider.halfThumb
        return position
    }
    
    private func allowedMinPositionRange() -> ClosedRange<CGFloat> {
        let maxPosition = unclampedPosition(for: value.upperBound)
        let maxMinPosition = maxPosition - SyzygyRangeSlider.thumbDimension
        return unclampedPosition(for: 0) ... maxMinPosition
    }
    
    private func allowedMaxPositionRange() -> ClosedRange<CGFloat> {
        let minPosition = unclampedPosition(for: value.lowerBound)
        let minMaxPosition = minPosition + SyzygyRangeSlider.thumbDimension
        return minMaxPosition ... unclampedPosition(for: 1.0)
    }
    
    private func value(from position: CGFloat) -> Double {
        let absolutePosition = position - SyzygyRangeSlider.halfThumb
        let trackWidth = extantTrack.frame.width - SyzygyRangeSlider.thumbDimension
        return Double(absolutePosition / trackWidth)
    }
    
    private enum TrackingThumb {
        case min
        case max
    }
    private var trackingThumb: TrackingThumb?
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        minPosition?.constant = unclampedPosition(for: value.lowerBound)
        maxPosition?.constant = unclampedPosition(for: value.upperBound)
    }
    
    public override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let p = touch.location(in: self)
        if minThumb.frame.contains(p) {
            trackingThumb = .min
            minThumb.shapeColor = .gray
            return true
        } else if maxThumb.frame.contains(p) {
            trackingThumb = .max
            maxThumb.shapeColor = .gray
            return true
        } else {
            trackingThumb = nil
            return super.beginTracking(touch, with: event)
        }
    }
    
    public override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        guard let t = trackingThumb else { return false }
        
        let p = touch.location(in: self)
        switch t {
            case .min:
                let allowedRange = allowedMinPositionRange()
                let actualPosition = allowedRange.clamping(p.x)
                minPosition?.constant = actualPosition
                
                _setValue(value(from: actualPosition) ... _actualValue.upperBound)
            case .max:
                let allowedRange = allowedMaxPositionRange()
                let actualPosition = allowedRange.clamping(p.x)
                maxPosition?.constant = actualPosition
                
                _setValue(_actualValue.lowerBound ... value(from: actualPosition))
        }
        return true
    }
    
    public override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        if let t = touch {
            _ = continueTracking(t, with: event)
        }
        cancelTracking(with: event)
    }
    
    public override func cancelTracking(with event: UIEvent?) {
        minThumb.shapeColor = .white
        maxThumb.shapeColor = .white
        trackingThumb = nil
    }
}

#endif
