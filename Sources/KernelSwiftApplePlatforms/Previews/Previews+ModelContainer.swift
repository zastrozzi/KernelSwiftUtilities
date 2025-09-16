//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 05/09/2023.
//

import Foundation
import SwiftUI
import SwiftData

@available(swift 5.9)
@available(iOS 17.0, macOS 14.0, *)
public struct PreviewModelContainerConfiguration {
    //    var modelConfiguration: ModelConfiguration = .init(isStoredInMemoryOnly: true)
    //    var schema: Schema
    var modelContainer: ModelContainer
    
    public init(for forTypes: any PersistentModel.Type...) {
        let schema: Schema = .init(forTypes)
        let modelConfiguration: ModelConfiguration = .init(schema: schema, isStoredInMemoryOnly: true)
        self.modelContainer = try! .init(for: schema, configurations: modelConfiguration)
    }
}

extension View {
    @available(iOS 17.0, macOS 14.0, *)
    public func previewModelContainer(forConfig config: PreviewModelContainerConfiguration) -> some View {
        MainActor.assertIsolated()
        return self.modelContainer(config.modelContainer)
    }
}
