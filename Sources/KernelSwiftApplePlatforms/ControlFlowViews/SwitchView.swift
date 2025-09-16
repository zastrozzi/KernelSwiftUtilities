//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation
import SwiftUI
import KernelSwiftCommon

#if compiler(>=5.7)
public struct SwitchView<E: Sendable, Content>: View where Content: View {
    public typealias _tv = TupleView
    public typealias _clv = CaseLetView
    public typealias _dcv = DefaultCaseView
    public typealias _cc = _ConditionalContent
    public typealias _ecv = _ExhaustivityCheckView
    public typealias _v = View

    public typealias DefaultProvidingSwitchTupleView_1<e, c0, v0: _v, d: _v> = _tv<(_clv<e, c0, v0>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_2<e, c0, c1, v0: _v, v1: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_3<e, c0, c1, c2, v0: _v, v1: _v, v2: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_4<e, c0, c1, c2, c3, v0: _v, v1: _v, v2: _v, v3: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_5<e, c0, c1, c2, c3, c4, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_6<e, c0, c1, c2, c3, c4, c5, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_7<e, c0, c1, c2, c3, c4, c5, c6, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>, _clv<e, c6, v6>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_8<e, c0, c1, c2, c3, c4, c5, c6, c7, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>, _clv<e, c6, v6>, _clv<e, c7, v7>, _dcv<d>)>
    public typealias DefaultProvidingSwitchTupleView_9<e, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v, v8: _v, d: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>, _clv<e, c6, v6>, _clv<e, c7, v7>, _clv<e, c8, v8>, _dcv<d>)>

    public typealias SwitchTupleView_1<e, c0, v0: _v> = _clv<e, c0, v0>
    public typealias SwitchTupleView_2<e, c0, c1, v0: _v, v1: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>)>
    public typealias SwitchTupleView_3<e, c0, c1, c2, v0: _v, v1: _v, v2: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>)>
    public typealias SwitchTupleView_4<e, c0, c1, c2, c3, v0: _v, v1: _v, v2: _v, v3: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>)>
    public typealias SwitchTupleView_5<e, c0, c1, c2, c3, c4, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>)>
    public typealias SwitchTupleView_6<e, c0, c1, c2, c3, c4, c5, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>)>
    public typealias SwitchTupleView_7<e, c0, c1, c2, c3, c4, c5, c6, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>, _clv<e, c6, v6>)>
    public typealias SwitchTupleView_8<e, c0, c1, c2, c3, c4, c5, c6, c7, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>, _clv<e, c6, v6>, _clv<e, c7, v7>)>
    public typealias SwitchTupleView_9<e, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v, v8: _v> = _tv<(_clv<e, c0, v0>, _clv<e, c1, v1>, _clv<e, c2, v2>, _clv<e, c3, v3>, _clv<e, c4, v4>, _clv<e, c5, v5>, _clv<e, c6, v6>, _clv<e, c7, v7>, _clv<e, c8, v8>)>

    public typealias DefaultProvidingConditionalContent_1<e, c0, v0: _v, d: _v> = _cc<_clv<e, c0, v0>, _dcv<d>>
    public typealias DefaultProvidingConditionalContent_2<e, c0, c1, v0: _v, v1: _v, d: _v> = _cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _dcv<d>>
    public typealias DefaultProvidingConditionalContent_3<e, c0, c1, c2, v0: _v, v1: _v, v2: _v, d: _v> = _cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _dcv<d>>>
    public typealias DefaultProvidingConditionalContent_4<e, c0, c1, c2, c3, v0: _v, v1: _v, v2: _v, v3: _v, d: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _dcv<d>>
    public typealias DefaultProvidingConditionalContent_5<e, c0, c1, c2, c3, c4, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, d: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_clv<e, c4, v4>, _dcv<d>>>
    public typealias DefaultProvidingConditionalContent_6<e, c0, c1, c2, c3, c4, c5, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, d: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _dcv<d>>>
    public typealias DefaultProvidingConditionalContent_7<e, c0, c1, c2, c3, c4, c5, c6, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, d: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _cc<_clv<e, c6, v6>, _dcv<d>>>>
    public typealias DefaultProvidingConditionalContent_8<e, c0, c1, c2, c3, c4, c5, c6, c7, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v, d: _v> = _cc<_cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _cc<_clv<e, c6, v6>, _clv<e, c7, v7>>>>, _dcv<d>>
    public typealias DefaultProvidingConditionalContent_9<e, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v, v8: _v, d: _v> = _cc<_cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _cc<_clv<e, c6, v6>, _clv<e, c7, v7>>>>, _cc<_clv<e, c8, v8>, _dcv<d>>>

    public typealias ConditionalContent_1<e, c0, v0: _v> = _cc<_clv<e, c0, v0>, _dcv<_ecv<e>>>
    public typealias ConditionalContent_2<e, c0, c1, v0: _v, v1: _v> = _cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _dcv<_ecv<e>>>
    public typealias ConditionalContent_3<e, c0, c1, c2, v0: _v, v1: _v, v2: _v> = _cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _dcv<_ecv<e>>>>
    public typealias ConditionalContent_4<e, c0, c1, c2, c3, v0: _v, v1: _v, v2: _v, v3: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _dcv<_ecv<e>>>
    public typealias ConditionalContent_5<e, c0, c1, c2, c3, c4, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_clv<e, c4, v4>, _dcv<_ecv<e>>>>
    public typealias ConditionalContent_6<e, c0, c1, c2, c3, c4, c5, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _dcv<_ecv<e>>>>
    public typealias ConditionalContent_7<e, c0, c1, c2, c3, c4, c5, c6, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v> = _cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _cc<_clv<e, c6, v6>, _dcv<_ecv<e>>>>>
    public typealias ConditionalContent_8<e, c0, c1, c2, c3, c4, c5, c6, c7, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v> = _cc<_cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _cc<_clv<e, c6, v6>, _clv<e, c7, v7>>>>, _dcv<_ecv<e>>>
    public typealias ConditionalContent_9<e, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0: _v, v1: _v, v2: _v, v3: _v, v4: _v, v5: _v, v6: _v, v7: _v, v8: _v> = _cc<_cc<_cc<_cc<_clv<e, c0, v0>, _clv<e, c1, v1>>, _cc<_clv<e, c2, v2>, _clv<e, c3, v3>>>, _cc<_cc<_clv<e, c4, v4>, _clv<e, c5, v5>>, _cc<_clv<e, c6, v6>, _clv<e, c7, v7>>>>, _cc<_clv<e, c8, v8>, _dcv<_ecv<e>>>>

    
    public let bkEnum: Binding<E>
    public let content: () -> Content
    
    private init(bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> Content) {
        self.bkEnum = bkEnum
        self.content = content
    }
    
    public var body: some View {
        self.content().environmentObject(ControlFlowBindingObject(binding: self.bkEnum))
        
    }
}

