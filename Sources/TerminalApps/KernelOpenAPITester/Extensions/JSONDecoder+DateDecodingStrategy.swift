//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/24/23.
//

import Foundation
import KernelSwiftCommon

extension JSONDecoder.DateDecodingStrategy {
    public static var flexible: Self {
        .custom( { (decoder) -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            let length = dateStr.count
            var date: Date? = nil
            if length == 10 {
                if dateStr.contains("/") { date = DateFormatter.dayFirstNoTime.date(from: dateStr) }
                else { date = DateFormatter.noTime.date(from: dateStr) }
            } else if length == 20 {
                date = DateFormatter.iso8601NoTimeZone.date(from: dateStr)
            } else if length == 25 {
                date = DateFormatter.iso8601InternetTimeZone.date(from: dateStr)
            } else {
                date = DateFormatter.iso8601FractionalInternetTimeZone.date(from: dateStr)
            }
            guard let formattedDate = date else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode \(dateStr)")
            }
            return formattedDate
        })
    }
}
