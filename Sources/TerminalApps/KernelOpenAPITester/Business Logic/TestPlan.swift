//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/17/23.
//

import Foundation
import OpenAPIKit30

public protocol MutablyResultable {
    mutating func resulting(with result: TestPlan.Result, via response: HTTPURLResponse)
}

public protocol Resultable {
    func resulting(with result: TestPlan.Result, via response: HTTPURLResponse) -> TestPlan
}

public struct TestPlan: Identifiable, CustomStringConvertible {
    // tester maps plan ids to processing status je pense
    public enum ProcessingStatus {
        case generated
        case presented
        case executed
    }
    
    public var description: String {
                
        return """
        TestPlan {
            id : \(id),
            pass : \(passed ? "✅" : "❌"),
            route : \(route.path.rawValue),
            endpoint : \(endpoint.method)  \(endpoint.path.rawValue) \(endpoint.endpointSummary ?? "" ),
            expectation : { means : \(expectation.means.count) bytes , criteria : \(expectation.criteria),
            request : \(String(describing: request)),
            result : \(String(describing: result)),
            response : \(String(describing: response))
        }
        """
    }
    
    /// Uniquely idenitfies this test plan in time and space. ** do not use in a blue phone box, or a near DeLorean near 88 mph...
    public var id: UUID
    
    /// Encapsulates what we expect about the data in the response.
    public struct Expectation {
        
        /// Data the is expected from the testSubject in response to the given data.
        var expectationSchema: DereferencedJSONSchema?
        var expectedData: Data
        var meansSchema: DereferencedJSONSchema?
        var means: Data
        var criteria: [Result.Check.Criterion] = [.noPreviousErrors ]
        
        /// When this expectationn was set.
        var timestamp: Date
        static var nothingnohow: Expectation {
            .init(expectedData: Data(),
                  means:Data(),
                  timestamp: Date())
        }
    }
    
    /// Encapsulates what we received from enpoint of the test plan.
    public struct Result {

        // Captures the act of verification of a result in contrast to collecting it.
        public struct Check {
            
            public enum Criterion {
                /// The final call is made by prior logic. This case is ued when no additional checks are required to pass.
                case noPreviousErrors
                /// For symmtery but can be used to test consequnces.
                case alwaysFail
                /// The final call is made by comparing the epxected data to the response data without regard to type, but binary equality.
                case blob2blobEquality
                /// The final call is made by only the requeset response code, ignoring other expectations.
                case returnsStatus(Int)
            }
            
            // Specifies how we determine the value of a Result.Cehck .
            let criterion: Criterion
            
            // The schema the criterion applies to.
            let expectedSchema: DereferencedJSONSchema
            
            // When was the Result checked.
            let timestamp: Date
        }
        
        /// Data that is received from the test subject.
        var data: Data
        
        /// HTTPStatus of the reponse this result came from.
        var status: Int
        
        /// When this result was received.
        var timestamp: Date

        /// Allows a Result to Check itself (before we wreck itself) .
        public func check(by: Result.Check.Criterion = .noPreviousErrors) -> Bool {
            switch by {
            
            /// The final call is made by comparing the epxected data to the response data without regard to type, but binary equality.
            case .blob2blobEquality:
                return false
            /// The final call is made by only the requeset response code, ignoring other expectations.
            case .returnsStatus(_):
                return true
            /// The final call is made by prior logic. This case is ued when no additional checks are required to pass.
            case .noPreviousErrors:
                return true
            /// For symmtery but can be used to test consequnces.
            case .alwaysFail:
                return false
            }
        }
    }
    
    /// Returns an array of 'deferenced params' that are required for the test plan from the endpoint of the testplan.
    var requiredParams: [DereferencedParameter] {
        endpoint.parameters.filter { p in
            p.required
        }
    }
    
    /// Returns an array of 'deferenced params' from the endpoint of the testplan.
    var optionalParams: [DereferencedParameter] {
        endpoint.parameters.filter { p in
            !p.required
        }
    }
    
    /// Where are we expecting?
    public var expectation: Expectation
    
    /// Where are we expecting from?
    public var route: ResolvedRoute
    
    /// No, exactly where and how are we expecting from?
    public var endpoint: ResolvedEndpoint
    
    /// How do we get it?
    var request: URLRequest?
    
    /// What did we get?
    public var result: Result?
    
    /// How did we get it?
    public var response: HTTPURLResponse?
    
    /// Record of the last result of 'passOrFail' .
    var passed: Bool = false
    
    /// DId we like what we got?
    func passOrFail() -> Bool {
    
        guard let resultData = result?.data else {
            print("no result!")
            return false
        }
        if let _ = try? JSONDecoder().decode(TesterNetworking.VaporError.self,
                                                        from: resultData) {
            return false
        }
        
        if
            let decodedResultJson = try? JSONDecoder().decode(AnyCodable.self,
                                                              from: resultData) {
            if let schema = expectation.expectationSchema {
                let validator: ExpectationResponseValidator = .init(schema: schema,
                                                                    response: decodedResultJson,
                                                                    summary: endpoint.endpointSummary ?? "")
                let valid = validator.validate()
                
                let passesCriteria = result!.check()
                Messager.log(sys: .validation, s: "passesCrit ? \(passesCriteria) is valid ? \(valid)")
                return valid && passesCriteria
            }else {
                Messager.log(sys: .validation, s: "no expected schema")
                return expectation == .nothingnohow
            }

        }else {
            Messager.log(sys: .validation, s: "Decoding failed !")
            Messager.log(sys: .validation, s: "\(String(data: resultData, encoding: .utf8) ?? "doesnt look like utf8" )")
            return false
        }
    }
}

extension TestPlan: Resultable {
    
    /// Returns a new TestPlan identical to self, augmented with the provided result and response.
    public func resulting(with result:TestPlan.Result,
                          via response: HTTPURLResponse) -> TestPlan {
        return TestPlan(id: self.id,
                        expectation: self.expectation,
                        route: self.route,
                        endpoint: self.endpoint,
                        request: self.request,
                        result: result,
                        response: response)
    }
}

extension TestPlan {
    
    /// The URL to request from to facillitate plan execution.
    public var url: URL {
        var server: OpenAPI.Server
        server = route.endpoints.first?.servers.first ?? OpenAPI.Server(url: URL(string:"localhost")!)
        
        let url = URL(string:"\(server.urlTemplate.rawValue)\(route.path.rawValue)")!
        return url
    }
    
    /// Spawns a new URLRequest with updated enpoint based values to facillitate plan execution.
    func newRequest() -> URLRequest {
        var r = URLRequest(url: url)
        r.addValue("application/json",
                   forHTTPHeaderField: "Content-Type")
        r.httpMethod = endpoint.method.rawValue
        r.httpBody = expectation.means
        return r
    }
}
