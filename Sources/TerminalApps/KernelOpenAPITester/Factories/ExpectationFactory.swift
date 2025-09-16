//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/17/23.
//

import Foundation
import OpenAPIKit30
import Yams
import KernelSwiftCommon

extension OpenAPI.Parameter: CustomStringConvertible {
    public var description: String {
        """
        \(self.required ? "Required" : "Optional")
        schema :   \(self.schemaOrContent)
        """
    }
}

class ExpectationFactory {
     
    typealias StatusCode = KernelSwiftCommon.Networking.HTTP.ResponseStatus
    
    /// Shared instance.
    static let shared = ExpectationFactory()
    
    // TODO these assume json for now, but maybe testing other content types could be useful
    // so may need to revisit coding those
    
    func expectation(for endPoint: ResolvedEndpoint, verbose: Bool) -> TestPlan.Expectation {
        let summary = endPoint.endpointSummary ?? ""
        
        if verbose {
            Messager.log(sys: .expectationFactory, s: "Creating expectation for " +  "\(summary)")
        }
        
        Messager.log(sys: .expectationFactory, s:"Checking all status codes against ")
        for code in StatusCode.allCases {

            let apiCode = OpenAPI.Response.StatusCode(integerLiteral: code.rawValue)
            
            guard let means = endPoint.requestBody?.content[.json]?.example else {
                if verbose {
                    Messager.log(sys: .expectationFactory, s:"No means to acquire an expected response. This is an unstable state so we cannot rely upon any plan for" + "\(endPoint.endpointSummary!)")
                }
                return .nothingnohow
            }
            
            guard let meansSchema = endPoint.requestBody?.content[.json]?.schema else {
                if verbose {
                    Messager.log(sys: .expectationFactory, s:"No schema to validate an expected response against. This is an unstable state so we cannot rely upon any plan for" + "\(endPoint.endpointSummary!)")
                }
                return .nothingnohow
            }
            
            guard let encodedMeans = try? JSONEncoder().encode(means) else {
                Messager.log(sys: .expectationFactory, s: "encoding nothing means")
                return .nothingnohow
            }
            
            guard let expectedResponse = endPoint.responses[apiCode]?.content[.json]?.example else {
                if verbose {
                    Messager.log(sys: .expectationFactory, s: "no examples found" + " for " + "\(apiCode)" + " responses  - continuing to check respoinses .")
                }
                continue
            }
            
            guard let expectedResponseSchema = endPoint.responses[apiCode]?.content[.json]?.schema else {
                if verbose {
                    Messager.log(sys: .expectationFactory, s: "no schema found  for " + "\(apiCode)" + " responses  - continuing to check respoinses .")
                }
                continue
            }
            
            guard let encodedJsonResponse = try? JSONEncoder().encode(expectedResponse) else {
                Messager.log(sys: .expectationFactory, s: "Can't encode expectedResponse")
                return .nothingnohow
            }
            
            if verbose {
                Messager.log(sys: .expectationFactory, s: "Discovered example response " + "\(expectedResponse)"  +  " for " + " \(summary)")
                
                Messager.log(sys: .expectationFactory, s: "encoding assumed JSON body data...")
                Messager.log(sys: .expectationFactory, s: "Identified means " + "\t" + "\(means)")
                Messager.log(sys: .expectationFactory, s:"to expect" + "\t" + "\(expectedResponse)")
            }
            Messager.log(sys: .expectationFactory, s: "means is \(means)")
            return .init(expectationSchema: expectedResponseSchema,
                         expectedData: encodedJsonResponse ,
                         meansSchema: meansSchema,
                         means: encodedMeans,
                         timestamp: Date())
        }
        
        Messager.log(sys: .expectationFactory, s: "--- fall through expecting nothing no-how.")
        return .nothingnohow

    }
}


