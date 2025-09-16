//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
struct DestinationBuilderModifier<TypedData>: ViewModifier {
    let typedDestinationBuilder: DestinationBuilder<TypedData>
    
    @EnvironmentObject var destinationBuilder: DestinationBuilderHolder
    
    func body(content: Content) -> some View {
        content
            .environmentObject(destinationBuilder)
            .onAppear { destinationBuilder.appendBuilder(typedDestinationBuilder) }
    }
}
#endif
