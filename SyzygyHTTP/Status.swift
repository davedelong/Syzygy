//
//  StatusCode.swift
//  SyzygyHTTP
//
//  Created by Dave DeLong on 1/20/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import Foundation

public struct Status: Newtype, ExpressibleByIntegerLiteral, Equatable {
    
    public enum Kind {
        case informational
        case success
        case redirect
        case clientError
        case serverError
        case unknown
    }
    
    public static let ok: Status = 200
    
    public static let movedPermanently: Status = 301
    public static let found: Status = 302
    public static let notModified: Status = 304
    public static let temporaryRedirect: Status = 307
    public static let permanentRedirect: Status = 308
    
    public static let badRequest: Status = 400
    public static let unauthorized: Status = 401
    public static let forbidden: Status = 403
    public static let notFound: Status = 404
    
    public static let internalServerError: Status = 500
    public static let serviceUnavailable: Status = 503
    
    public let rawValue: Int
    public let kind: Kind
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
        switch rawValue {
            case 100 ..< 200: kind = .informational
            case 200 ..< 300: kind = .success
            case 300 ..< 400: kind = .redirect
            case 400 ..< 500: kind = .clientError
            case 500 ..< 600: kind = .serverError
            default: kind = .unknown
        }
    }
    public init(integerLiteral value: UInt16) { self.init(rawValue: Int(value)) }
    
    public var isInformational: Bool { return kind == .informational }
    public var isSuccess: Bool { return kind == .success }
    public var isRedirect: Bool { return kind == .redirect }
    public var isClientError: Bool { return kind == .clientError }
    public var isServerError: Bool { return kind == .serverError }
    
    public var description: String { return HTTPURLResponse.localizedString(forStatusCode: rawValue) }
}
