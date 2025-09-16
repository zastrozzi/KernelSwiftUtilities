//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 29/08/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

extension KernelCurrency.Core.ISO4217 {
    public enum SpecialCurrencyCode: String, FluentStringEnum {
        public static let fluentEnumName: String = "ksc-iso_4217_special_currency_code"
        
        case XAG = "XAG"
        case XAU = "XAU"
        case XBA = "XBA"
        case XBB = "XBB"
        case XBC = "XBC"
        case XBD = "XBD"
        case XCD = "XCD"
        case XDR = "XDR"
        case XOF = "XOF"
        case XPD = "XPD"
        case XPF = "XPF"
        case XPT = "XPT"
        case XSU = "XSU"
        case XTS = "XTS"
        case XUA = "XUA"
        case XXX = "XXX"
        case unknown = ""
    }
}
