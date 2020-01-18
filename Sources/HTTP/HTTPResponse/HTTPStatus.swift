//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public struct HTTPStatus: Equatable, Hashable, Comparable {
    
    public static func < (lhs: HTTPStatus, rhs: HTTPStatus) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
    
    public var isInformational: Bool { return 100 ..< 200 ~= rawValue }
    public var isSuccess: Bool { return 200 ..< 300 ~= rawValue }
    public var isRedirecton: Bool { return 300 ..< 400 ~= rawValue }
    public var isClientError: Bool { return 400 ..< 500 ~= rawValue }
    public var isServerError: Bool { return 500 ..< 600 ~= rawValue }
}

public extension HTTPStatus {
    
    static let ok = HTTPStatus(rawValue: 200)
    static let created = HTTPStatus(rawValue: 201)
    static let accepted = HTTPStatus(rawValue: 202)
    static let noContent = HTTPStatus(rawValue: 204)
    
    static let movedPermanently = HTTPStatus(rawValue: 301)
    static let found = HTTPStatus(rawValue: 302)
    static let notModified = HTTPStatus(rawValue: 304)
    
    static let badRequest = HTTPStatus(rawValue: 400)
    static let unauthorized = HTTPStatus(rawValue: 401)
    static let paymentRequired = HTTPStatus(rawValue: 402)
    static let forbidden = HTTPStatus(rawValue: 403)
    static let notFound = HTTPStatus(rawValue: 404)
    static let methodNotAllowed = HTTPStatus(rawValue: 405)
    static let notAcceptable = HTTPStatus(rawValue: 406)
    static let timedOut = HTTPStatus(rawValue: 408)
    static let conflict = HTTPStatus(rawValue: 409)
    static let gone = HTTPStatus(rawValue: 410)
    static let lengthRequired = HTTPStatus(rawValue: 411)
    static let preconditionFailed = HTTPStatus(rawValue: 412)
    static let payloadTooLarge = HTTPStatus(rawValue: 413)
    static let uriTooLong = HTTPStatus(rawValue: 414)
    static let unsupportedMediaType = HTTPStatus(rawValue: 415)
    
    static let internalServerError = HTTPStatus(rawValue: 500)
    static let notImplemented = HTTPStatus(rawValue: 501)
    static let badGateway = HTTPStatus(rawValue: 502)
    static let serviceUnavailable = HTTPStatus(rawValue: 503)
    static let gatewayTimeout = HTTPStatus(rawValue: 504)
    
}

extension HTTPStatus: CustomStringConvertible {
    
    public var description: String {
        return HTTPURLResponse.localizedString(forStatusCode: rawValue)
    }
    
}

extension HTTPStatus: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self.init(rawValue: value)
    }
    
}
