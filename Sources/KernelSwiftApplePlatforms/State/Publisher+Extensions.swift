//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 23/02/2022.
//

import Foundation
import Combine

public extension Just where Output == Void {
    static func withErrorType<E>(_ errorType: E.Type) -> AnyPublisher<Void, E> {
        return withErrorType((), E.self)
    }
    
    static func withErrorType<E>(_ value: Output, _ errorType: E.Type) -> AnyPublisher<Output, E> {
        return Just(value)
            .setFailureType(to: E.self)
            .eraseToAnyPublisher()
    }
}

public extension Publisher where Failure == Never {
    func weakAssign<T: AnyObject>(to keyPath: ReferenceWritableKeyPath<T, Output>, on object: T) -> AnyCancellable {
        sink { [weak object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

public extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    result(.failure(error))
                default: break
                }
            },
            receiveValue: { value in
                result(.success(value))
            }
        )
    }
    
    //TODO ask boss about this
    // Loadable needs non linux stuff
    // so it was moved to apple platforms
    // but this is common and thus a circ dep.
    
//    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
//        return sink { subscriberCompletion in
//            if let error = subscriberCompletion.error {
//                completion(.failed(error))
//            }
//        } receiveValue: { value in
//            completion(.loaded(value))
//        }
//
//    }
        
}

public extension Subscribers.Completion {
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}
