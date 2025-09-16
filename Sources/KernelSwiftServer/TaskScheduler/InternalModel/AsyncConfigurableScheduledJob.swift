//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//

public protocol AsyncConfigurableScheduledJob: Sendable {
    init()
    static var name: String { get }
    func run(context: KernelTaskScheduler.AsyncQueueContext) async throws
}

extension AsyncConfigurableScheduledJob {
    public static var name: String { "\(Self.self)" }
    public var name: String { "\(Self.self)" }
    
    public func run(_ context: KernelTaskScheduler.AsyncQueueContext) async throws -> Void {
        try await self.run(context: context)
    }
}
