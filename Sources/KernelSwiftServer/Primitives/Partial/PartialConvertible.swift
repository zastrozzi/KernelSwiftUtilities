//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 18/04/2023.
//

import Foundation

public protocol PartialConvertible: Codable {
    init<P: PartialProtocol<Self>>(partial: P) throws
}
