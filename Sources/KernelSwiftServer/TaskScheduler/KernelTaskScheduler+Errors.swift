//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 04/07/2023.
//
import KernelSwiftCommon

extension KernelTaskScheduler: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case cancelledTask
        case jobNotFound
        case jobAlreadyExists
    }
}
