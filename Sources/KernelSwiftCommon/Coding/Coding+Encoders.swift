//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/07/2023.
//

//import Vapor
import Foundation

extension KernelSwiftCommon.Coding {
    nonisolated(unsafe) public static var lexicographicJSONEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        return encoder
    }()
}
