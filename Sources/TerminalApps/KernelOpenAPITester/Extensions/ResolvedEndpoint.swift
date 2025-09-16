//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/27/23.
//

import Foundation
import OpenAPIKit30

extension ResolvedEndpoint {
    /// Returns true if the endpoint has example request and response data.
    var isFullyExampled: Bool {
        isRequestExampled && isResponseExampled
    }
    
    /// Returns true if either the requests or responses are exampled for self.
    var isPartiallyExampled: Bool {
        isRequestExampled || isResponseExampled
    }
    
    /// Many results from an action...
    // this is so we can poke further into tests that arent fully exampled
    var isResponseExampled: Bool {
        !(responses.isEmpty)
    }
    
    var isRequestExampled: Bool {
        (requestBody != nil)
    }
}
