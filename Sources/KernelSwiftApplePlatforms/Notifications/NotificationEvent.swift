//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 12/09/2023.
//

import Foundation

public extension KernelAppUtils.Notifications {
    struct NotificationEvent: Sendable {
        public var timestamp: Date
        public var name: Notification.Name
        
       public init(ts: Date,
             name: Notification.Name) {
            self.timestamp = ts
            self.name = name
        }
    }
}
