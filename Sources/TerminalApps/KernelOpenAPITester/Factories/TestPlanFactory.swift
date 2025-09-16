//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/17/23.
//

import Foundation
import OpenAPIKit30
import KernelSwiftCommon
/// Takes an OpenAPI Document and returns an array of test plans
/// based on the information provided in the document.
class TestPlanFactory {
    static let logSysLabel = "TestPlanFactory > "
    
    static private func processed(routes: [ResolvedRoute],
                                  with filters: [Tester.Filter]) -> [ResolvedRoute] {
        filters.reduce(routes) { partialResult, filter in
            filter.process(partialResult)
        }
    }
    
    ///  Returns all the test plans that can be generated from the decoded document.
    ///    An exampled route is one that provides a requestBody
    ///        and additionally an example response feature wip
    static func testPlans(for decodedDocument: OpenAPI.Document,
                          verbose: Bool = false,
                          filters: [Tester.Filter]) -> [TestPlan] {
        
        var plans = [TestPlan]()

        do {
            
            let resolvedDocument = try decodedDocument.locallyDereferenced().resolved()
            
            // filter resolved document routes for the stated routes.
            let filteredRoutes =  processed(routes: resolvedDocument.routes,
                                            with: filters)
            Messager.log(sys:.testplanFactory, s: "Generating test plans for \(filteredRoutes.count) routes")

            for (idx, route) in filteredRoutes.enumerated() {
                Messager.log(sys:.expectationFactory, s:  " Route #\(idx+1)")

                plans.append(contentsOf: testPlans(for: route, filters: filters))
            }
           
        }
        catch {
            print(logSysLabel + "\(error)")
        }
        
        return plans
    }
    
    // Returns all the test plans that can be generated from the resolved route.
    static func testPlans(for route: ResolvedRoute,
                          verbose: Bool = false,
                          filters: [Tester.Filter]) -> [TestPlan] {
        
        var plans = [TestPlan]()
        
        for (_, ep) in route.endpoints.enumerated() {
            if verbose {
//                Log.pr(sys:.expectationFactory, s: "Endpoint #\(epidx+1) of \(route.endpoints.count) - ".bold + "\(ep.method.rawValue)".hex(.barple) +  " \(route.path.rawValue)".green)
//                Log.pr(sys:.expectationFactory, s: "Endpoint Summary: \(ep.endpointSummary?.green ?? " NO SUMMARY".yellow)")
//                Log.pr(sys:.expectationFactory, s: "Param count: \(ep.parameters.count)")
                
                for (idx, p) in ep.parameters.enumerated() {
                    Messager.log(sys:.expectationFactory, s:  "Param #\(idx+1) of \(ep.parameters.count)")
                    Messager.log(sys:.expectationFactory, s: " \(p)")
                }
            }
            
            let plan = TestPlan(id: UUID() ,
                                expectation: ExpectationFactory.shared.expectation(for: ep, verbose: true),
                                route: route,
                                endpoint: ep,
                                request: nil,
                                result: nil,
                                response: nil)
            plans.append(plan)
        }
        
//        print(logSysLabel + "Created ".cyan + "\(plans.count)".yellow + " plans. ".cyan)
        return plans
    }
}
