//
//  Header.swift
//  SyzygyHTTP
//
//  Created by Dave DeLong on 2/17/18.
//  Copyright © 2018 Syzygy. All rights reserved.
//

import SyzygyCore

public struct Header {
    
    internal static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.calendar = Calendar(identifier: .gregorian)
        df.timeZone = TimeZone(secondsFromGMT: 0)
        df.dateFormat = "EEE, d MMM y HH:mm:ss zzz"
        return df
    }()
    
    public let name: String
    public let value: String
    
    public init(name: String, value: String? = nil) {
        self.name = name
        self.value = value ?? ""
    }
}

public extension Header {
    
    public static func contentType(_ uti: UTI) -> Header {
        return Header(name: "Content-Type", value: uti.preferredMIMEType)
    }
    
    public static func ifModifiedSince(etag: String) -> Header {
        return Header(name: "If-None-Match", value: etag)
    }
    
    public static func ifModifiedSince(_ date: Date) -> Header {
        return Header(name: "If-Modified-Since", value: Header.dateFormatter.string(from: date))
    }
    
    public static func range(_ bytes: Range<Int>) -> Header {
        let range = "bytes=\(bytes.lowerBound)-\(bytes.upperBound)"
        return Header(name: "Range", value: range)
    }
    
    public static let userAgent = Header(name: "User-Agent", value: "SyzygyHTTP/1.0.0 (Macintosh; OS X/\(System.releaseVersion) NSURLSession")
    
    public static func userAgent(_ agent: String) -> Header {
        return Header(name: "User-Agent", value: agent)
    }
    
    public static let doNotTrack = Header(name: "DNT", value: "1 (Do Not Track Enabled)")
    
}
