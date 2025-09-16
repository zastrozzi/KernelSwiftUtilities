//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
struct DestinationBuilderView<Data>: View {
    let data: Data

    @EnvironmentObject var destinationBuilder: DestinationBuilderHolder
    
    var body: some View {
        // MARK: - made view types (any View) over AnyView so currently wrapping in AnyView here
        AnyView(destinationBuilder.build(data))
    }
    
//    @ViewBuilder
//    func buildBody() -> some View {
//        destinationBuilder.build(data) as? AnyView
//    }
}
#endif
