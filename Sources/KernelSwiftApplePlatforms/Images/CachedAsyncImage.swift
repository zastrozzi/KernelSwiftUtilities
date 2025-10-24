//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 24/10/2025.
//

import Foundation
import SwiftUI
import Combine

public struct CachedAsyncImage<Content: View>: View {
    @State var phase: AsyncImagePhase = .empty
    
    private let loader: ImageLoader
    private let url: URL
    private let content: (AsyncImagePhase) -> Content
    
    public init(
        url: URL,
        loader: ImageLoader = ImageLoaderImpl.shared,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.url = url
        self.loader = loader
        self.content = content
    }
    
    public var body: some View {
        content(phase)
            .task {
                for await phase in loader.load(url: url).values {
                    self.phase = phase
                }
            }
    }
}

public protocol ImageLoader {
    func load(url: URL) -> AnyPublisher<AsyncImagePhase, Never>
}

public class ImageLoaderImpl: ImageLoader, @unchecked Sendable {
    enum Error: Swift.Error {
        case imageDecodingFailed
    }
    
    // Shared instance to provide a common cache for all views.
    // Since all views operate on the main thread, we don't have to worry about data races.
    public static let shared = ImageLoaderImpl()
    
    // This dictionary stores the current publisher for a given URL,
    // along with a cancellable that removes the publisher from the dictionary
    // once the request completes.
    var loaders: [URL: (publisher: AnyPublisher<AsyncImagePhase, Never>, cancelable: AnyCancellable)] = [:]
    
    public func load(url: URL) -> AnyPublisher<AsyncImagePhase, Never> {
        // If a publisher already exists for this URL, return it.
        if let (publisher, _) = loaders[url] {
            return publisher
        } else {
            // Otherwise, create a new one.
            
            // This subject will emit AsyncImagePhase values to the AsyncImage.
            let subject = CurrentValueSubject<AsyncImagePhase, Never>(.empty)
            
            // Erase the subject to AnyPublisher to hide the implementation details from subscribers.
            let publisher = subject.eraseToAnyPublisher()
            
            // Make the request via URLSession.dataTaskPublisher
            let cancelable = URLSession
                .shared.dataTaskPublisher(for: url)
            // Map the response to AsyncImagePhase
                .map({ (data, _) in
                    if let image = UIImage(data: data) {
                        return AsyncImagePhase.success(Image(uiImage: image))
                    } else {
                        return .failure(Error.imageDecodingFailed)
                    }
                })
            // Convert all errors into AsyncImagePhase
                .catch { Just<AsyncImagePhase>(AsyncImagePhase.failure($0)) }
            // Send all events to our shared subject
                .handleEvents(receiveOutput: subject.send)
            // Once we receive the final result, remove the publisher from the dictionary
            // and cancel the associated subscription
                .sink(receiveValue: { [weak self] _ in
                    self?.loaders[url]?.cancelable.cancel()
                    self?.loaders[url] = nil
                })
            
            // Store the publisher and subscription in the dictionary
            loaders[url] = (publisher: publisher, cancelable: cancelable)
            return publisher
        }
    }
}
