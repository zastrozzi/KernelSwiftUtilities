//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 27/08/2023.
//

import Foundation

public protocol InteractionFlowElementIdentifiable: Equatable, RawRepresentable<String>, LosslessStringConvertible, Sendable {
    var inputTitle: String { get }
}

extension InteractionFlowElementIdentifiable {
    //    public static func == (lhs: Self, rhs: Self) -> Bool {
    //        lhs.rawValue == rhs.rawValue
    //    }
    //
    public init?(_ description: String) {
        if let fromRaw = Self.init(rawValue: description) {
            self = fromRaw
        }
        else { return nil }
    }
    
    public var description: String {
        self.rawValue
    }
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.description == rhs.description
    }
    
    public static func ==<Identifier: InteractionFlowElementIdentifiable>(lhs: Self, rhs: Identifier) -> Bool {
        lhs.description == rhs.description
    }
    
    public static func ==<Identifier: InteractionFlowElementIdentifiable>(lhs: Identifier, rhs: Self) -> Bool {
        lhs.description == rhs.description
    }
    
    public static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.description != rhs.description
    }
    
    public static func !=<Identifier: InteractionFlowElementIdentifiable>(lhs: Self, rhs: Identifier) -> Bool {
        lhs.description != rhs.description
    }
    
    public static func !=<Identifier: InteractionFlowElementIdentifiable>(lhs: Identifier, rhs: Self) -> Bool {
        lhs.description != rhs.description
    }
}

extension Array where Element == any InteractionFlowElementIdentifiable {
    public func contains(_ other: any InteractionFlowElementIdentifiable) -> Bool {
        self.contains(where: {$0 == other})
    }
}

public func == (lhs: any InteractionFlowElementIdentifiable, rhs: any InteractionFlowElementIdentifiable) -> Bool {
    lhs.description == rhs.description
}

public func ==<Identifier: InteractionFlowElementIdentifiable>(lhs: any InteractionFlowElementIdentifiable, rhs: Identifier) -> Bool {
    lhs.description == rhs.description
}

public func ==<Identifier: InteractionFlowElementIdentifiable>(lhs: Identifier, rhs: any InteractionFlowElementIdentifiable) -> Bool {
    lhs.description == rhs.description
}

public func != (lhs: any InteractionFlowElementIdentifiable, rhs: any InteractionFlowElementIdentifiable) -> Bool {
    lhs.description != rhs.description
}

public func !=<Identifier: InteractionFlowElementIdentifiable>(lhs: any InteractionFlowElementIdentifiable, rhs: Identifier) -> Bool {
    lhs.description != rhs.description
}

public func !=<Identifier: InteractionFlowElementIdentifiable>(lhs: Identifier, rhs: any InteractionFlowElementIdentifiable) -> Bool {
    lhs.description != rhs.description
}

public func == (lhs: (any InteractionFlowElementIdentifiable)?, rhs: (any InteractionFlowElementIdentifiable)?) -> Bool {
    lhs?.description == rhs?.description
}

public func ==<Identifier: InteractionFlowElementIdentifiable>(lhs: (any InteractionFlowElementIdentifiable)?, rhs: Identifier) -> Bool {
    lhs?.description == rhs.description
}

public func ==<Identifier: InteractionFlowElementIdentifiable>(lhs: Identifier, rhs: (any InteractionFlowElementIdentifiable)?) -> Bool {
    lhs.description == rhs?.description
}

public func != (lhs: any InteractionFlowElementIdentifiable, rhs: (any InteractionFlowElementIdentifiable)?) -> Bool {
    lhs.description != rhs?.description
}

public func !=<Identifier: InteractionFlowElementIdentifiable>(lhs: (any InteractionFlowElementIdentifiable)?, rhs: Identifier) -> Bool {
    lhs?.description != rhs.description
}

public func !=<Identifier: InteractionFlowElementIdentifiable>(lhs: Identifier, rhs: (any InteractionFlowElementIdentifiable)?) -> Bool {
    lhs.description != rhs?.description
}
