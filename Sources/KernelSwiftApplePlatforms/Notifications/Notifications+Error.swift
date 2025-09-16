//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 21/09/2023.
//

import Foundation
import KernelSwiftCommon

extension KernelAppUtils.Notifications: ErrorTypeable {
    public enum ErrorTypes: String, KernelSwiftCommon.ErrorTypes {
        case notificationServiceDesynchronised
    }
}
