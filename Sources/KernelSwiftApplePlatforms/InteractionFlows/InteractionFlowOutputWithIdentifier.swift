//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/09/2023.
//

import Foundation

public struct InteractionFlowOutputWithIdentifier<Identifier: InteractionFlowElementIdentifiable> {
    public init(_ identifier: Identifier, key: String, _ output: InteractionFlowOutput) {
        self.identifier = identifier
        self.output = output
        self.key = key
    }
    
    public var identifier: Identifier
    public var output: InteractionFlowOutput
    public var key: String
}
