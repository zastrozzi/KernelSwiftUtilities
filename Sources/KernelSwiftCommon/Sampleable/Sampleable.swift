//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 14/10/2023.
//  Extended implementation of Matt Polzin's Sampleable library.
//

import Foundation

@_documentation(visibility: internal)
public protocol _KernelSampleable: KernelSwiftCommon.AbstractSampleable {
    static var sample: Self { get }
    static var successSample: Self? { get }
    static var failureSample: Self? { get }
    static var samples: [Self] { get }
}

extension KernelSwiftCommon {
    public typealias Sampleable = _KernelSampleable
}

extension KernelSwiftCommon.Sampleable {
    public typealias _S = KernelSwiftCommon.Sampleable
    public static var abstractSample: Any { sample }
    public static var successSample: Self? { nil }
    public static var failureSample: Self? { nil }
    public static var samples: [Self] { [Self.sample] }
    public static func samples<S1: _S>(
        using s1: S1.Type,
        with constructor: (S1) -> Self
    ) -> [Self] {
        S1.samples.map(constructor)
    }
    
    public static func samples<S1: _S, S2: _S>(
        using s1: S1.Type,
        _ s2: S2.Type,
        with ctr: (S1, S2) -> Self
    ) -> [Self] {
        zip(S1.samples, S2.samples).map(ctr)
    }
    
    public static func samples<S1: _S, S2: _S, S3: _S>(
        using s1: S1.Type,
        _ s2: S2.Type,
        _ s3: S3.Type,
        with ctr: (S1, S2, S3) -> Self
    ) -> [Self] {
        zip3(S1.samples, S2.samples, S3.samples).map(ctr)
    }
    
    public static func samples<S1: _S, S2: _S, S3: _S, S4: _S>(
        using s1: S1.Type,
        _ s2: S2.Type,
        _ s3: S3.Type,
        _ s4: S4.Type,
        with ctr: (S1, S2, S3, S4) -> Self
    ) -> [Self] {
        zip4(S1.samples, S2.samples, S3.samples, S4.samples).map(ctr)
    }
    
    public static func samples<S1: _S, S2: _S, S3: _S, S4: _S, S5: _S>(
        using s1: S1.Type,
        _ s2: S2.Type,
        _ s3: S3.Type,
        _ s4: S4.Type,
        _ s5: S5.Type,
        with ctr: (S1, S2, S3, S4, S5) -> Self
    ) -> [Self] {
        zip5(S1.samples, S2.samples, S3.samples, S4.samples, S5.samples).map(ctr)
    }
    
    public static func samples<S1: _S, S2: _S, S3: _S, S4: _S, S5: _S, S6: _S>(
        using s1: S1.Type,
        _ s2: S2.Type,
        _ s3: S3.Type,
        _ s4: S4.Type,
        _ s5: S5.Type,
        _ s6: S6.Type,
        with ctr: (S1, S2, S3, S4, S5, S6) -> Self
    ) -> [Self] {
        zip(
            zip3(S1.samples, S2.samples, S3.samples),
            zip3(S4.samples, S5.samples, S6.samples)
        )
        .map { ($0.0.0, $0.0.1, $0.0.2, $0.1.0, $0.1.1, $0.1.2) }
        .map(ctr)
    }
    
    public static func samples<S1: _S, S2: _S, S3: _S, S4: _S, S5: _S, S6: _S, S7: _S>(
        using s1: S1.Type,
        _ s2: S2.Type,
        _ s3: S3.Type,
        _ s4: S4.Type,
        _ s5: S5.Type,
        _ s6: S6.Type,
        _ s7: S7.Type,
        with ctr: (S1, S2, S3, S4, S5, S6, S7) -> Self
    ) -> [Self] {
        zip(
            zip3(S1.samples, S2.samples, S3.samples),
            zip4(S4.samples, S5.samples, S6.samples, S7.samples)
        )
        .map { ($0.0.0, $0.0.1, $0.0.2, $0.1.0, $0.1.1, $0.1.2, $0.1.3) }
        .map(ctr)
    }
    
    public static func samples<S1: _S, S2: _S, S3: _S, S4: _S, S5: _S, S6: _S, S7: _S, S8: _S>(
        using s1: S1.Type,
        _ s2: S2.Type,
        _ s3: S3.Type,
        _ s4: S4.Type,
        _ s5: S5.Type,
        _ s6: S6.Type,
        _ s7: S7.Type,
        _ s8: S8.Type,
        with ctr: (S1, S2, S3, S4, S5, S6, S7, S8) -> Self
    ) -> [Self] {
        zip(
            zip4(S1.samples, S2.samples, S3.samples, S4.samples),
            zip4(S5.samples, S6.samples, S7.samples, S8.samples)
        )
        .map { ($0.0.0, $0.0.1, $0.0.2, $0.0.3, $0.1.0, $0.1.1, $0.1.2, $0.1.3) }
        .map(ctr)
    }
    
    @usableFromInline typealias _Z = Sequence
    @usableFromInline typealias _ZE<Z: _Z> = Z.Element
    
    @inlinable static func zip3<A: _Z, B: _Z, C: _Z>(
        _ a: A,
        _ b: B,
        _ c: C
    ) -> [(_ZE<A>, _ZE<B>, _ZE<C>)] {
        zip(a, zip(b, c))
        .map { ($0.0, $0.1.0, $0.1.1) }
    }
    
    @inlinable static func zip4<A: _Z, B: _Z, C: _Z, D: _Z>(
        _ a: A,
        _ b: B,
        _ c: C,
        _ d: D
    ) -> [(_ZE<A>, _ZE<B>, _ZE<C>, _ZE<D>)] {
        zip(a, zip(b, zip(c, d)))
        .map { ($0.0, $0.1.0, $0.1.1.0, $0.1.1.1) }
    }
    
    @inlinable static func zip5<A: _Z, B: _Z, C: _Z, D: _Z, E: _Z>(
        _ a: A,
        _ b: B,
        _ c: C,
        _ d: D,
        _ e: E
    ) -> [(_ZE<A>, _ZE<B>, _ZE<C>, _ZE<D>, _ZE<E>)] {
        zip(a, zip(b, zip(c, zip(d, e))))
        .map { ($0.0, $0.1.0, $0.1.1.0, $0.1.1.1.0, $0.1.1.1.1) }
    }
}


