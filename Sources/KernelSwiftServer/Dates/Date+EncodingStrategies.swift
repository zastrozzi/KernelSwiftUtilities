//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 22/01/2025.
//

import Vapor

extension URLEncodedFormEncoder.Configuration.DateEncodingStrategy {
    public static func withFormatter(_ formatter: DateFormatter) -> Self {
        .custom { date, encoder in
            let dateStr = formatter.string(from: date)
            try dateStr.encode(to: encoder)
        }
    }
}

