//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/08/2023.
//

import Foundation
import SwiftUI
import OSLog
import KernelSwiftCommon

@available(iOS 17.0, macOS 14.0, *)
extension KernelDI.Injector {
    public var interactionFlowService: InteractionFlowService {
        get { self[InteractionFlowService.Token.self] }
        set { self[InteractionFlowService.Token.self] = newValue }
    }
}

@available(iOS 17.0, macOS 14.0, *)
@Observable
public class InteractionFlowService: KernelDI.Injectable, @unchecked Sendable {
    public var allFlowElements: [InteractionFlowElement] = []
    var activeFlowElementIds: [any InteractionFlowElementIdentifiable] = []
    var skippedFlowElementIds: [any InteractionFlowElementIdentifiable] = []
    var completedFlowElementIds: [any InteractionFlowElementIdentifiable] = []
    var allFlowElementIds: [any InteractionFlowElementIdentifiable] = []
    var skippableFlowElementIds: [any InteractionFlowElementIdentifiable] = []
    
    var currentFlowElementId: (any InteractionFlowElementIdentifiable)? {
        get {
            if activeFlowElementIds.isEmpty { return nil }
            
            return allFlowElements.first { element in
                element.inputIsNil && activeFlowElementIds.contains(element.id)
            }?.id
        }
        set {}
    }
    
    var activeFlowElements: [InteractionFlowElement] {
        get {
            allFlowElements.filter { el in
                activeFlowElementIds.contains(el.id)
            }
        }
        set {}
    }
    
    var currentFlowElementIsSkippable: Bool {
        get {
            guard let currentFlowElementId else { return false }
            return skippableFlowElementIds.contains(currentFlowElementId)
        }
        set {}
    }
    
    var latestSkippedElement: InteractionFlowElement? {
        get {
            guard let latestSkippedElementId = skippedFlowElementIds.last else { return nil }
            return allFlowElements.first(where: { $0.id == latestSkippedElementId })
        }
        set {}
    }
    
    var currentFlowElement: InteractionFlowElement? {
        get {
            guard let currentFlowElementId else { return nil }
            return allFlowElements.first(where: { $0.id == currentFlowElementId })
        }
        set {}
    }
    
    required public init() {}
    
    public var flowIsLoaded: Bool = false
    
    
    public func fireLoadInteractionFlow<Identifier: InteractionFlowElementIdentifiable>(_ flow: [InteractionFlowElementType<Identifier>]) async throws {
        InteractionFlows.logger.debug("loading flow")
        if flowIsLoaded { fireUnloadInteractionFlow() }
        try await KernelDI.inject(\.interactionFlowService).loadInteractionFlow(flow)
//        Task {
            
            
//        }
    }
    
    public func loadInteractionFlow<Identifier: InteractionFlowElementIdentifiable>(_ flow: [InteractionFlowElementType<Identifier>]) async throws {
        
        try await Task.sleep(for: .milliseconds(1000))
        flowIsLoaded = true
        guard !flow.isEmpty else { return }
        for element in flow {
            allFlowElements.append(
                element.toElement()
            )
        }
        allFlowElementIds = flow.map { $0.id }
        skippableFlowElementIds = flow.compactMap { if $0.isSkippable { return $0.id } else { return nil } }
        activeFlowElementIds = [flow.first!.id]
//        withAnimation(.smooth) {
//            
//        }
        InteractionFlows.logger.debug("loaded flow")
    }

    public func fireUnloadInteractionFlow() {
        InteractionFlows.logger.debug("unloading flow")
        Task {
            try await KernelDI.inject(\.interactionFlowService).unloadInteractionFlow()
        }
        
    }
    
    public func unloadInteractionFlow() async throws {
        try await Task.sleep(for: .milliseconds(1000))
        guard flowIsLoaded else { return }
        flowIsLoaded = false
        allFlowElements.removeAll()
        allFlowElementIds.removeAll()
        activeFlowElementIds.removeAll()
        skippedFlowElementIds.removeAll()
        skippableFlowElementIds.removeAll()
//        withAnimation(.smooth) {
            
//        }
        InteractionFlows.logger.debug("unloaded flow")
    }
    
    public func progressFlow<Identifier: InteractionFlowElementIdentifiable>(_ flowElementId: Identifier?) {
        if let flowElementId {
            if !activeFlowElementIds.contains(flowElementId) {
                activeFlowElementIds.append(flowElementId)
            }
        }
    }
    
