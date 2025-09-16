//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 3/4/24.
//

import Vapor

extension KernelAuthSessions {
    public enum Routes {}
}

extension KernelAuthSessions.Routes {
    public static func composed(_ routes: RoutesBuilder) -> RoutesBuilder {
        return routes.grouped("auth", "sessions")
    }
    
    public static func configureRoutes(for app: Application) throws {
        // register route controllers
    }
}
