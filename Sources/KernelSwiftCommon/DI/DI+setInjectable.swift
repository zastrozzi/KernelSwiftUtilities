//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/02/2025.
//

import Foundation

extension KernelDI {
    public static func setInjectable<Token: TestableInjectionToken>(
        _ value: Token.Value,
        for token: Token.Type,
        context: InjectionContext = InjectionContext.defaultContext
    ) -> Token.Value where Token.Value: Sendable {
        let current = Injector._current
//        let currentInjectable = Injector.currentInjectable
//        return Self.$currentInjectable.withValue(currentInjectable) {
            //                current.storage[.init(token)] = AnySendable(base: value)
        current.cache.setCacheValue(value, for: Token.self, context: context)
        return current.cache.value(for: Token.self, context: context)
//        }
    }
    
    public static func setInjectable<Injectable: KernelDI.Injectable>(
        _ value: Injectable.Token.Value,
//        as valueType: Injectable.Type = Injectable.self,
        for token: Injectable.Token.Type = Injectable.Token.self,
        context: InjectionContext = InjectionContext.defaultContext
    ) -> Injectable {
//        let current = Injector._current
//        let currentInjectable = Injector.currentInjectable
//        return Injector.$currentInjectable.withValue(currentInjectable) {
        Injector._current.cache.setCacheValue(value, for: Injectable.Token.self, context: context)
        return Injector._current.cache.value(for: Injectable.Token.self, context: context) as! Injectable
//        }
    }
}
