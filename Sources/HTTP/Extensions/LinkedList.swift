//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

fileprivate class Node<T> {
    let value: T
    weak var prev: Node<T>?
    var next: Node<T>?
    fileprivate init(_ value: T) {
        self.value = value
    }
}

internal struct LinkedListIterator<Value>: IteratorProtocol {
    fileprivate let list: LinkedList<Value>
    private var current: Node<Value>?
    private let mutationCount: Int
    
    init(_ list: LinkedList<Value>) {
        self.list = list
        self.current = list.head
        self.mutationCount = list.mutationCounter
    }
    
    mutating func next() -> Value? {
        guard mutationCount == list.mutationCounter else {
            #if DEBUG
            print("LinkedList mutated during iteration. This is illegal")
            return nil
            #else
            fatalError("LinkedList mutated during iteration. This is illegal")
            #endif
        }
        let v = current?.value
        current = current?.next
        return v
    }
}

internal class LinkedList<Element>: Sequence, ExpressibleByArrayLiteral {
    
    fileprivate var head: Node<Element>?
    private var tail: Node<Element>?
    fileprivate var mutationCounter = 0
    
    internal private(set) var count: Int = 0
    internal var underestimatedCount: Int { return count }
    
    internal init() { }
    
    required convenience init(arrayLiteral elements: Element...) {
        self.init()
        elements.forEach(self.append)
    }
    
    internal var isEmpty: Bool { return count == 0 }
    internal var first: Element? { return head?.value }
    internal var last: Element? { return tail?.value }
    
    private func node(at index: Int) -> Node<Element>? {
        var current = head
        var offset = 0
        while offset < index && current != nil {
            current = current?.next
            offset += 1
        }
        return current
    }
    
    // additions
    
    internal func append(_ value: Element) {
        insert(value, at: count)
    }
    
    internal func insert(_ value: Element, at index: Int) {
        let node = Node(value)
        
        if index <= 0 {
            node.next = head
            head?.prev = node
            head = node
            if tail == nil { tail = node }
        } else if index >= count {
            tail?.next = node
            node.prev = tail
            tail = node
            if head == nil { head = node }
        } else if let predecessor = self.node(at: index - 1) {
            let successor = predecessor.next
            
            node.next = successor
            node.prev = predecessor
            
            predecessor.next = node
            successor?.prev = node
        } else {
            fatalError("Unable to insert value at index \(index)")
        }
        count += 1
        mutationCounter += 1
    }
    
    // subtractions
    
    internal func removeAll() {
        head = nil
        tail = nil
        count = 0
        mutationCounter += 1
    }
    
    internal func popFirst() -> Element? {
        guard count > 0 else { return nil }
        return removeFirst()
    }
    
    internal func popLast() -> Element? {
        guard count > 0 else { return nil }
        return removeLast()
    }
    
    internal func removeFirst() -> Element {
        return remove(at: 0)
    }
    
    internal func removeLast() -> Element {
        return remove(at: count - 1)
    }
    
    internal func firstIndex(where predicate: (Element) -> Bool) -> Int? {
        var current = head
        var index = 0
        while let this = current {
            if predicate(this.value) == true {
                return index
            }
            current = this.next
            index += 1
        }
        return nil
    }
    
    internal func remove(at index: Int) -> Element {
        guard index >= 0 && index < count else { fatalError("Cannot retrieve node at index \(index)") }
        let n: Node<Element>
        if index == 0 {
            n = head!
        } else if index == count - 1 {
            n = tail!
        } else {
            n = node(at: index)!
        }
                
        let value = n.value
        
        let prev = n.prev
        let next = n.next
        
        prev?.next = next
        next?.prev = prev
        
        if n === head { head = next }
        if n === tail { tail = prev }
        
        count -= 1
        mutationCounter += 1
        return value
    }
    
    // iteration
    
    internal func makeIterator() -> LinkedListIterator<Element> {
        return LinkedListIterator(self)
    }
    
}

extension LinkedList: Equatable where Element: Equatable {
    
    internal static func ==(lhs: LinkedList, rhs: LinkedList) -> Bool {
        if lhs === rhs { return true }
        guard lhs.count == rhs.count else { return false }
        var l = lhs.makeIterator()
        var r = rhs.makeIterator()
        
        while let nextL = l.next(), let nextR = r.next() {
            guard nextL == nextR else { return false }
        }
        
        return true
    }
    
}

extension LinkedList: Hashable where Element: Equatable {
    
    internal func hash(into hasher: inout Hasher) {
        hasher.combine(count)
    }
    
}
