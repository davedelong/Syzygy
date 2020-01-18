//
//  Property+Combine.swift
//  SyzygyCore
//
//  Created by Dave DeLong on 12/31/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation
import Core

public extension Property {
    
    static func latest(from properties: Array<Property<T>>, defaultValue: T) -> Property<T> {
        let initial = properties.last?.value ?? defaultValue
        let m = MutableProperty(initial)
        
        properties.forEach {
            $0.observeNext { m.value = $0 }
        }
        
        return m
    }
    
    static func combine<C: Collection>(_ properties: C) -> Property<Array<T>> where C.Iterator.Element == Property<T> {
        let props = Array(properties)
        let initial = props.map { $0.value }
        
        let m = MutableProperty(initial)
        let value = Atomic(initial)
        
        props.enumerated().forEach { (offset, property) in
            property.observeNext { v in
                value.modify { now in
                    var current = now
                    current[offset] = v
                    m.value = current
                    return current
                }
            }
        }
        
        
        return m
    }
    
    // these could technically be accomplished by chaining .combine calls and then flattening a tuple
    // however, that *REALLY* complicates backtraces
    // so for the sake of easier backtracing, each variant gets duplicated here
    func combine<A>(_ a: Property<A>) -> Property<(T, A)> {
        
        let initial = (value, a.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1) } }
        a.observeNext { new in combined.modify { ($0.0, new) } }
        
        return combined
    }
    
    func combine<A, B>(_ a: Property<A>, _ b: Property<B>) -> Property<(T, A, B)> {
        let initial = (value, a.value, b.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new) } }
        
        return combined
    }
    
    func combine<A, B, C>(_ a: Property<A>, _ b: Property<B>, _ c: Property<C>) -> Property<(T, A, B, C)> {
        let initial = (value, a.value, b.value, c.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2, $0.3) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2, $0.3) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new, $0.3) } }
        c.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, new) } }
        
        return combined
    }
    
    func combine<A, B, C, D>(_ a: Property<A>, _ b: Property<B>, _ c: Property<C>, _ d: Property<D>) -> Property<(T, A, B, C, D)> {
        let initial = (value, a.value, b.value, c.value, d.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2, $0.3, $0.4) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2, $0.3, $0.4) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new, $0.3, $0.4) } }
        c.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, new, $0.4) } }
        d.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, new) } }
        
        return combined
    }
    
    func combine<A, B, C, D, E>(_ a: Property<A>, _ b: Property<B>, _ c: Property<C>, _ d: Property<D>, _ e: Property<E>) -> Property<(T, A, B, C, D, E)> {
        let initial = (value, a.value, b.value, c.value, d.value, e.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2, $0.3, $0.4, $0.5) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2, $0.3, $0.4, $0.5) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new, $0.3, $0.4, $0.5) } }
        c.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, new, $0.4, $0.5) } }
        d.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, new, $0.5) } }
        e.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, new) } }
        
        return combined
    }
    
    func combine<A, B, C, D, E, F>(_ a: Property<A>, _ b: Property<B>, _ c: Property<C>, _ d: Property<D>, _ e: Property<E>, _ f: Property<F>) -> Property<(T, A, B, C, D, E, F)> {
        let initial = (value, a.value, b.value, c.value, d.value, e.value, f.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2, $0.3, $0.4, $0.5, $0.6) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new, $0.3, $0.4, $0.5, $0.6) } }
        c.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, new, $0.4, $0.5, $0.6) } }
        d.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, new, $0.5, $0.6) } }
        e.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, new, $0.6) } }
        f.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, new) } }
        
        return combined
    }
    
    func combine<A, B, C, D, E, F, G>(_ a: Property<A>, _ b: Property<B>, _ c: Property<C>, _ d: Property<D>, _ e: Property<E>, _ f: Property<F>, _ g: Property<G>) -> Property<(T, A, B, C, D, E, F, G)> {
        let initial = (value, a.value, b.value, c.value, d.value, e.value, f.value, g.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new, $0.3, $0.4, $0.5, $0.6, $0.7) } }
        c.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, new, $0.4, $0.5, $0.6, $0.7) } }
        d.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, new, $0.5, $0.6, $0.7) } }
        e.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, new, $0.6, $0.7) } }
        f.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, new, $0.7) } }
        g.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, new) } }
        
        return combined
    }
    
    func combine<A, B, C, D, E, F, G, H>(_ a: Property<A>, _ b: Property<B>, _ c: Property<C>, _ d: Property<D>, _ e: Property<E>, _ f: Property<F>, _ g: Property<G>, _ h: Property<H>) -> Property<(T, A, B, C, D, E, F, G, H)> {
        let initial = (value, a.value, b.value, c.value, d.value, e.value, f.value, g.value, h.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8) } }
        c.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, new, $0.4, $0.5, $0.6, $0.7, $0.8) } }
        d.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, new, $0.5, $0.6, $0.7, $0.8) } }
        e.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, new, $0.6, $0.7, $0.8) } }
        f.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, new, $0.7, $0.8) } }
        g.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, new, $0.8) } }
        h.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, new) } }
        
        return combined
    }
    
    func combine<A, B, C, D, E, F, G, H, I>(_ a: Property<A>, _ b: Property<B>, _ c: Property<C>, _ d: Property<D>, _ e: Property<E>, _ f: Property<F>, _ g: Property<G>, _ h: Property<H>, _ i: Property<I>) -> Property<(T, A, B, C, D, E, F, G, H, I)> {
        let initial = (value, a.value, b.value, c.value, d.value, e.value, f.value, g.value, h.value, i.value)
        let combined = MutableProperty(initial)
        
        self.observeNext { new in combined.modify { (new, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8, $0.9) } }
        a.observeNext { new in combined.modify { ($0.0, new, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8, $0.9) } }
        b.observeNext { new in combined.modify { ($0.0, $0.1, new, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8, $0.9) } }
        c.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, new, $0.4, $0.5, $0.6, $0.7, $0.8, $0.9) } }
        d.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, new, $0.5, $0.6, $0.7, $0.8, $0.9) } }
        e.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, new, $0.6, $0.7, $0.8, $0.9) } }
        f.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, new, $0.7, $0.8, $0.9) } }
        g.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, new, $0.8, $0.9) } }
        h.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, new, $0.9) } }
        i.observeNext { new in combined.modify { ($0.0, $0.1, $0.2, $0.3, $0.4, $0.5, $0.6, $0.7, $0.8, new) } }
        
        return combined
    }
    
}
