//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/10/2023.
//

import Foundation
import Vapor

extension KernelTaskScheduler.Model {
    public struct UpdateJobRequest: Codable, Equatable, Content, OpenAPIEncodableSampleable {
        public init(seconds: Int) {
            self.seconds = seconds
        }
        
        public let seconds: Int
    }
}

extension KernelTaskScheduler.Model.UpdateJobRequest {
    public static let sample: KernelTaskScheduler.Model.UpdateJobRequest = .init(seconds: 59)
}
