//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import Foundation
import KernelSwiftTerminal
import OpenAPIKit30
import Yams

struct DocumentDeocdeView: View {
    @ObservedObject var model: DocumentDecodeModel
    
    public struct Line: Identifiable {
        let id: Int
        var string: String
    }
    
    var yamlLines: [Line] {
        model.yamlString.components(separatedBy: "\n")
            .enumerated()
            .map{Line(id: $0.offset, string: $0.element) }
    }
    
    var body: some View {
        
        VStack {
            Text("Decode OpenAPI Document").bold().foregroundColor(.magenta)
            Text("--------------------------------------")
            
            if let doc = model.decodedDocument {
                Text("\(doc.openAPIVersion)").foregroundColor(.green)
                HStack(spacing: 1) {
                    Text("\(model.yamlString.count)")
                        .foregroundColor(.yellow)
                    Text("UTF-8 bytes -> OpenAPI documentation.")
                }
            }
            
            if model.yamlString.isEmpty {
               
                Button("Decode OpenAPI Document From YAML") {
                    model.decode()
                }
                .background(.blue)
                .foregroundColor(.threesix)
                
            }else {
                Button("Clear") {
                    model.decodedDocument = nil
                    model.yamlString = ""
                }
                .background(.blue)
                .foregroundColor(.yellow)
                
                HStack(spacing: 1) {
                    Text("Lines")
                    Text("\(yamlLines.count)")
                }
                ScrollView {
//                    Text(model.yamlString)
                    ForEach(yamlLines,
                            id: \.id) { line in
                        HStack {
                            Button("\(line.id)") {}
                            Text(line.string) // need to find a way to multiline this
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

