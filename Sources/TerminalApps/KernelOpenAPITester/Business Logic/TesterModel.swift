//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/31/23.
//

import Foundation
import OpenAPIKit30

class TesterModel: ObservableObject {
    
    enum TesterState {
        case acquiringURL
        case acquiringYamlData
        case planning
        case executing
        case validatingResults
        case idle
    }

    struct IngressModel {
        var url: URL? = nil
        var yamlData: Data? = nil
        var decodedDocument: OpenAPI.Document? = nil
        var filters: [Tester.Filter] = [Tester.Filter]()
    }
    
    @Published var currentState: TesterState = .idle
    
    @Published var documentIngressModel: DocumentIngressModel? = nil
    @Published var ingressModel = IngressModel()
    @Published var decodeModel: DocumentDecodeModel? = nil
    @Published var generatorModel = GeneratorModel()
    @Published var orderingModel = OrderingModel()
    
    @Published var plans: [TestPlan] = [TestPlan]()
    @Published var plansStatuses = [UUID : TestPlan.ProcessingStatus]()
}

