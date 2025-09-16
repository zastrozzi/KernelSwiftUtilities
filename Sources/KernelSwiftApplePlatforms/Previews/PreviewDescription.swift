//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/08/2023.
//

import Foundation
import SwiftUI

public struct PreviewDescription: View {
    let label: String
    public init(_ label: String) {
        self.label = label
    }
    
    public var body: some View {
        HStack {
            Text(label).font(.headline).foregroundStyle(.secondary)
        }.padding(.horizontal)
    }
}
