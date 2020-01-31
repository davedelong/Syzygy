//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/21/20.
//

import Foundation

public class DebugLoader: HTTPLoader {
    
    private let shouldLog: Bool
    
    public convenience override init() {
        #if DEBUG
        self.init(shouldLog: true)
        #else
        self.init(shouldLog: false)
        #endif
    }
    
    public init(shouldLog: Bool) {
        self.shouldLog = shouldLog
        super.init()
    }
    
    public override func load(task: HTTPTask) {
        if shouldLog == true {
            var lines = Array<String>()
            let uuid = task.request.identifier.uuidString
            lines.append("===\(uuid)===")
            lines.append(task.request.description)
            lines.append("")
            print(lines.joined(separator: "\n"))
            
            task.addCompletionHandler { result in
                var lines = Array<String>()
                lines.append("===\(uuid)===")
                
                switch result {
                    case .success(let response):
                        lines.append(response.description)
                    
                    case .failure(let error):
                        lines.append(error.description)
                }
                
                lines.append("")
                print(lines.joined(separator: "\n"))
            }
        }
        
        if let next = nextLoader {
            next.load(task: task)
        } else {
            task.fail(.cannotConnect)
        }
    }
    
}
