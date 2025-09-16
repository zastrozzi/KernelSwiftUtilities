//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/08/2022.
//

import Foundation
import SwiftUI

#if compiler(>=5.7)
@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
public struct BackportNavigationLink<P: Hashable, Label: View>: View {
    @EnvironmentObject var pathHolder: NavigationPathHolder
    
    var value: P?
    var label: Label
    
    public init(value: P?, @ViewBuilder label: () -> Label) {
        self.value = value
        self.label = label()
    }
    
    public var body: some View {
        Button(
            action: {
                guard let value = value else { return }
                pathHolder.path.wrappedValue.append(value)
            },
            label: { label }
        )
    }
}

@available(iOS, deprecated: 17.0, message: "Use SwiftUI Navigation API")
extension BackportNavigationLink where Label == Text {
    public init(_ titleKey: LocalizedStringKey, value: P?) {
        self.init(value: value) { Text(titleKey) }
    }
    
    public init<S>(_ title: S, value: P?) where S: StringProtocol {
        self.init(value: value) { Text(title) }
    }
}
#endif
