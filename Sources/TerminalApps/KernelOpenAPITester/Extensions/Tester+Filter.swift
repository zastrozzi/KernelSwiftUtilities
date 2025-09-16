//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/26/23.
//

import Foundation
import KernelSwiftCommon
import OpenAPIKit30

extension Tester {
    
    enum Filter {
        case exampleOnly(Bool)
        case exampledOnlyEvenPartials(Bool)
        case onlySummariedAs([String])
        
        func process(_ routes: [ResolvedRoute]) -> [ResolvedRoute] {
            let unfiltered = routes
            
            switch self {
                
            case .exampleOnly(let t):
                guard t else {
                    return unfiltered
                }
                // Examines the routes in and returns routes from them whose endpoint is fully exampled.
                var exRs = [ResolvedRoute]()
                routes.forEach { r in
                    // if the routes fully exampled endpoints arent empty.
                    if !r.endpoints.filter({ $0.isFullyExampled}).isEmpty {
                        exRs.append(r)
                    }
                }
                return exRs
            
            case .exampledOnlyEvenPartials(let evenPartials):
                guard evenPartials else {
                    return unfiltered
                }
                
                var exRs = [ResolvedRoute]()
                routes.forEach { r in
                    if !r.endpoints.filter({ $0.isPartiallyExampled}).isEmpty {
                        exRs.append(r)
                    }
                }
                return exRs
                
            case .onlySummariedAs(let onlySummariedAs):
                
                guard !onlySummariedAs.isEmpty else {
                    
                    return routes
                }
                
                var summariedRoutes = [ResolvedRoute]()
                
                for (_, summary) in onlySummariedAs.enumerated() {
                    for (_, route) in routes.enumerated() {
                        for (_, ep) in route.endpoints.enumerated() {
                            if let sum = ep.endpointSummary {
                                if  summary == sum {
                                    summariedRoutes.append(route)
                                }
                            }else {
                                print("no summary")
                            }
                        }
                    }
                }
                return summariedRoutes
            }
        }
    }
}
