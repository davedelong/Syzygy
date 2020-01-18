//
//  JSON+Expressible.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 11/19/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public protocol JSONExpressible {
    var json: JSON { get }
}

extension Bool: JSONExpressible {
    public var json: JSON { return JSON(self) }
}

extension String: JSONExpressible {
    public var json: JSON { return JSON(self) }
}

extension Int: JSONExpressible {
    public var json: JSON { return JSON(self) }
}

extension Double: JSONExpressible {
    public var json: JSON { return JSON(self) }
}

extension Array: JSONExpressible where Element: JSONExpressible {
    public var json: JSON { return JSON(map { $0.json }) }
}

extension Dictionary: JSONExpressible where Key == String, Value: JSONExpressible {
    public var json: JSON { return JSON(mapValues { $0.json }) }
}
