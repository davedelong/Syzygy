//
//  Protocol.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import ObjectiveC.runtime

public extension Protocol {
    
    public var conformingProtocols: Array<Protocol> {
        var conforming = Array<Protocol>()
        protocol_enumerateConformingProtocols(self, false) { p, _ in
            conforming.append(p)
        }
        return conforming
    }
    
    public var transitivelyConformingProtocols: Array<Protocol> {
        var conforming = Array<Protocol>()
        protocol_enumerateConformingProtocols(self, true) { p, _ in
            conforming.append(p)
        }
        return conforming
    }
    
    public var requiredClassMethods: Array<Method.Definition> {
        return methods(required: true, instance: false)
    }
    
    public var optionalClassMethods: Array<Method.Definition> {
        return methods(required: false, instance: false)
    }
    
    public var requiredInstanceMethods: Array<Method.Definition> {
        return methods(required: true, instance: true)
    }
    
    public var optionalInstanceMethods: Array<Method.Definition> {
        return methods(required: false, instance: true)
    }
    
    public func methods(required: Bool, instance: Bool) -> Array<Method.Definition> {
        var methods = Array<Method.Definition>()
        protocol_enumerateMethods(self) { methodDescription, req, ins, _ in
            if req == required && ins == instance {
                let d = Method.Definition(description: methodDescription)
                methods.append(d)
            }
        }
        return methods
    }
    
}
