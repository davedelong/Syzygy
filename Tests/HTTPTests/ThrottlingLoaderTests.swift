//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import XCTest
import HTTP

fileprivate enum TaskState {
    case waiting
    case loading
    case done
}

class ThrottlingLoaderTests: HTTPTestCase {
    
    lazy var throttle: ThrottlingLoader = {
        let t = ThrottlingLoader()
        t.setNextLoader(mock)
        return t
    }()
    
    func test_NoLimit_DoesNotThrottle() {
        mock.assertsForUncompletedTasks = false
        throttle.maximumNumberOfTasks = 0
        
        let taskCount = 4
        var states = Array(repeating: TaskState.waiting, count: taskCount)
        for i in 0 ..< taskCount {
            let t = HTTPTask(request: HTTPRequest(), completion: { result in
                states[i] = .done
            })
            
            throttle.load(task: t)
            
            mock.then { task in
                states[i] = .loading
                async(after: 0.25) { task.ok("") }
            }
        }
        // since nothing is getting throttled,
        // everything should be done within about a quarter second
        wait(0.3)
        
        for state in states {
            XCTAssertEqual(state, .done)
        }
    }
    
    func test_Limit_ThrottlesTasks() {
        mock.assertsForUncompletedTasks = false
        throttle.maximumNumberOfTasks = 1
        
        var e1 = TaskState.waiting
        mock.then { task in
            e1 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e1 = .done
        })
        
