//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import XCTest

@discardableResult
public func XCTAssertSuccess<S, F>(_ expression: @autoclosure () throws -> Result<S, F>, file: StaticString = #file, line: UInt = #line) -> S? {
    do {
        let result = try expression()
        switch result {
        case .success(let value):
            return value
        case .failure(let error):
            XCTFail("Unexpectedly found an error when unwrapping result: \(error)", file: file, line: line)
        }
        
    } catch let e {
        XCTFail("Unexpected thrown error: \(e)", file: file, line: line)
    }
    return nil
}

@discardableResult
public func XCTAssertFailure<S, F>(_ expression: @autoclosure () throws -> Result<S, F>, file: StaticString = #file, line: UInt = #line) -> F? {
    do {
        let result = try expression()
        switch result {
        case .success(let value):
            XCTFail("Unexpectedly found a value when unwrapping result: \(value)", file: file, line: line)
            return nil
        case .failure(let error):
            return error
        }
        
    } catch let e {
        XCTFail("Unexpected thrown error: \(e)", file: file, line: line)
    }
    return nil
}
