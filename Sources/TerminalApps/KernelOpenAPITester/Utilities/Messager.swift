//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/29/23.
//

import Foundation
import KernelSwiftCommon

//TODO use tmux to watch log file live
class Messager {
    static let logFileURL = URL(string: "./log")
    
    struct Message: Identifiable {
        // which
        let id: UUID = UUID()
        // what
        let value: String
        //when
        let time: Date
    }
    
    struct Prefs {
        static let shared = Prefs(availableLoggers: Messager.SystemID.allCases,
                                  enabledLoggers: Messager.SystemID.allCases)
        
        public var availableLoggers: Messager.SystemID.AllCases
        public var enabledLoggers: [Messager.SystemID]
    }
    /// who says
    public enum SystemID: String, CaseIterable {
        case commandLine = "c"
        case filters = "f"
        case testplanFactory = "tf"
        case expectationFactory = "ef"
        case tester = "t"
        case execution = "e"
        case networking = "n"
        case validation = "v"
        case reporter = "r"
        case nav = "N"
    }

    /// whats happening
    public static var messages = [Message]()
    

    /// what you shuold know
    public static var advice = [Message]()
    
    /// friendly names
    static var labelsByID = [SystemID.commandLine : "CommandLine >",
                             SystemID.validation : "Validator >",
                             SystemID.expectationFactory : "Expectation Factory >",
                             SystemID.testplanFactory : "TestPlan Factory >",
                             SystemID.networking : "Networking >",
                             SystemID.execution : "Execution >",
                             SystemID.tester : "Tester >",
                             SystemID.nav : "Navgation >"
                            ]

    static func log(sys: SystemID, s: String) {
        
        let label = labelsByID[sys] ?? sys.rawValue
        KernelDI.inject(\.logger).log(level: .debug, "\(label)")
//        logger.log(level: .debug, "\(label) \(s)")

    }
    
    /// logs to the advice bucket for contextual help.
    static func adv(_ s: String) {
        advice.append(Message(value: s,
                              time: Date()))
    }
}
