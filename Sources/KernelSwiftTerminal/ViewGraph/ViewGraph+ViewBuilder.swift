//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

extension KernelSwiftTerminal.ViewGraph {
    @resultBuilder
    public struct ViewBuilder {
        public static func buildBlock() -> KernelSwiftTerminal.Views.EmptyView { KernelSwiftTerminal.Views.EmptyView() }
        
        public static func buildBlock<Content: View>(_ content: Content) -> Content { content }
        
        public static func buildIf<V: View>(_ content: V)  -> V  { content }
        
        public static func buildEither<TrueContent: View, FalseContent: View>(first: TrueContent) -> _ConditionalView<TrueContent, FalseContent> {
            _ConditionalView(content: .a(first))
        }
        
        public static func buildEither<TrueContent: View, FalseContent: View>(second: FalseContent) -> _ConditionalView<TrueContent, FalseContent> {
            _ConditionalView(content: .b(second))
        }
        
        public static func buildBlock<C0: View, C1: View>(_ c0: C0, _ c1: C1) -> KernelSwiftTerminal.Views.TupleView2<C0, C1> {
            KernelSwiftTerminal.Views.TupleView2(content: (c0, c1))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View>(_ c0: C0, _ c1: C1, _ c2: C2) -> KernelSwiftTerminal.Views.TupleView3<C0, C1, C2> {
            KernelSwiftTerminal.Views.TupleView3(content: (c0, c1, c2))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View, C3: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> KernelSwiftTerminal.Views.TupleView4<C0, C1, C2, C3> {
            KernelSwiftTerminal.Views.TupleView4(content: (c0, c1, c2, c3))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> KernelSwiftTerminal.Views.TupleView5<C0, C1, C2, C3, C4> {
            KernelSwiftTerminal.Views.TupleView5(content: (c0, c1, c2, c3, c4))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> KernelSwiftTerminal.Views.TupleView6<C0, C1, C2, C3, C4, C5> {
            KernelSwiftTerminal.Views.TupleView6(content: (c0, c1, c2, c3, c4, c5))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> KernelSwiftTerminal.Views.TupleView7<C0, C1, C2, C3, C4, C5, C6> {
            KernelSwiftTerminal.Views.TupleView7(content: (c0, c1, c2, c3, c4, c5, c6))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> KernelSwiftTerminal.Views.TupleView8<C0, C1, C2, C3, C4, C5, C6, C7> {
            KernelSwiftTerminal.Views.TupleView8(content: (c0, c1, c2, c3, c4, c5, c6, c7))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> KernelSwiftTerminal.Views.TupleView9<C0, C1, C2, C3, C4, C5, C6, C7, C8> {
            KernelSwiftTerminal.Views.TupleView9(content: (c0, c1, c2, c3, c4, c5, c6, c7, c8))
        }
        
        public static func buildBlock<C0: View, C1: View, C2: View, C3: View, C4: View, C5: View, C6: View, C7: View, C8: View, C9: View>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> KernelSwiftTerminal.Views.TupleView10<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9> {
            KernelSwiftTerminal.Views.TupleView10(content: (c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
        }
        
    }
}
