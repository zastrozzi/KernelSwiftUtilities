//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/11/2023.
//

import Foundation

extension KernelDI {
    public struct Injector: Sendable {
        @TaskLocal public static var _current = Self()
        
#if DEBUG
        @TaskLocal static var isSetting = false
#endif
        
        @TaskLocal static var currentInjectable = CurrentInjectable()
        internal var cache = InjectorCache()
        internal var storage: [ObjectIdentifier: AnySendable] = [:]
        
        public subscript<Token: TestableInjectionToken>(
            _ token: Token.Type,
            file: StaticString = #file,
            function: StaticString = #function,
            line: UInt = #line
        ) -> Token.Value where Token.Value: Sendable {
            get {
                guard
                    let base = self.storage[.init(token)]?.base,
                    let value = base as? Token.Value
                else {
//                    print("NO STORED VALUE FOR \(token)")
                    let context = self.storage[.init(InjectionContextToken.self)]?.base as? InjectionContext ?? InjectionContext.defaultContext
                    switch context {
                    case .live, .preview:
                        return self.cache.value(for: Token.self, context: context, file: file, function: function, line: line)
                    case .test:
                        var current = Self.currentInjectable
                        current.name = function
                        return Self.$currentInjectable.withValue(current) {
                            self.cache.value(for: Token.self, context: context, file: file, function: function, line: line)
                        }
                    }
                }
                return value
            }
            set {
                self.storage[.init(token)] = AnySendable(base: newValue)
            }
        }
        
        
        
        public static var live: Self {
            var values = Self()
            values.context = .live
            return values
        }
        
        public static var preview: Self {
            var values = Self()
            values.context = .preview
            return values
        }
        
        public static var test: Self {
            var values = Self()
            values.context = .test
            return values
        }
        
       public  func merging(_ other: Self) -> Self {
            var values = self
            values.storage.merge(other.storage, uniquingKeysWith: { $1 })
            return values
        }
        
        public struct Continuation: Sendable {
            let injector = Injector._current
            
            public func yield<Result: Sendable>(_ operation: @Sendable () throws -> Result) rethrows -> Result {
                try withInjector {
                    $0 = self.injector
                } operation: {
                    try operation()
                }
            }
            
            public func yield<Result: Sendable>(_ operation: @Sendable () async throws -> Result) async rethrows -> Result {
                try await withInjector {
                    $0 = self.injector
                } operation: {
                    try await operation()
                }
            }
        }
    }
    @_transparent
    internal static func injectorIsSetting<Result: Sendable>(_ value: Bool, operation: () throws -> Result) rethrows -> Result {
#if DEBUG
        try Injector.$isSetting.withValue(value, operation: operation)
#else
        try operation()
#endif
    }
    
    @_transparent
    internal static func injectorIsSetting<Result: Sendable>(_ value: Bool, operation: () async throws -> Result) async rethrows -> Result {
#if DEBUG
        try await Injector.$isSetting.withValue(value, operation: operation)
#else
        try await operation()
#endif
    }

}

extension KernelDI.Injector {
    static func _liveValue( token: Any.Type) -> Any? { (token as? any KernelDI.InjectionToken.Type)?.liveValue }
}
