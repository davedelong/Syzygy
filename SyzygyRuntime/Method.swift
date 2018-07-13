//
//  Method.swift
//  SyzygyRuntime
//
//  Created by Dave DeLong on 7/11/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Method {
    
    public struct Definition {
        public let selector: Selector
        public let returnType: Type
        public let argumentTypes: Array<Type>
        
        internal init(description: objc_method_description) {
            let s = description.name !! "method description is missing its selector"
            let typeString = description.types !! "method description is missing its type string"
            
            self.init(selector: s, typeString: typeString)
        }
        
        internal init(selector: Selector, typeString: UnsafePointer<Int8>) {
            self.selector = selector
            let types = Type.types(from: String(cString: typeString))
            self.returnType = types.first !! "type string must have at least one type in it"
            self.argumentTypes = Array(types.dropFirst())
        }
        
    }
    
    private let method: OpaquePointer
    
    public let definition: Definition
    public let implementation: IMP
    
    internal init(method: OpaquePointer) {
        self.method = method
        self.implementation = method_getImplementation(method)
        
        let encoding = method_getTypeEncoding(method) !! "method returned a nil type encoding"
        let name = method_getName(method)
        self.definition = Definition(selector: name, typeString: encoding)
    }
    
}
