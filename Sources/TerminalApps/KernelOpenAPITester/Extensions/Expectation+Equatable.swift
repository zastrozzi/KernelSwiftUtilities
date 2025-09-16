//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/27/23.
//

import Foundation

extension TestPlan.Expectation: Equatable {
//    @available(*, deprecated, renamed: "", message: "Equatable now.")
//    func isNothing() -> Bool {
//        
//        let b = (expectationSchema == nil) && means.isEmpty && expectedData.isEmpty
//        print("isNothing ? \(b)")
//        return b
//    }
    
    public static func == (lhs: TestPlan.Expectation, rhs: TestPlan.Expectation) -> Bool {
        lhs.means == rhs.means &&
        lhs.meansSchema == rhs.meansSchema &&
        lhs.expectedData == rhs.expectedData &&
        lhs.expectationSchema == rhs.expectationSchema &&
        lhs.criteria == rhs.criteria
    }
}

extension TestPlan.Result.Check.Criterion: Equatable {
    public static func == (lhs: TestPlan.Result.Check.Criterion, rhs: TestPlan.Result.Check.Criterion) -> Bool {
        
        // for each left side case we compare with right side case
        switch lhs {
            
        case .noPreviousErrors:
            switch rhs {
            case .noPreviousErrors:
                return true
            case .alwaysFail:
                return false
            case .blob2blobEquality:
                return false
            case .returnsStatus(_):
                return false
            }
        case .alwaysFail:
            switch rhs {
            case .noPreviousErrors:
                return false
            case .alwaysFail:
                return true
            case .blob2blobEquality:
                return false
            case .returnsStatus(_):
                return false
            }
        case .blob2blobEquality:
            switch rhs {
            case .noPreviousErrors:
                return false
            case .alwaysFail:
                return false
            case .blob2blobEquality:
                return true
            case .returnsStatus(_):
                return false
            }
        case .returnsStatus(let leftStatusCode):
            switch rhs {
            case .noPreviousErrors:
                return true
            case .alwaysFail:
                return false
            case .blob2blobEquality:
                return false
            case .returnsStatus(let rightStatusCode):
                return leftStatusCode == rightStatusCode
            }
        }
    }
}

extension TestPlan.Result: Equatable {
    public static func == (lhs: TestPlan.Result, rhs: TestPlan.Result) -> Bool {
        lhs.data == rhs.data &&
        lhs.status == rhs.status
    }
}
