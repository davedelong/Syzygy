//
//  View~ios.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 7/6/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

public typealias PlatformView = UIView
public typealias PlatformNib = UINib
public typealias PlatformWindow = UIWindow
public typealias PlatformViewController = UIViewController

public extension UINib {
    typealias Name = String
}

public extension UIView.AutoresizingMask {
    public static let width = UIView.AutoresizingMask.flexibleWidth
    public static let height = UIView.AutoresizingMask.flexibleHeight
}
