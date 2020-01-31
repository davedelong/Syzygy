//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import XCTest
import HTTP

class ResettingLoaderTests: HTTPTestCase {
    
    lazy var reset: ResettingLoader = {
        let r = ResettingLoader()
        r.setNextLoader(mock)
        return r
    }()
    
    func test_ResettingMultipleTimes_ResetsOnce() {
        
        let expectReset = expect()
        expectReset.expectedFulfillmentCount = 1
        
        let done = expect()
        mock.resetHandler = { g in
            expectReset.fulfill()
            g.enter()
            async(after: 0.1, execute: {
                g.leave()
                done.fulfill()
            })
        }
        
        reset.reset { }
        reset.reset { }
        reset.reset { }
        
        wait()
    }
    
    func test_LoadingDuringResetting_FailsTask() {
        
        let done = expect()
        mock.resetHandler = { g in
            g.enter()
            async(after: 0.1, execute: {
                g.leave()
                done.fulfill()
            })
        }
        
        reset.reset { }
        
        let loadDone = expect()
        reset.load(request: HTTPRequest(), completion: { result in
            if let err = XCTAssertFailure(result) {
                XCTAssertEqual(err.code, .resetInProgress)
            }
            loadDone.fulfill()
        })
        
        wait()
    }
}
