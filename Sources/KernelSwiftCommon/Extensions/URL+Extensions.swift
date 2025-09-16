//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 13/09/2023.
//

import Foundation

extension URL {
    public func getQueryParam(value: String) -> String? {
        guard let comps = URLComponents(url: self, resolvingAgainstBaseURL: true), let queryItems = comps.queryItems else { return nil }
        return queryItems.filter ({ $0.name == value }).first?.value
    }
    
    public func components(resolvingAgainstBaseURL: Bool) -> URLComponents? {
        URLComponents(url: self, resolvingAgainstBaseURL: resolvingAgainstBaseURL)
    }
}