    public func skipCurrentElement() {
        guard let currentFlowElementId, let currentFlowElement = allFlowElements.first(where: { $0.id.equals(currentFlowElementId) }) else { return }
        let next = currentFlowElement.getNextIdentifier(skipping: true)
        currentFlowElement.resetInput()
        progressFlow(next)
        if !skippedFlowElementIds.contains(currentFlowElementId) {
            skippedFlowElementIds.append(currentFlowElementId)
        }
    }
    
    public func regressFlow(to flowElementId: any InteractionFlowElementIdentifiable) {
        guard let activeRegressIndex = activeFlowElementIds.firstIndex(where: { $0 == flowElementId }) else { return }
        activeFlowElementIds.removeLast(activeFlowElementIds.endIndex - activeRegressIndex - 1)
        allFlowElements.forEach { element in
            if !activeFlowElementIds.contains(element.id) {
                element.resetInput()
                skippedFlowElementIds.removeAll(where: { $0 == element.id })
            }
        }
        guard let skipRegressIndex = skippedFlowElementIds.firstIndex(where: { $0 == flowElementId }) else { return }
        skippedFlowElementIds.removeLast(skippedFlowElementIds.endIndex - skipRegressIndex)
//        skippedFlowElementIds.removeAll(where: { $0 == flowElementId.rawValue })
    }
    
    
    
    public func getOutputValue<Identifier: InteractionFlowElementIdentifiable, OutputType>(_ identifier: Identifier, outputType: InteractionFlowOutput) throws -> OutputType {
        guard !allFlowElementIds.isEmpty else { throw InteractionFlowError.noElements }
        guard allFlowElementIds.contains(identifier) else { throw InteractionFlowError.identifierNotFound }
        guard let inputType = allFlowElements.first(where: { $0.id == identifier }) else { throw InteractionFlowError.identifierNotFound }
        switch outputType {
        case .binaryChoice:
            guard let binaryChoice = inputType.binaryInput as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return binaryChoice
        case .currencyAmount:
            guard let currencyAmount = inputType.currencyInputAmount as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return currencyAmount
        case .currencyIsEditing:
            guard let currencyIsEditing = inputType.currencyInputIsEditing as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return currencyIsEditing
        case .currencySelected:
            guard let currencySelected = inputType.currencyInputCurrency as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return currencySelected
        case .dateIsEditing:
            guard let dateIsEditing = inputType.dateInputIsEditing as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return dateIsEditing
        case .dateSelected:
            guard let dateSelected = inputType.dateInputSelectedDate as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return dateSelected
        case .selectedChipOption:
            guard let selectedChipOption = inputType.iconChipInput as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return selectedChipOption
        case .textFieldValue:
            guard let textFieldInputValue = inputType.textFieldInputValue as? OutputType else { throw InteractionFlowError.identifierNotFound }
            return textFieldInputValue
        }
        
    }
    
    public func getAllOutput<Identifier: InteractionFlowElementIdentifiable>(
        _ identifierType: Identifier.Type,
        outputs: [InteractionFlowOutputWithIdentifier<Identifier>]
    ) throws -> [InteractionFlowOutputData<Identifier>] {
        return outputs.map { outputType in
            guard let inputType = allFlowElements.first(where: { $0.id == outputType.identifier }) else { return nil }
            switch outputType.output {
            case .currencySelected:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.currencyInputCurrency)
            case .currencyAmount:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.currencyInputAmount)
            case .currencyIsEditing:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.currencyInputIsEditing)
            case .dateSelected:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.dateInputSelectedDate)
            case .dateIsEditing:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.dateInputIsEditing)
            case .selectedChipOption:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.iconChipInput)
            case .binaryChoice:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.binaryInput)
            case .textFieldValue:
                return InteractionFlowOutputData(identifier: outputType.identifier, inputType.textFieldInputValue)
            }
        }.compactMap { $0 }
    }
    
    public func setInputValue<Identifier: InteractionFlowElementIdentifiable>(_ identifier: Identifier, newValue: InteractionFlowInput) throws {
        guard !allFlowElementIds.isEmpty else { throw InteractionFlowError.noElements }
        guard allFlowElementIds.contains(identifier) else { throw InteractionFlowError.identifierNotFound }
        guard let inputType = allFlowElements.first(where: { $0.id == identifier }) else { throw InteractionFlowError.identifierNotFound }
        inputType.input = newValue
    }
}
