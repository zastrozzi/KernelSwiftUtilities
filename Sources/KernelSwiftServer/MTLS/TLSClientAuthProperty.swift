//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/04/2023.
//

import Foundation

public enum TLSClientAuthProperty: String, Codable, Equatable, CaseIterable {
    case subjectDn = "tls_client_auth_subject_dn"
    case sanDns = "tls_client_auth_san_dns"
    case sanUri = "tls_client_auth_san_uri"
    case sanIp = "tls_client_auth_san_ip"
    case sanEmail = "tls_client_auth_san_email"
}
