//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import Foundation
import KernelSwiftTerminal

struct DocumentIngressView: View {
    
    @ObservedObject var ingress: DocumentIngressModel
    
    @State var isEditing = false
    
    var body: some View {
        
        VStack {
            Text("Ingress").bold()
            Text("-----------------")
            HStack(spacing: 1) {
                
                Text("Document URL")
                    .foregroundColor(.default)
                
                if let u = ingress.url?.absoluteString,
                         isValidURL() {
                    Text(u)
                        .foregroundColor(.green)
                }else {
                    
                    HStack(spacing: 1) {
                        Text("!? = ")
                            .foregroundColor(.red)
                        Text(ingress.urlString)
                            .foregroundColor(.red)

                    }
                }
            }
           
            VStack {
                
                Button("Change") {
                    isEditing = true
                }
                .background(.blue)
                .foregroundColor(.yellow)
                
                if isEditing {
                    
                    TextField { s in
                        ingress.urlString = s
                        isEditing = false
                        ingress.ingress()
                    }
                    .background(.blue)
                    .foregroundColor(.yellow)
                    
                    HStack(spacing: 1) {
                        
                        Button("Accept") {
                            isEditing = false
                            ingress.ingress()
                        }
                        .background(.blue)
                        .foregroundColor(.yellow)
                        
                        Button("Cancel") {
                            isEditing = false
                        }
                        .background(.blue)
                        .foregroundColor(.yellow)
                    }
                }
            }
            Spacer()
        }
    }
    
    func isValidURL() -> Bool {
        // later add some validation
        if let _ = ingress.url {
            return true
        }else {
            return false
        }
    }
}
