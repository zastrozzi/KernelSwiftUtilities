//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    final class InjectorCache: Sendable {
        
        private let lock = NSRecursiveLock()
        nonisolated(unsafe) private var cached = [CacheKey: AnySendable]()
        
        init() {}
        
        func value<Token: TestableInjectionToken>(
            for token: Token.Type,
            context: InjectionContext,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
        ) -> Token.Value where Token.Value: Sendable {
            self.lock.lock()
            defer { self.lock.unlock() }
            
            let cacheKey = CacheKey(id: .init(token), context: context)
            guard
                let base = self.cached[cacheKey]?.base,
                let value = base as? Token.Value
            else {
                let value: Token.Value?
                switch context {
                case .live: value = Injector._liveValue(token: token) as? Token.Value
                case .preview: value = Token.previewValue
                case .test: value = Token.testValue
                }
                guard let value else {
#if DEBUG
                    KernelDI.logger.warning(
                """
                \(Token.injectableName) has no live implementation, but was accessed from a live context:
                
                \(Token.injectableDescription)
                """
                    )
#endif
                    return Token.testValue
                }
                
                self.cached[cacheKey] = AnySendable(base: value)
                return value
            }
            return value
        }
        
        func setCacheValue<Token: TestableInjectionToken>(
            _ value: Token.Value,
            for token: Token.Type,
            context: InjectionContext
        ) {
            self.lock.lock()
            defer { self.lock.unlock() }
            
            let cacheKey = CacheKey(id: .init(token), context: context)
            self.cached[cacheKey] = AnySendable(base: value)
        }
    }
}

extension KernelDI.InjectorCache {
    struct CacheKey: Hashable, Sendable {
        let id: ObjectIdentifier
        let context: KernelDI.InjectionContext
    }

}