        var e2 = TaskState.waiting
        mock.then { task in
            e2 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e2 = .done
        })
        
        var e3 = TaskState.waiting
        mock.then { task in
            e3 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e3 = .done
        })
        
        wait(0.1)
        // after 0.1 seconds, the first task should be started, but not done
        // no other task should be started
        XCTAssertEqual(e1, .loading)
        XCTAssertEqual(e2, .waiting)
        XCTAssertEqual(e3, .waiting)
        
        wait(0.2)
        // after 0.3 seconds, the first task should be done
        // the second task should be started, but not done
        // the third task should not be started
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .loading)
        XCTAssertEqual(e3, .waiting)
        
        wait(0.3)
        // after 0.6 seconds, the first two tasks should be done
        // the third task should be started but not done
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .loading)
        
        wait(0.3)
        // after 0.9 seconds, all tasks should be done
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .done)
    }
    
    func test_IncreasingLimitToInfinity() {
        mock.assertsForUncompletedTasks = false
        throttle.maximumNumberOfTasks = 1
        
        var e1 = TaskState.waiting
        mock.then { task in
            e1 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e1 = .done
        })
        
        var e2 = TaskState.waiting
        mock.then { task in
            e2 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e2 = .done
        })
        
        var e3 = TaskState.waiting
        mock.then { task in
            e3 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e3 = .done
        })
        
        wait(0.1)
        // after 0.1 seconds, the first task should be started, but not done
        // no other task should be started
        XCTAssertEqual(e1, .loading)
        XCTAssertEqual(e2, .waiting)
        XCTAssertEqual(e3, .waiting)
        
        // increase to infinity
        throttle.maximumNumberOfTasks = 0
        
        wait(0.1)
        // after 0.2 seconds, all tasks should be started
        // no task should be done
        XCTAssertEqual(e1, .loading)
        XCTAssertEqual(e2, .loading)
        XCTAssertEqual(e3, .loading)
        
        wait(0.1)
        // after 0.3 seconds, the first task should be done
        // the other two tasks should be started
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .loading)
        XCTAssertEqual(e3, .loading)
        
        wait(0.3)
        // after 0.6 seconds, all three tasks should be done
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .done)
    }
    
    func test_IncreasingLimitBy1() {
        mock.assertsForUncompletedTasks = false
        throttle.maximumNumberOfTasks = 1
        
        var e1 = TaskState.waiting
        mock.then { task in
            e1 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e1 = .done
        })
        
        var e2 = TaskState.waiting
        mock.then { task in
            e2 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e2 = .done
        })
        
        var e3 = TaskState.waiting
        mock.then { task in
            e3 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e3 = .done
        })
        
        var e4 = TaskState.waiting
        mock.then { task in
            e4 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e4 = .done
        })
        
        wait(0.1)
        // after 0.1 seconds, the first task should be started, but not done
        // no other task should be started
        XCTAssertEqual(e1, .loading)
        XCTAssertEqual(e2, .waiting)
        XCTAssertEqual(e3, .waiting)
        XCTAssertEqual(e4, .waiting)
        
        // increase to 2
        throttle.maximumNumberOfTasks = 2
        
        wait(0.1)
        // after 0.2 seconds, the first two tasks should be started
        // the third and fourth tasks should be waiting
        XCTAssertEqual(e1, .loading)
        XCTAssertEqual(e2, .loading)
        XCTAssertEqual(e3, .waiting)
        XCTAssertEqual(e4, .waiting)
        
        wait(0.1)
        // after 0.3 seconds, the first task should be done
        // the second and third tasks should be started but not done
        // the fourth task should not be started
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .loading)
        XCTAssertEqual(e3, .loading)
        XCTAssertEqual(e4, .waiting)
        
        wait(0.15)
        // after 0.45 seconds, the first two tasks should be done
        // the 3rd and 4th should be started
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .loading)
        XCTAssertEqual(e4, .loading)
        
        wait(0.15)
        // after 0.6 seconds, the first three tasks should be done
        // the fourth task should be started
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .done)
        XCTAssertEqual(e4, .loading)
        
        wait(0.2)
        // after 0.8 seconds, all tasks should be done
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .done)
        XCTAssertEqual(e4, .done)
    }
    
    func test_DecreasingLimit() {
        mock.assertsForUncompletedTasks = false
        throttle.maximumNumberOfTasks = 2
        
        var e1 = TaskState.waiting
        mock.then { task in
            e1 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e1 = .done
        })
        
        var e2 = TaskState.waiting
        mock.then { task in
            e2 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e2 = .done
        })
        
        var e3 = TaskState.waiting
        mock.then { task in
            e3 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e3 = .done
        })
        
        var e4 = TaskState.waiting
        mock.then { task in
            e4 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e4 = .done
        })
        
        wait(0.1)
        // after 0.1 seconds, the first two tasks should be started, but not done
        // no other task should be started
        XCTAssertEqual(e1, .loading)
        XCTAssertEqual(e2, .loading)
        XCTAssertEqual(e3, .waiting)
        XCTAssertEqual(e4, .waiting)
        
        // decrease to 1
        throttle.maximumNumberOfTasks = 1
        
        wait(0.2)
        // after 0.3 seconds, the first two tasks should be done
        // the third task should be started but not done
        // the fourth task should not be started
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .loading)
        XCTAssertEqual(e4, .waiting)
        
        wait(0.3)
        // after 0.6 seconds, the first three tasks should be done
        // the fourth task should be started
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .done)
        XCTAssertEqual(e4, .loading)
        
        wait(0.3)
        // after 0.9 seconds, all tasks should be done
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .done)
        XCTAssertEqual(e4, .done)
    }
    
    func test_Resetting_CancelsTasks() {
        mock.assertsForUncompletedTasks = false
        throttle.maximumNumberOfTasks = 1
        
        var e1 = TaskState.waiting
        mock.then { task in
            e1 = .loading
            async(after: 0.25) { task.ok("") }
        }
        throttle.load(request: HTTPRequest(), completion: { result in
            e1 = .done
        })
        
        var e2 = TaskState.waiting
        // does not need a mock.then { ... } call because it should be cancelled
        throttle.load(request: HTTPRequest(), completion: { result in
            e2 = .done
        })
        
        var e3 = TaskState.waiting
        // does not need a mock.then { ... } call because it should be cancelled
        throttle.load(request: HTTPRequest(), completion: { result in
            e3 = .done
        })
        
        wait(0.1)
        // after 0.1 seconds, the first task should be started
        // the others should be waiting
        XCTAssertEqual(e1, .loading)
        XCTAssertEqual(e2, .waiting)
        XCTAssertEqual(e3, .waiting)
        
        let doneResetting = expect()
        throttle.reset { doneResetting.fulfill() }
        wait(for: doneResetting, timeout: 2.0)
        
        // everything should be done
        XCTAssertEqual(e1, .done)
        XCTAssertEqual(e2, .done)
        XCTAssertEqual(e3, .done)
        
    }
    
}
