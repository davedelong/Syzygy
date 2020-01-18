//
//  File.swift
//  
//
//  Created by Dave DeLong on 1/18/20.
//

import Foundation

public typealias HTTPResult = Result<HTTPResponse, HTTPError>

extension HTTPResult {
    
    public var request: HTTPRequest {
        switch self {
            case .success(let response): return response.request
            case .failure(let error): return error.request
        }
        
    }
    
}

internal extension HTTPResult {
    
    init(request: HTTPRequest, responseData: Data?, response: URLResponse?, error: Error?) {
        var httpResponse: HTTPResponse?
        if let r = response as? HTTPURLResponse {
            httpResponse = HTTPResponse(request: request, response: r, body: responseData ?? Data())
        }
        
        if let e = error as? URLError {
            switch e.code {
            case .badURL: fallthrough
            case .unsupportedURL: fallthrough
            case .cannotFindHost: fallthrough
            case .cannotConnectToHost: fallthrough
            case .dnsLookupFailed: fallthrough
            case .httpTooManyRedirects: fallthrough
            case .notConnectedToInternet: fallthrough
            case .redirectToNonExistentLocation: fallthrough
            case .networkConnectionLost: fallthrough
            case .cannotLoadFromNetwork: fallthrough
            case .callIsActive: fallthrough
            case .dataNotAllowed:
                self = .failure(HTTPError(code: .cannotConnect, request: request, response: httpResponse, underlyingError: e))
                
            case .badServerResponse: fallthrough
            case .cannotParseResponse: fallthrough
            case .zeroByteResource: fallthrough
            case .cannotDecodeRawData: fallthrough
            case .cannotDecodeContentData: fallthrough
            case .resourceUnavailable: fallthrough
            case .dataLengthExceedsMaximum:
                self = .failure(HTTPError(code: .invalidResponse, request: request, response: httpResponse, underlyingError: e))
                
            case .cancelled: fallthrough
            case .userCancelledAuthentication:
                self = .failure(HTTPError(code: .cancelled, request: request, response: httpResponse, underlyingError: e))
                
            case .appTransportSecurityRequiresSecureConnection: fallthrough
            case .secureConnectionFailed: fallthrough
            case .serverCertificateHasBadDate: fallthrough
            case .serverCertificateUntrusted: fallthrough
            case .serverCertificateHasUnknownRoot: fallthrough
            case .serverCertificateNotYetValid: fallthrough
            case .clientCertificateRejected: fallthrough
            case .clientCertificateRequired:
                self = .failure(HTTPError(code: .insecureConnection, request: request, response: httpResponse, underlyingError: e))
                
            case .timedOut:
                self = .failure(HTTPError(code: .timedOut, request: request, response: httpResponse, underlyingError: e))
                
            case .unknown: fallthrough
            default:
                self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: e))
            }
        } else if let decodingError = error as? DecodingError {
            self = .failure(HTTPError(code: .cannotDecodeResponse, request: request, response: httpResponse, underlyingError: decodingError))
        } else if let someError = error {
            // some error, but not a URL error?
            self = .failure(HTTPError(code: .unknown, request: request, response: httpResponse, underlyingError: someError))
        } else if let r = httpResponse {
            self = .success(r)
        } else {
            self = .failure(HTTPError(code: .invalidResponse, request: request, response: nil, underlyingError: error))
        }
    }
}
