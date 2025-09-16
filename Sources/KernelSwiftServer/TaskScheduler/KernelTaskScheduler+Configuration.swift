//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/06/2023.
//
import KernelSwiftCommon

extension KernelTaskScheduler {
    public enum ConfigKeys: LabelRepresentable {
        case workerCount
        
        public var label: String {
            switch self {
            case .workerCount: "workerCount"
            }
        }
    }
}
