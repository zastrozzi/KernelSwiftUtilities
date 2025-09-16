//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/05/2023.
//

import Foundation
import Fluent

public protocol DatabaseTimestampedModel: Model {
    var dbCreatedAt: Date? { get set }
    var dbUpdatedAt: Date? { get set }
    var dbDeletedAt: Date? { get set }
}

