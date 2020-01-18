//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import XCTest
@testable import HTTP

class LinkedListTests: XCTestCase {
    
    func test_EmptyList() {
        let l = LinkedList<Int>()
        XCTAssertEqual(l.count, 0)
    }
    
    func test_EmptyList_Append() {
        let l = LinkedList<Int>()
        l.append(1)
        XCTAssertEqual(l.count, 1)
        XCTAssertEqual(l.first, 1)
        XCTAssertEqual(l.last, 1)
    }
    
    func test_EmptyList_InsertAtHead() {
        let l = LinkedList<Int>()
        l.insert(1, at: 0)
        XCTAssertEqual(l.count, 1)
        XCTAssertEqual(l.first, 1)
        XCTAssertEqual(l.last, 1)
    }
    
    func test_EmptyList_InsertAtPositiveOutOfBoundsIndex() {
        let l = LinkedList<Int>()
        l.insert(1, at: 1_000_000)
        XCTAssertEqual(l.count, 1)
        XCTAssertEqual(l.first, 1)
        XCTAssertEqual(l.last, 1)
    }
    
    func test_EmptyList_InsertAtNegativeOutOfBoundsIndex() {
        let l = LinkedList<Int>()
        l.insert(1, at: -1_000_000)
        XCTAssertEqual(l.count, 1)
        XCTAssertEqual(l.first, 1)
        XCTAssertEqual(l.last, 1)
    }
    
    func test_InsertIntoMiddle() {
        let l = LinkedList<Int>()
        l.append(0)
        l.append(1)
        l.append(3)
        l.insert(2, at: 2)
        XCTAssertEqual(l.count, 4)
        XCTAssertEqual(l, [0, 1, 2, 3])
    }
    
    func test_MutatingDuringIteration_FailsIteration() {
        let l = LinkedList<Int>()
        l.append(1)
        
        var i = l.makeIterator()
        l.append(2)
        
        XCTAssertNil(i.next())
    }
    
    func test_EmptyList_IteratorIsEmpty() {
        let l = LinkedList<Int>()
        let values = Array(l)
        XCTAssertTrue(values.isEmpty)
    }
    
    func test_RemoveAll() {
        let l: LinkedList = [0, 1, 2, 3]
        l.removeAll()
        XCTAssertTrue(l.isEmpty)
    }
    
    func test_RemoveFirst() {
        let l = LinkedList<Int>()
        l.append(1)
        let v = l.removeFirst()
        XCTAssertEqual(v, 1)
        XCTAssertTrue(l.isEmpty)
    }
    
    func test_RemoveLast() {
        let l = LinkedList<Int>()
        l.append(1)
        let v = l.removeLast()
        XCTAssertEqual(v, 1)
        XCTAssertTrue(l.isEmpty)
    }
    
    func test_RemoveAtHeadIndex() {
        let l: LinkedList = [0, 1, 2, 3]
        let v = l.remove(at: 0)
        XCTAssertEqual(v, 0)
        XCTAssertEqual(l, [1, 2, 3])
        XCTAssertEqual(l.first, 1)
    }
    
    func test_RemoveAtMiddleIndex() {
        let l: LinkedList = [0, 1, 2, 3]
        let v = l.remove(at: 2)
        XCTAssertEqual(v, 2)
        XCTAssertEqual(l, [0, 1, 3])
    }
    
    func test_RemoveAtTailIndex() {
        let l: LinkedList = [0, 1, 2, 3]
        let v = l.remove(at: 3)
        XCTAssertEqual(v, 3)
        XCTAssertEqual(l, [0, 1, 2])
        XCTAssertEqual(l.last, 2)
    }
    
    func test_IdentityEqual() {
        let l: LinkedList = [0, 1, 2]
        XCTAssertEqual(l, l)
    }
    
    func test_EqualLists() {
        let l: LinkedList = [0, 1, 2]
        let r: LinkedList = [0, 1, 2]
        XCTAssertEqual(l, r)
    }
    
    func test_UnequalListCounts() {
        let l: LinkedList = [0, 1, 2]
        let r: LinkedList = [1, 2]
        XCTAssertNotEqual(l, r)
    }
    
    func test_UnequalLists() {
        let l: LinkedList = [0, 1, 2]
        let r: LinkedList = [1, 2, 3]
        XCTAssertNotEqual(l, r)
    }
    
}
