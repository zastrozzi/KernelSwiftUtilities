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
    public enum SpecialCurrencyName: String, FluentStringEnum {
        public static let fluentEnumName: String = "ksc-iso_4217_special_currency_name"
        
        case XAG = "Silver"
        case XAU = "Gold"
        case XBA = "Bond Markets Unit European Composite Unit (EURCO)"
        case XBB = "Bond Markets Unit European Monetary Unit (E.M.U.-6)"
        case XBC = "Bond Markets Unit European Unit of Account 9 (E.U.A.-9)"
        case XBD = "Bond Markets Unit European Unit of Account 17 (E.U.A.-17)"
        case XCD = "East Caribbean Dollar"
        case XDR = "SDR (Special Drawing Right)"
        case XOF = "CFA Franc BCEAO"
        case XPD = "Palladium"
        case XPF = "CFP Franc"
        case XPT = "Platinum"
        case XSU = "Sucre"
        case XTS = "Codes specifically reserved for testing purposes"
        case XUA = "ADB Unit of Account"
        case XXX = "The codes assigned for transactions where no currency is involved"
        case unknown = "Unknown"
    }
}