extension SwitchView {
    public init<c0: Sendable, v0, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_1<E, c0, v0, d>) where Content == DefaultProvidingConditionalContent_1<E, c0, v0, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            if content.0.casePath ~= bkEnum.wrappedValue {
                content.0
            } else {
                content.1
            }
        }
    }
    
    public init<c0: Sendable, v0>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_1<E, c0, v0>) where Content == ConditionalContent_1<E, c0, v0> {
        self.init(bkEnum) {
            content()
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, v0, v1, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_2<E, c0, c1, v0, v1, d>) where Content == DefaultProvidingConditionalContent_2<E, c0, c1, v0, v1, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            default: content.2
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, v0, v1>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_2<E, c0, c1, v0, v1>) where Content == ConditionalContent_2<E, c0, c1, v0, v1> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, v0, v1, v2, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_3<E, c0, c1, c2, v0, v1, v2, d>) where Content == DefaultProvidingConditionalContent_3<E, c0, c1, c2, v0, v1, v2, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            case content.2.casePath: content.2
            default: content.3
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, v0, v1, v2>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_3<E, c0, c1, c2, v0, v1, v2>) where Content == ConditionalContent_3<E, c0, c1, c2, v0, v1, v2> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            content.value.2
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, v0, v1, v2, v3, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_4<E, c0, c1, c2, c3, v0, v1, v2, v3, d>) where Content == DefaultProvidingConditionalContent_4<E, c0, c1, c2, c3, v0, v1, v2, v3, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            case content.2.casePath: content.2
            case content.3.casePath: content.3
            default: content.4
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, v0, v1, v2, v3>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_4<E, c0, c1, c2, c3, v0, v1, v2, v3>) where Content == ConditionalContent_4<E, c0, c1, c2, c3, v0, v1, v2, v3> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            content.value.2
            content.value.3
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, v0, v1, v2, v3, v4, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_5<E, c0, c1, c2, c3, c4, v0, v1, v2, v3, v4, d>) where Content == DefaultProvidingConditionalContent_5<E, c0, c1, c2, c3, c4, v0, v1, v2, v3, v4, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            case content.2.casePath: content.2
            case content.3.casePath: content.3
            case content.4.casePath: content.4
            default: content.5
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, v0, v1, v2, v3, v4>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_5<E, c0, c1, c2, c3, c4, v0, v1, v2, v3, v4>) where Content == ConditionalContent_5<E, c0, c1, c2, c3, c4, v0, v1, v2, v3, v4> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            content.value.2
            content.value.3
            content.value.4
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, v0, v1, v2, v3, v4, v5, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_6<E, c0, c1, c2, c3, c4, c5, v0, v1, v2, v3, v4, v5, d>) where Content == DefaultProvidingConditionalContent_6<E, c0, c1, c2, c3, c4, c5, v0, v1, v2, v3, v4, v5, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            case content.2.casePath: content.2
            case content.3.casePath: content.3
            case content.4.casePath: content.4
            case content.5.casePath: content.5
            default: content.6
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, v0, v1, v2, v3, v4, v5>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_6<E, c0, c1, c2, c3, c4, c5, v0, v1, v2, v3, v4, v5>) where Content == ConditionalContent_6<E, c0, c1, c2, c3, c4, c5, v0, v1, v2, v3, v4, v5> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            content.value.2
            content.value.3
            content.value.4
            content.value.5
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, c6: Sendable, v0, v1, v2, v3, v4, v5, v6, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_7<E, c0, c1, c2, c3, c4, c5, c6, v0, v1, v2, v3, v4, v5, v6, d>) where Content == DefaultProvidingConditionalContent_7<E, c0, c1, c2, c3, c4, c5, c6, v0, v1, v2, v3, v4, v5, v6, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            case content.2.casePath: content.2
            case content.3.casePath: content.3
            case content.4.casePath: content.4
            case content.5.casePath: content.5
            case content.6.casePath: content.6
            default: content.7
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, c6: Sendable, v0, v1, v2, v3, v4, v5, v6>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_7<E, c0, c1, c2, c3, c4, c5, c6, v0, v1, v2, v3, v4, v5, v6>) where Content == ConditionalContent_7<E, c0, c1, c2, c3, c4, c5, c6, v0, v1, v2, v3, v4, v5, v6> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            content.value.2
            content.value.3
            content.value.4
            content.value.5
            content.value.6
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, c6: Sendable, c7: Sendable, v0, v1, v2, v3, v4, v5, v6, v7, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_8<E, c0, c1, c2, c3, c4, c5, c6, c7, v0, v1, v2, v3, v4, v5, v6, v7, d>) where Content == DefaultProvidingConditionalContent_8<E, c0, c1, c2, c3, c4, c5, c6, c7, v0, v1, v2, v3, v4, v5, v6, v7, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            case content.2.casePath: content.2
            case content.3.casePath: content.3
            case content.4.casePath: content.4
            case content.5.casePath: content.5
            case content.6.casePath: content.6
            case content.7.casePath: content.7
            default: content.8
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, c6: Sendable, c7: Sendable, v0, v1, v2, v3, v4, v5, v6, v7>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_8<E, c0, c1, c2, c3, c4, c5, c6, c7, v0, v1, v2, v3, v4, v5, v6, v7>) where Content == ConditionalContent_8<E, c0, c1, c2, c3, c4, c5, c6, c7, v0, v1, v2, v3, v4, v5, v6, v7> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            content.value.2
            content.value.3
            content.value.4
            content.value.5
            content.value.6
            content.value.7
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, c6: Sendable, c7: Sendable, c8: Sendable, v0, v1, v2, v3, v4, v5, v6, v7, v8, d>(_ bkEnum: Binding<E>, @ViewBuilder content: @escaping () -> DefaultProvidingSwitchTupleView_9<E, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0, v1, v2, v3, v4, v5, v6, v7, v8, d>) where Content == DefaultProvidingConditionalContent_9<E, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0, v1, v2, v3, v4, v5, v6, v7, v8, d> {
        self.init(bkEnum: bkEnum) {
            let content = content().value
            switch bkEnum.wrappedValue {
            case content.0.casePath: content.0
            case content.1.casePath: content.1
            case content.2.casePath: content.2
            case content.3.casePath: content.3
            case content.4.casePath: content.4
            case content.5.casePath: content.5
            case content.6.casePath: content.6
            case content.7.casePath: content.7
            case content.8.casePath: content.8
            default: content.9
            }
        }
    }
    
    public init<c0: Sendable, c1: Sendable, c2: Sendable, c3: Sendable, c4: Sendable, c5: Sendable, c6: Sendable, c7: Sendable, c8: Sendable, v0, v1, v2, v3, v4, v5, v6, v7, v8>(_ bkEnum: Binding<E>, file: StaticString = #fileID, line: UInt = #line, @ViewBuilder content: @escaping () -> SwitchTupleView_9<E, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0, v1, v2, v3, v4, v5, v6, v7, v8>) where Content == ConditionalContent_9<E, c0, c1, c2, c3, c4, c5, c6, c7, c8, v0, v1, v2, v3, v4, v5, v6, v7, v8> {
        let content = content()
        self.init(bkEnum) {
            content.value.0
            content.value.1
            content.value.2
            content.value.3
            content.value.4
            content.value.5
            content.value.6
            content.value.7
            content.value.8
            DefaultCaseView { _ExhaustivityCheckView<E>(file: file, line: line) }
        }
    }

}

#if DEBUG
struct SwitchViewExampleView: View {
    @State var status: StatusEnum = .active(substatus: 0)
    @State var count: Int = 0
    
    enum StatusEnum: Equatable, Sendable {
        case active(substatus: Int)
        case inactive
        case other
    }
    
    var body: some View {
        VStack {
            HStack {
                
                Button("Set Active") {
                    if case .active = status { count += 1 }
                    status = .active(substatus: count)
                    
                }
                Spacer()
                Button("Set Inactive") {
                    count = 0
                    status = .inactive
                }
                Spacer()
                Button("Set Unhandled") { status = .other }
                
            }
            .padding()
            SwitchView($status) {
                CaseLetView(/StatusEnum.active) { substatus in
                    Text("Active - Repeat \(substatus.wrappedValue)")
                }
//                CaseLetView(/StatusEnum.inactive) { _ in
//                    Text("Inactive")
//                }
                
                CaseLetView(/StatusEnum.inactive) { substatus in
                    Text("Inactive")
                }
            }
            .padding()
            #if os(iOS)
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(Color(.secondarySystemBackground)))
            #endif
        }
    }
}

struct SwitchViewExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchViewExampleView()
    }
}
#endif
#endif
