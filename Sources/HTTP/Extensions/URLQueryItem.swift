//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

private let formURLEncodedAllowed = CharacterSet(charactersIn: "&=:/, ").inverted

extension URLQueryItem {
    
    internal func encoded(using allowedCharacters: CharacterSet) -> String {
        return (name.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? "") +
            "=" +
            ((value ?? "").addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? "")
    }
    
    internal var formURLEncoded: String {
        return encoded(using: formURLEncodedAllowed)
    }
    
}

extension Array where Element == URLQueryItem {
    
    internal func replacing(name: String, with value: String?) -> Array<URLQueryItem> {
        var copy = Array(self)
        if let index = copy.firstIndex(where: { $0.name == name }) {
            if let value = value {
                copy[index] = URLQueryItem(name: name, value: value)
            } else {
                copy.remove(at: index)
            }
        } else if let value = value {
            copy.append(URLQueryItem(name: name, value: value))
        }
        return copy
    }
    
}
