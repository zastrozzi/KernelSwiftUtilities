//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/7/23.
//


import Foundation
import KernelSwiftTerminal

// Defined here, held by the TesterModel and distributed to concerns.
public class DocumentIngressModel: ObservableObject {
    /// comes from command line param openapiurl as a string
    @Published var urlString: String
    
    /// transforms to a url or remains string in unable.
    @Published var url: URL?
    
    init(url: String) {
        self.urlString = url
        self.url = URL(string: urlString)
    }
    
    func ingress() {
        if let u = URL(string: urlString) {
            self.url = u
        }
    }
}
