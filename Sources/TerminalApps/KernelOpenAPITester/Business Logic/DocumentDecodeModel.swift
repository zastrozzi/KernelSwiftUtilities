//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/7/23.
//

import Foundation
import KernelSwiftTerminal
import OpenAPIKit30
import Yams

// Defined here, held by the TesterModel and distributed to concerns.
class DocumentDecodeModel: ObservableObject {
    
    /// The URL and its source string of the OpenAPI YAML document.
    @Published var ingress: DocumentIngressModel?
    
    /// String decoded from utf-8 data at the url of the ingress.
    @Published var yamlString = ""
    
    /// An OpenAPI Document from the decodedYaml data or nil.
    @Published var decodedDocument: OpenAPI.Document?
    
    /// The number of bytes were decoded.
    @Published var bytes: Int = 0
    
    init(ingress: DocumentIngressModel?) {
        self.ingress = ingress
    }
    
    /// Decodes the data at the ingress url into deocdedYaml.
    func decode() {
        
        guard let u = ingress?.url else {
            Messager.log(sys: .execution, s: "decode valled witn no url. Cneck ingress")
            return
        }
        
        Messager.log(sys: .execution, s: "decoding \(u.absoluteString)")
        
        let data = TesterNetworking.shared.getYamlDataFrom(url:u)
        bytes = data.count
        yamlString = data.utf8Description
        decodedDocument = try?  YAMLDecoder().decode(OpenAPI.Document.self,
                                                     from: data)
        Messager.log(sys: .execution, s: "decoded \(u.absoluteString)")
    }
}
