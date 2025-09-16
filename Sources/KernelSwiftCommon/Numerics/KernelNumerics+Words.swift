//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 25/10/2023.
//

import Foundation

extension KernelNumerics {
    public typealias Word               = UInt32
    public typealias Words              = [Word]
    public typealias Words64            = _T2<Word>
    public typealias Words96            = _T3<Word>
    public typealias Words128           = _T4<Word>
    public typealias Words160           = _T5<Word>
    public typealias Words192           = _T6<Word>
    public typealias Words224           = _T7<Word>
    public typealias Words256           = _T8<Word>
    public typealias Words288           = _T9<Word>
    public typealias Words320           = _T10<Word>
    public typealias Words352           = _T11<Word>
    public typealias Words384           = _T12<Word>
    public typealias Words416           = _T13<Word>
    public typealias Words448           = _T14<Word>
    public typealias Words480           = _T15<Word>
    public typealias Words512           = _T16<Word>
    public typealias DoubleWord         = UInt64
    public typealias DoubleWords        = [DoubleWord]
    public typealias DoubleWords128     = _T2<DoubleWord>
    public typealias DoubleWords192     = _T3<DoubleWord>
    public typealias DoubleWords256     = _T4<DoubleWord>
    public typealias DoubleWords320     = _T5<DoubleWord>
    public typealias DoubleWords384     = _T6<DoubleWord>
    public typealias DoubleWords448     = _T7<DoubleWord>
    public typealias DoubleWords512     = _T8<DoubleWord>
}

extension KernelNumerics {
    @_documentation(visibility: private) public typealias _T1<T>  = (T)
    @_documentation(visibility: private) public typealias _T2<T>  = (T, T)
    @_documentation(visibility: private) public typealias _T3<T>  = (T, T, T)
    @_documentation(visibility: private) public typealias _T4<T>  = (T, T, T, T)
    @_documentation(visibility: private) public typealias _T5<T>  = (T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T6<T>  = (T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T7<T>  = (T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T8<T>  = (T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T9<T>  = (T, T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T10<T> = (T, T, T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T11<T> = (T, T, T, T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T12<T> = (T, T, T, T, T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T13<T> = (T, T, T, T, T, T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T14<T> = (T, T, T, T, T, T, T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T15<T> = (T, T, T, T, T, T, T, T, T, T, T, T, T, T, T)
    @_documentation(visibility: private) public typealias _T16<T> = (T, T, T, T, T, T, T, T, T, T, T, T, T, T, T, T)
}

extension KernelNumerics.Word {
    public init(littleEndian b: [UInt8], offset o: Int) {
        guard b.count > (o + 3) else { preconditionFailure("not enough bytes") }
        guard o >= .zero else { preconditionFailure("negative offset") }
        self = .init(b[o]) | .init(b[o + 1]) << 8 | .init(b[o + 2]) << 16 | .init(b[o + 3]) << 24
    }
}

extension KernelNumerics.Words {
    public static func fromBytes(_ b: [UInt8], count: Int, offset o: Int = .zero, littleEndian: Bool = true) -> Self {
        (.zero..<count).map { .init(littleEndian: b, offset: ($0 * 4) + o) }
    }
    
    public mutating func update(from b: KernelNumerics.Words512) {
        guard count >= 16 else { preconditionFailure("not enough bytes") }
        self[0...15] = [b.0, b.1, b.2, b.3, b.4, b.5, b.6, b.7, b.8, b.9, b.10, b.11, b.12, b.13, b.14, b.15]
    }
}
