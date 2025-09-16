//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 16/05/2025.
//

import Foundation

extension KernelIdentity.Core.Model {
    public enum GenderPronoun: String, FluentStringEnum {
        public static let fluentEnumName: String = "k_id-gender-pronoun"
        
        case male
        case female
        case nonbinary
    }
}
