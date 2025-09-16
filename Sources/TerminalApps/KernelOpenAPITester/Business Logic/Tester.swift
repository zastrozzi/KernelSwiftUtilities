//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/17/23.
//

import Foundation
import OpenAPIKit30

/// Executes and reports on TestPlans from the TestPlanFactory.
class Tester {
    /// Shared Tester insance.
    static let shared = Tester()
    var executionPaused = false
    
    /// Plans to execute.
    var presentedPlans = [TestPlan]()
    
    
    // A place to impose an order on a collection of plans.
    
    /// Plans that were executed, augmented with their results.
    var executedPlans = [TestPlan]()
    
    var wasHardMode: Bool = false
    
    // Orders presented plans sequentially as they were presented.
    // executePlans will consult this order to execute plans in rather than the presntaion order.
    
  
    
    /// Executes the presented plans. This is done by executnig them sequentially until done.
    func executePlans(hardMode: Bool)  {
        Messager.log(sys:.tester, s: " 🚀 Executing \(presentedPlans.count) Integration Test Plans ...")
        /// this will be sus actually
        
        wasHardMode = hardMode
        
        for (idx, planID) in presentedPlans.enumerated() {
            Messager.log(sys: .tester, s: "\(idx) \(planID)")
        }
        for (idx, plan) in presentedPlans.enumerated()
                                         .filter({
            if hardMode {
                Messager.log(sys: .tester, s: " hard mode")
                return $0.element.expectation != TestPlan.Expectation.nothingnohow
            }else {
                return true
            }
        }) {
            Messager.log(sys:.tester, s: " 🔁 Executing plan " + "\(String(describing: plan.endpoint.endpointSummary!))" + "\(idx+1)" +  " of " + " \(presentedPlans.count)")
            executedPlans.append(exec(plan: plan))
        }
    }

    /// Executes a single test plan. Returns a TestPlan that has been ran.
    func exec(plan: TestPlan)  -> TestPlan {
                
        var runningPlan = plan
            
        do {
            // we make all the requests sequentially and collect the responses
            let responses = TesterNetworking.shared.from(url: runningPlan.url,
                                                         with: runningPlan.newRequest(),
                                                         for: runningPlan.id)
            runningPlan.request = responses.2
            // transition state of the plan
            var ranPlan =  runningPlan.resulting(with: .init(data: responses.0,
                                                             status: responses.1?.statusCode ?? -1,
                                                             timestamp: Date()),
                                                 via: responses.1 ?? HTTPURLResponse())
            
            Messager.log(sys:.tester, s: "Plan executed. Validating Results...")
            ranPlan.passed = ranPlan.passOrFail()
            
            if ranPlan.passed {
                Messager.log(sys:.tester, s: "🥂🎉 " + "\(plan.endpoint.endpointSummary!)" + " passed")
            }else {
                Messager.log(sys:.tester, s: "💣💥 " + "\(plan.endpoint.endpointSummary!)" + " failed" )
                Messager.log(sys:.tester, s: "\(ranPlan)")
            }
            return ranPlan
        }
        
    }
    
    //TODO make this into a swift TUI view
    
    /// Logs the results of executed test plans that were presented.
    func reportExecutedPlans() {
        Messager.log(sys:.tester, s: "====================================")

        Messager.log(sys:.tester, s: "Report \(Date().formatted())")
        Messager.log(sys:.tester, s: "Executed " + "\(executedPlans.count)" + " of " + "\(presentedPlans.count)" + "\(wasHardMode ? " HARD MODE" : "")")
        Messager.log(sys: .tester, s: TestDocument.bar(executedPlans.count, of: presentedPlans.count))

        let passing = executedPlans.filter { $0.passed }
        let failing = executedPlans.filter { !$0.passed }
 
        let failingCount = executedPlans.count - passing.count
        let passingCount = passing.count
        
        
        if failingCount == 0 {
          
            Messager.log(sys:.tester, s: TestDocument.happyDays())
        }
        else {
            Messager.log(sys:.tester, s: "\(passingCount)" + " of \(passingCount + failingCount) passed!")
            Messager.log(sys:.tester, s: "\(failingCount)" + " of \(passingCount + failingCount) failed.")
            Messager.log(sys:.tester, s: TestDocument.bar(passingCount, of: failingCount + passingCount))

            for plan in failing {
                if let summary = plan.endpoint.endpointSummary {
                    Messager.log(sys:.tester, s: " ❌ " + "\(plan.id.uuidString) " + "\(String(describing: summary))")
                    
                }
            }
            
            
            for plan in passing {
                
                if let summary = plan.endpoint.endpointSummary {
                    Messager.log(sys:.tester, s: " ✅ " + "\(plan.id.uuidString) "  + " \(String(describing: summary))")
                }
            }
        }
        Messager.log(sys: .tester, s: " Responses")
        
        let notFounds = failing.filter { plan in
            (400..<499).contains(plan.response!.statusCode)
        }
        
        Messager.log(sys:.tester, s: "400s : " + "\(notFounds.count)" + TestDocument.bar(notFounds.count, of: failingCount + passingCount))
        
        let serverErrors = failing.filter { plan in
            (500..<599).contains(plan.response!.statusCode)
        }
        
        Messager.log(sys:.tester, s:  "500s : " + "\(serverErrors.count)" + " " + TestDocument.bar(serverErrors.count, of: failingCount + passingCount))
        
        let passedOks = passing.filter { plan in
            return (200..<299).contains(plan.response!.statusCode)
        }
        
        let failedOks = failing.filter({ plan in
            return (200..<299).contains(plan.response!.statusCode)
        })
        
        let oks = failedOks.count + passedOks.count
        
        Messager.log(sys:.tester, s: "200s : " + "\(oks)" + TestDocument.bar(oks, of: failingCount + passingCount))
        Messager.log(sys:.tester, s:  "====================================")
    }
}
