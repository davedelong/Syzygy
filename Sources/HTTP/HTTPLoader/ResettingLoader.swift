//
//  Resetting.swift
//  
//
//  Created by Dave DeLong on 1/31/20.
//

import Foundation

public class ResettingLoader: HTTPLoader {
    
    private var isResetting = false
    private let queue = DispatchQueue(label: "ResettingLoader")
    
    public override func load(task: HTTPTask) {
        queue.async {
            if self.isResetting == true {
                task.fail(.resetInProgress)
            } else if let next = self.nextLoader {
                next.load(task: task)
            } else {
                task.fail(.cannotConnect)
            }
        }
    }
    
    public override func reset(with group: DispatchGroup) {
        group.enter()
        queue.async {
            guard self.isResetting == false else {
                group.leave()
                return
            }
            
            guard let next = self.nextLoader else {
                group.leave()
                return
            }
            
            self.isResetting = true
            let subGroup = DispatchGroup()
            next.reset(with: subGroup)
            
            subGroup.notify(queue: self.queue) {
                self.isResetting = false
                group.leave()
            }
        }
    }
    
}
