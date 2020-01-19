//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import XCTest
import ObjectiveC

extension XCTestCase {
    
    public func expect(_ name: String? = nil, times: Int = 1, function: String = #function, file: String = #file, line: Int = #line) -> XCTestExpectation {
        _ = injectWaiterHandlingOnce
        
        let n = name ?? "\(function):\(line)"
        
        let e = expectation(description: n)
        e.expectedFulfillmentCount = times
        e.expectationFile = file
        e.expectationLine = line
        
        return e
    }
    
    public func wait(for expectations: XCTestExpectation..., timeout: TimeInterval = 1.0, enforceOrder: Bool = true) {
        self.wait(for: expectations, timeout: timeout, enforceOrder: enforceOrder)
    }
    
    public func wait(timeout: TimeInterval = 1.0) {
        self.waitForExpectations(timeout: timeout, handler: nil)
    }
    
    public func wait(_ interval: TimeInterval) {
        let e = expect()
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: { e.fulfill() })
        wait(for: e, timeout: interval * 1.1)
    }
    
    @objc fileprivate func xctestexpectations_inject_waiter(_ waiter: XCTWaiter, didTimeoutWithUnfulfilledExpectations unfulfilledExpectations: [XCTestExpectation]) {
        var unhandled = Array<XCTestExpectation>()
        for expectation in unfulfilledExpectations {
            if let f = expectation.expectationFile, let l = expectation.expectationLine {
                let description = "Asynchronous wait failed: Exceeded timeout with unfulfilled expectation: \(expectation.description)"
                recordFailure(withDescription: description, inFile: f, atLine: l, expected: false)
            } else {
                unhandled.append(expectation)
            }
        }
        
        if unhandled.isEmpty == false {
            self.xctestexpectations_inject_waiter(waiter, didTimeoutWithUnfulfilledExpectations: unhandled)
        }
    }
}

private let injectWaiterHandlingOnce: Bool = {
    let target = XCTestCase.self
    
    let selector = #selector(XCTestCase.waiter(_:didTimeoutWithUnfulfilledExpectations:))
    let injectSelector = #selector(XCTestCase.xctestexpectations_inject_waiter(_:didTimeoutWithUnfulfilledExpectations:))
    
    guard let oldMethod = class_getInstanceMethod(target, selector) else { return false }
    guard let newMethod = class_getInstanceMethod(target, injectSelector) else { return false }
    method_exchangeImplementations(oldMethod, newMethod)
    return true
}()
