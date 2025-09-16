//
//  Generator.swift
//  
//
//  Created by Jimmy Hough Jr on 11/7/23.
//


import Foundation
import KernelSwiftTerminal
import OpenAPIKit30

// Defined here, held by the TesterModel and distributed to concerns.
class GeneratorModel: ObservableObject {
    @Published var document: OpenAPI.Document? = nil
    @Published var filters: [Tester.Filter] = [Tester.Filter]()
    @Published var generatedPlans: [TestPlan] = [TestPlan]()
}
