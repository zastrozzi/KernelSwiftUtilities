//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 17/08/2023.
//

#if DEBUG
#if canImport(ObjectiveC)
import Foundation

public var _ActiveTestCase: AnyObject? {
    guard
        let XCTestObservationCenter = NSClassFromString("XCTestObservationCenter"),
        let XCTestObservationCenter = XCTestObservationCenter as Any as? NSObjectProtocol,
        let shared = XCTestObservationCenter.perform(Selector(("sharedTestObservationCenter")))?
            .takeUnretainedValue(),
        let observers = shared.perform(Selector(("observers")))?
            .takeUnretainedValue() as? [AnyObject],
        let observer =
            observers
            .first(where: { NSStringFromClass(type(of: $0)) == "XCTestMisuseObserver" }),
        let currentTestCase = observer.perform(Selector(("currentTestCase")))?
            .takeUnretainedValue()
    else { return nil }
    return currentTestCase
}
#else
public var _ActiveTestCase: AnyObject? {
    nil
}
#endif
#else
public var _ActiveTestCase: AnyObject? {
    nil
}
#endif
