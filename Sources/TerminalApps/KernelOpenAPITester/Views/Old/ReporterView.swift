//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import Foundation
import KernelSwiftTerminal

struct ReportView: View {
    
    var body: some View {
        VStack {
            Text("Report \(Date().formatted(date: .complete, time: .complete))").bold()
            Text("---------------------------")

            Text("\(Tester.shared.executedPlans.count) / \(Tester.shared.presentedPlans.count) plans executed.")
            ScrollView {
                ForEach(Tester.shared.executedPlans) { ExecutedPlanView(plan: $0)}
            }
            Spacer()
        }
    }
}

struct StatusCodeView: View {
    
    var status: Int
    
    var body: some View {
        switch status {
        case 200...299:
            Text("\(status)").foregroundColor(.green).bold()
        case 400...499:
            Text("\(status)").foregroundColor(.yellow).bold()
        case 500...599:
            Text("\(status)").foregroundColor(.red).bold()
        default:
            Text("\(status)").foregroundColor(.white).bold()
        }
    }
}

struct ExecutedPlanView: View {
    let plan:TestPlan
    
    var body: some View {
        
        HStack(spacing: 1) {
            Button("...") {
                
            }
            if plan.passed {
                Text("Pass ").foregroundColor(.green)
            }else {
                Text("Fail ").foregroundColor(.red)
            }
            
            StatusCodeView(status: plan.result?.status ?? -1)
            
            Text("\(plan.endpoint.endpointSummary ?? "???")")
        }
    
        /**
         /// Logs the results of executed test plans that were presented.
         func reportExecutedPlans() {
         Log.pr(sys:.tester, s: "====================================".cyan)
         
         Log.pr(sys:.tester, s: "Report \(Date().formatted())".cyan)
         Log.pr(sys:.tester, s: "Executed " + "\(executedPlans.count)".green + " of " + "\(presentedPlans.count)" + "\(wasHardMode ? " HARD MODE".red : "")")
         Log.pr(sys: .tester, s: bar(executedPlans.count, of: presentedPlans.count))
         
         let passing = executedPlans.filter { $0.passed }
         let failing = executedPlans.filter { !$0.passed }
         
         let failingCount = executedPlans.count - passing.count
         let passingCount = passing.count
         
         
         if failingCount == 0 {
         
         Log.pr(sys:.tester, s: TestDocument().happyDays())
         }
         else {
         Log.pr(sys:.tester, s: "\(passingCount)".green + " of \(passingCount + failingCount) passed!")
         Log.pr(sys:.tester, s: "\(failingCount)".red + " of \(passingCount + failingCount) failed.")
         Log.pr(sys:.tester, s: bar(passingCount, of: failingCount + passingCount))
         
         for plan in failing {
         if let summary = plan.endpoint.endpointSummary {
         Log.pr(sys:.tester, s: " ❌ " + "\(plan.id.uuidString) ".blue + "\(String(describing: summary))".hex("FF0000"))
         
         }
         }
         
         
         for plan in passing {
         
         if let summary = plan.endpoint.endpointSummary {
         Log.pr(sys:.tester, s: " ✅ " + "\(plan.id.uuidString) ".blue  + " \(String(describing: summary))".hex("00FF00" ))
         }
         }
         }
         Log.pr(sys: .tester, s: " Responses".cyan)
         
         let notFounds = failing.filter { plan in
         (400..<499).contains(plan.response!.statusCode)
         }
         
         Log.pr(sys:.tester, s: "400s : " + "\(notFounds.count)".yellow + bar(notFounds.count, of: failingCount + passingCount))
         
         let serverErrors = failing.filter { plan in
         (500..<599).contains(plan.response!.statusCode)
         }
         
         Log.pr(sys:.tester, s:  "500s : " + "\(serverErrors.count)".red + " " + bar(serverErrors.count, of: failingCount + passingCount))
         
         let passedOks = passing.filter { plan in
         return (200..<299).contains(plan.response!.statusCode)
         }
         
         let failedOks = failing.filter({ plan in
         return (200..<299).contains(plan.response!.statusCode)
         })
         
         let oks = failedOks.count + passedOks.count
         
         Log.pr(sys:.tester, s: "200s : " + "\(oks)".green + bar(oks, of: failingCount + passingCount))
         Log.pr(sys:.tester, s:  "====================================".cyan)
         }
        
         
         */
    }
}

struct ExecutedPlanDetailsView: View {
    
    var plan: TestPlan
    
    var body: some View {
        VStack {
            HStack {
                plan.passed ? 
                Text("Pass ").foregroundColor(.green) :
                Text("Fail ").foregroundColor(.red)
                
                StatusCodeView(status: plan.result?.status ?? -1)
                Text("\(plan.endpoint.endpointSummary ?? "???")")
            }
        }
    }
}
