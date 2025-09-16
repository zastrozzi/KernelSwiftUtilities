//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 30/08/2022.
//

import Foundation

@inline(__always) public func raiseBreakpoint(_ message: @autoclosure () -> String = "") {
    #if DEBUG
    var name: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var info: kinfo_proc = kinfo_proc()
    var info_size = MemoryLayout<kinfo_proc>.size
    
    let isDebuggerAttached = name.withUnsafeMutableBytes {
        $0.bindMemory(to: Int32.self).baseAddress.map { sysctl($0, 4, &info, &info_size, nil, 0) != -1 && info.kp_proc.p_flag.and(P_TRACED, not: .zero) } ?? false
    }
    
    if isDebuggerAttached {
        fputs(
        """
        \(message())
        
        Caught debug breakpoint. Type "continue" ("c") to resume execution.
        
        """,
        stderr
        )
        raise(SIGTRAP)
    }
    #endif
}
