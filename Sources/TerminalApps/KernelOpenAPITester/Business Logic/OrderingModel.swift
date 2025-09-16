//
//  Model.swift
//
//
//  Created by Jimmy Hough Jr on 10/31/23.
//

import Foundation
import OpenAPIKit30


/// Allows for an arbitrary order of plan execution
class OrderingModel: ObservableObject {
    
    /// Allows for arbitrary order of identified plan execution
    struct PlanIndex: Identifiable {
        let idx: Int
        let id: UUID
    }
    
    // Bistable
    @Published var asPresented = [PlanIndex]()
    @Published var asOrdered = [PlanIndex]()
    
    // Simplest ordering.
    func orderAsPresented() {
        asOrdered = asPresented
        //        asOrdered.removeAll() // reordering
        //        for (idx, plan) in asPresented.enumerated() {
        //            asOrdered.append(PlanIndex(idx: idx, id: plan.id))
        //        }
        Messager.log(sys: .tester, s: "ordered plans implicitly.")
    }
    
    func order(plan from: Int, to: Int) {
        if let source = asOrdered.first(where: { p in
            p.idx == from
        }) {
            asOrdered.remove(at: source.idx)
            asOrdered.insert(source, at: to )
        }
    }
}
