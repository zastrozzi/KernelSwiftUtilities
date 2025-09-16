//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/10/2023.
//

import Foundation
import Vapor

extension KernelTaskScheduler.Model {
    public struct CreateJobRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public init(seconds: Int) {
            self.seconds = seconds
        }
        
        public let seconds: Int
    }
}

extension KernelTaskScheduler.Model.CreateJobRequest {
    public static let sample: KernelTaskScheduler.Model.CreateJobRequest = .init(seconds: 30)
}
