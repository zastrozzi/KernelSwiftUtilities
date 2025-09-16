//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 09/07/2023.
//
import Vapor

public protocol ASN1TimeRepresentable: ASN1StringRepresentable {
    var string: String { get set }
    var stringForDateConversion: String { get }
    var year: Int { get set }
    var month: Int { get set}
    var day: Int { get set }
    var hours: Int { get set }
    var minutes: Int { get set }
    var seconds: Int { get set }
    static var format: String { get }
    init(string: String)
}

extension ASN1TimeRepresentable {
    public func getUnitValue(for timeUnit: KernelASN1.ASN1TimeUnit) -> Int? {
        let value = Int(String.init(string[timeUnit.rangeForFormatString(Self.format)]))
        return value
    }
    
    public mutating func setUnitValue(_ value: Int, for timeUnit: KernelASN1.ASN1TimeUnit) {
        switch timeUnit {
        case .year: guard value >= 0 && value <= 9999 else { fatalError() }
        case .month: guard value >= 0 && value <= 12 else { fatalError() }
        case .day: guard value >= 0 && value <= 31 else { fatalError() }
        case .hours: guard value >= 0 && value <= 23 else { fatalError() }
        case .minutes: guard value >= 0 && value <= 59 else { fatalError() }
        case .seconds: guard value >= 0 && value <= 59 else { fatalError() }
        }
        let newVal = value > 9 ? String(value) : "0" + String(value)
        let range = timeUnit.rangeForFormatString(Self.format)
        let firstPart = string[string.startIndex...string.index(before: range.lowerBound)]
        let lastPart = string[string.index(after: range.upperBound)...string.endIndex]
        string = firstPart + newVal + lastPart
    }
    
    public var stringForDateConversion: String {
        let centPrefix = year >= 50 ? "19" : "20"
        return centPrefix + string
    }
    
    public init(_ stringToValidate: String) {
        guard stringToValidate.count == Self.formatCount else {
            
            fatalError(stringToValidate + " does not match format: " + Self.format)
        }
        self.init(string: stringToValidate)
    }
    
    public init(from date: Date) {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = Self.format
        let newStr = formatter.string(from: date)
        self.init(string: newStr)
    }
    
    public func toDate() throws -> Date {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = Self.format
        guard let converted = formatter.date(from: string) else { throw KernelASN1.TypedError(.decodingFailed) }
        return converted
    }
    
    public static var formatCount: Int { Self.format.replacingOccurrences(of: "'", with: "").count }
    
    public var year: Int {
        get { getUnitValue(for: .year) ?? 0 }
        set { setUnitValue(newValue, for: .year) }
    }
    
    public var month: Int {
        get { getUnitValue(for: .month) ?? 0 }
        set { setUnitValue(newValue, for: .month) }
    }
    
    public var day: Int {
        get { getUnitValue(for: .day) ?? 0 }
        set { setUnitValue(newValue, for: .day) }
    }
    
    public var hours: Int {
        get { getUnitValue(for: .hours) ?? 0 }
        set { setUnitValue(newValue, for: .hours) }
    }
    
    public var minutes: Int {
        get { getUnitValue(for: .minutes) ?? 0 }
        set { setUnitValue(newValue, for: .minutes) }
    }
    
    public var seconds: Int {
        get { getUnitValue(for: .seconds) ?? 0 }
        set { setUnitValue(newValue, for: .seconds) }
    }
}
