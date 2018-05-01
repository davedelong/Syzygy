//
//  FlowCoordinator.swift
//  SyzygyKit
//
//  Created by Dave DeLong on 5/1/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol FlowCoordinator {
    
    func provideContent() -> SyzygyViewController
    
}
