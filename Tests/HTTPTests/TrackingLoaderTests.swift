//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import XCTest
import HTTP

class TrackingLoaderTests: HTTPTestCase {
    
    let tracker = TrackingLoader()
    
    override func setUp() {
        super.setUp()
        tracker.setNextLoader(mock)
    }
    
    func test_ResettingLoader_CancelsOutstandingTasks() {
        mock.assertsForUncompletedTasks = false
        
        let numberOfTasks = 10
        
        let cancelled = expect()
        cancelled.expectedFulfillmentCount = numberOfTasks
        
        for _ in 0 ..< numberOfTasks {
            mock.then { task in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { task.ok() }
            }
            
            let t = HTTPTask(request: HTTPRequest(), completion: { _ in })
            t.addCancelHandler { cancelled.fulfill() }
            
            tracker.load(task: t)
        }
        
        let done = expect()
        tracker.reset { done.fulfill() }
        wait()
    }
    
}
