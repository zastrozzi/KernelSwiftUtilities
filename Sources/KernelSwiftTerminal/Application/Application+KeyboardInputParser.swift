//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/11/2023.
//

import Foundation
import KernelSwiftCommon
import AsyncAlgorithms

extension KernelDI.Injector {
    public var keyboardInputParser: KernelSwiftTerminal.Application.KeyboardInputKeyParser {
        get { self[KernelSwiftTerminal.Application.KeyboardInputKeyParser.Token.self] }
        set { self[KernelSwiftTerminal.Application.KeyboardInputKeyParser.Token.self] = newValue }
    }
}

public protocol TypedAsyncSequence<Element>: AsyncSequence { }
extension AsyncCompactMapSequence: TypedAsyncSequence { }
extension AsyncMapSequence: TypedAsyncSequence { }
extension AsyncInterspersedSequence: TypedAsyncSequence { }
extension AsyncDebounceSequence: TypedAsyncSequence { }
extension AsyncFilterSequence: TypedAsyncSequence { }
extension AsyncFlatMapSequence: TypedAsyncSequence { }
extension AsyncBroadcastSequence: TypedAsyncSequence { }
extension AsyncThrottleSequence: TypedAsyncSequence { }

extension KernelSwiftTerminal.Application {
    public final class KeyboardInputKeyParser: KernelDI.Injectable {
        let sequence = AsyncStandardInputKeySequence()
        lazy var broadSequence = sequence.broadcast()
        public lazy var allSequence: some TypedAsyncSequence<UInt8.StandardIn> = broadSequence
        public lazy var nonEscapedCharacterSequence: some TypedAsyncSequence<String> = broadSequence.compactMap { $0.asNonEscapedCharacter() }
        public lazy var commandSequence: some TypedAsyncSequence<UInt8.StandardIn.Command> = broadSequence.compactMap { .init(rawValue: $0) }
        public lazy var returnKeySequence: some TypedAsyncSequence<UInt8.StandardIn.Command> = commandSequence.filter { $0.isReturnKey() }
        public lazy var arrowKeySequence: some TypedAsyncSequence<UInt8.StandardIn.ArrowKey> = commandSequence.compactMap { $0.asArrowKey() }
        public lazy var fnKeySequence: some TypedAsyncSequence<UInt8.StandardIn.FunctionKey> = commandSequence.compactMap { $0.asFunctionKey() }
        public lazy var optKeySequence: some TypedAsyncSequence<UInt8.StandardIn.OptionSequence> = commandSequence.compactMap { $0.asOptionMod() }
        
//        public lazy var nonEscSequence: some TypedAsyncSequence<UInt8.StandardIn> = allSequence.filter { $0.isNonEscapedKey }
        
//        public lazy var escSequence: some TypedAsyncSequence<UInt8.StandardIn> = allSequence.filter { !$0.isNonEscapedKey }
        
        
        public init() {
        }
    }
}
