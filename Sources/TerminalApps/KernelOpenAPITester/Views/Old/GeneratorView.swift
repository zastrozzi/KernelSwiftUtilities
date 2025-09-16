//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import Foundation
import KernelSwiftTerminal
import OpenAPIKit30

struct GeneratorView: View {
    
    @ObservedObject var model: TesterModel
    @ObservedObject var genModel: GeneratorModel
    
    var input: some View {
        VStack {
            Text("Filters")
            HStack {
                Text("\(model.generatorModel.filters.count) active filters.")
                Button("...") {
                    
                }
                .foregroundColor(.white)
            }
        }
    }
    
    var generateButton: some View {
        if model.decodeModel?.decodedDocument != nil {
            
            Button("Generate Plans") {
                if let doc = model.decodeModel?.decodedDocument {
                    
                    // generator model knows what was generated, doesnt care whats passed.
                    model.generatorModel.generatedPlans =  TestPlanFactory.testPlans(for: doc,
                                                                                     filters: model.generatorModel.filters)
                    // tester gets what genny gens.
                    // model in the sky for now, trust it
                    Tester.shared.presentedPlans = model.generatorModel.generatedPlans
                }else {
                    Messager.log(sys: .tester, s: "Generate called without a document. CHeck ingress.")
                }
            }
            .foregroundColor(.white)
        }else {
            Button("Generate Plans") {
                if let doc = model.decodeModel?.decodedDocument {
                    
                    // generator model knows what was generated, doesnt care whats passed.
                    model.generatorModel.generatedPlans =  TestPlanFactory.testPlans(for: doc,
                                                                                     filters: model.generatorModel.filters)
                    // tester gets what genny gens.
                    // model in the sky for now, trust it
                    Tester.shared.presentedPlans = model.generatorModel.generatedPlans
                }
                else {
                    Messager.log(sys: .tester, s: "Generate called without a document. CHeck ingress.")
                }
            }
            .foregroundColor(.red)
        }
    }
    
    var output: some View {
        VStack {
                HStack {
                    Text("Generated Plans").bold()
                    Button("Clear") {
                        model.generatorModel.generatedPlans.removeAll()
                    }
                }

            Text("----------------------------")
            Text("\(model.generatorModel.generatedPlans.count) plans generated.")
            ScrollView {
                ForEach(model.generatorModel.generatedPlans, id:\.id) { plan in
                    Button("\(plan.endpoint.endpointSummary ?? "no summary")") {
                        
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Generator").bold()
            Text("------------------")
            input
            generateButton
            output
            Spacer()
        }
    }
}
