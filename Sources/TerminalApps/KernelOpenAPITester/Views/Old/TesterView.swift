//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import Foundation
import KernelSwiftTerminal

struct OrderedPlanView: View {
    
    var orderingModel: OrderingModel
    
    @State var isMovingPlan = false
    @State var destination = ""
    
    let planIndex: OrderingModel.PlanIndex
    
    var body: some View {
        let plan = Tester.shared.presentedPlans.filter { p in
            p.id == planIndex.id
        }.first
        
        HStack {
            Button("mv ...") {
                $isMovingPlan.wrappedValue = true
            }
           
            if isMovingPlan {
                HStack {
                    Text("Destination : \(destination)")
//                    TextField { s in
//                        if let i = Int(s, radix: 10) {
//                            finishMove(to: i)
//                        }else {
//                            destination = "\(s) not an Int it seems."
//                        }
//                    }
                }
            }else {
                Text("\(planIndex.idx)").foregroundColor(.yellow)
                Text("\(planIndex.id)")
                Text("\(plan?.endpoint.endpointSummary ?? "???")")
                    .foregroundColor(.green)
                    .bold()
            }
        }
    }
    
    private mutating func finishMove(to destination: Int) {
        orderingModel.order(plan: planIndex.idx, to: destination)
        isMovingPlan = false
    }
}

struct OrderedPlansView: View {
    @ObservedObject var testerModel: TesterModel
    @ObservedObject var orderingModel: OrderingModel
    
    var body: some View {
        VStack {
            Text("Order").bold()
            Text("--------------------")
            Button("Initialize Order") {
                orderingModel.asPresented = 
                Tester.shared.presentedPlans.enumerated().map {
                    OrderingModel.PlanIndex(idx: $0, id: $1.id)
                }
                orderingModel.orderAsPresented()
            }
            .foregroundColor(.white)
            
            ScrollView {
                ForEach(orderingModel.asOrdered) {
                    OrderedPlanView(orderingModel: orderingModel,
                                    planIndex: $0)
                }
            }
        }
    }
}

struct TesterView: View {
    
    /// Toutes etes pour le Tester
    @ObservedObject var model: TesterModel
    @ObservedObject var orderingModel: OrderingModel
    
    var clearButton: some View {
        Button("Reject All") {
            Tester.shared.presentedPlans.removeAll()
        }
        .foregroundColor(.white)
    }
    
    var executeButton: some View {
        if Tester.shared.presentedPlans.isEmpty {
            Button("Execute All") {
               
            }
            .foregroundColor(.white)
        }else {
            Button("Execute All") {
                DispatchQueue.main.async {
                    Tester.shared.executePlans(hardMode: false)
                }
            }
            .foregroundColor(.white)
        }
    }
        
    
    var body: some View {
        VStack {
            Text("Test Executor").bold()
            Text("-------------------")
            Text("\(Tester.shared.presentedPlans.count) plans presented.")
            if !Tester.shared.presentedPlans.isEmpty {
                OrderedPlansView(testerModel: model, 
                                 orderingModel: orderingModel)
                executeButton
            }else {
                Text("Nothing presented. Check the Generator.")
                executeButton

            }
            
            Spacer()
        }
    }
}
