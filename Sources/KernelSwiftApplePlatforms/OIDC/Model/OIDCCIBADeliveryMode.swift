//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation

public enum OIDCCIBADeliveryMode: String, Codable, Equatable, CaseIterable, Sendable {
    case poll = "poll"
    case ping = "ping"
}
