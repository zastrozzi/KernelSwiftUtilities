//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import KernelSwiftTerminal
import KernelSwiftCommon

struct RootView: View {
    
    typealias Spacer = KernelSwiftTerminal.Views.Spacer
    typealias VStack = KernelSwiftTerminal.Views.VStack
    typealias HStack = KernelSwiftTerminal.Views.HStack
    typealias ForEach = KernelSwiftTerminal.Views.ForEach
    typealias Text = KernelSwiftTerminal.Views.Text
    typealias Button = KernelSwiftTerminal.Views.Button
    typealias ScrollView = KernelSwiftTerminal.Views.ScrollView
    typealias Color = KernelSwiftTerminal.Style.Color
    typealias ObservedObject = KernelSwiftTerminal.Model.ObservedObject
    typealias ViewBuilder = KernelSwiftTerminal.ViewGraph.ViewBuilder

    @ObservedObject var model = NavMenuModel()
    @ObservedObject var testerModel:TesterModel
    
    @ViewBuilder
    func content() -> some View {
        if let screen = model.selectedScreen {
            switch screen {
                
            case .ingress:
                DocumentIngressView(ingress: testerModel.documentIngressModel!)
                VStack {
                    Text("Go to Decode.")
                }
            case .decode:
                if let mod = testerModel.decodeModel {
                    DocumentDeocdeView(model: mod)
                }else {
                    VStack {Text("Check ingress");Spacer() }
                }
            case .generate:
                GeneratorView(model: testerModel, genModel: testerModel.generatorModel)
            case .run:
                TesterView(model: testerModel, orderingModel: testerModel.orderingModel)
            case .report:
                ReportView()
            case .logs:
                MessagesView()
            }
        }else {
            VStack{Text("no screen");Spacer()}
        }
    }
    
    var body: some View {
        
        VStack {
            content()
            NavMenuView(model: model, tester: testerModel)
        }
    }
}
