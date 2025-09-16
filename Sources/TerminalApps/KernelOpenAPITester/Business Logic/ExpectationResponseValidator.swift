//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/10/2023.
//

import Foundation
import OpenAPIKit30

public struct ExpectationResponseValidator {
    // Preamble for logging for this module.
    
    public enum CustomStringRepresentedType {
        case unknown
        case uuid
        case date
        case url
        case trunk
    }
    
    public var schema: DereferencedJSONSchema
    public var response: AnyCodable
    public var summary: String
    
    public init(schema: DereferencedJSONSchema,
                response: AnyCodable,
                summary: String) {
        self.schema = schema
        self.response = response
        self.summary = summary
    }
    
    ///
    public func validate(inputSchema: DereferencedJSONSchema? = nil,
                         input: AnyCodable? = nil,
                         key: String = "",
                         depth: Int = 0) -> Bool {
        let _pad = depth
        let pad = ""
        let tabs = Array(repeating: "\t", count: _pad).reduce(pad) {$0 + $1}
        
        let schema = inputSchema ?? schema
        let response = input ?? response
        if depth != 0 {
            Messager.log(sys: .validation, s: "\(summary)" + " depth: \(depth+1)")
        }
        var isvalid = false
        
        switch schema {
        case let .array(_, arrayContext):
            // now we check at this level in the response
            Messager.log(sys: .validation, s:  "\(tabs)Array - ")
            // now we check at this level in the response
            Messager.log(sys: .validation, s: "\(tabs) checking Array")
            ///TODO find actual array items to pas to leaf processor for final decoding.
            if let itemSchemas = arrayContext.items {
                isvalid = validate(inputSchema: itemSchemas, key: key, depth: depth + 1)
            }else {

                isvalid = false
            }
            
        case let .boolean(coreContext):
            // now we check at this level in the response
            Messager.log(sys: .validation, s: "Boolean - core ctx \(coreContext)")
            Messager.log(sys: .validation, s: "Checking Boolean ...")
            
            Messager.log(sys: .validation, s: "\(tabs)Checked Boolean context. Assuming valid for now")
            isvalid = true
            
        case let .object(_, objectContext):
            
            Messager.log(sys: .validation, s: "\(tabs)Object - \(objectContext.requiredProperties.count + objectContext.optionalProperties.count) properties.")
            // now we check at this level in the response
            guard case let (.dictionary(valueType), true) = check(responseValue: response,
                                                                  as: .trunk) 
            else {
                Messager.log(sys: .validation, s: "not a dict")
                return false
            }
            
            //LOOK not sure this is wrong actually
            if valueType == .string {
                let responseCasted = response.value as! [String: String] // this is wrong for now i think.
                let allValidations: [(expectedKey: String, isValid: Bool)] = objectContext.properties.keys.compactMap { expectedKey in
                    guard
                        let expectedValue = objectContext.properties[expectedKey],
                        let responseInnerValue = responseCasted[expectedKey]
                    else {
                        Messager.log(sys: .validation, s: "no expected value or inner value" + " for " + expectedKey)
                        Messager.log(sys: .validation, s: " -- assumming valid  --")
                        return (expectedKey, true)
                    }
                    
                    return (expectedKey,
                            validate(inputSchema: expectedValue,
                                     input: .init(responseInnerValue),
                                     key: expectedKey,
                                     depth: depth + 1))
                }
                
                isvalid = allValidations.allSatisfy { $0.isValid }
                if !isvalid {
                    var s = ""
                    allValidations.map { validation in
                        "\(validation.expectedKey) \(validation.isValid ?  "✅" : "❌")"
                    }.forEach { line in
                        s = s + line + " "
                    }
                    Messager.log(sys: .validation, s: "\(s)")
                }
            }
            else {
                Messager.log(sys: .validation, s: "value type is not string")
                let responseCasted = response.value as! [String: AnyCodable] // this is wrong for now i think.
                
                let allValidations: [(expectedKey: String, isValid: Bool)] = objectContext.properties.keys.compactMap { expectedKey in
                    guard
                        let expectedValue = objectContext.properties[expectedKey],
                        let responseInnerValue = responseCasted[expectedKey]
                    else { return (expectedKey, false) }
                    Messager.log(sys: .validation, s:  "recusring into validate ...")
                    return (expectedKey, validate(inputSchema: expectedValue,
                                                  input: responseInnerValue,
                                                  key: expectedKey,
                                                  depth: depth + 1))
                }
                
                Messager.log(sys: .validation, s: "\(tabs) Checked Object context. Assuming valid for now")
                
                isvalid = allValidations.allSatisfy { $0.isValid }
            }
            
        // and we keep going for all cases on schema
        case let .integer(_, integerContext):
            Messager.log(sys: .validation, s:  "\(tabs)Integer - \(integerContext)")
            Messager.log(sys: .validation, s: "\(tabs)checking Integer ...)")
            Messager.log(sys: .validation, s:  "\(tabs)Checked Integer context. Assuming valid for now")
            isvalid = true

        case let .number(_, numberContext):
            Messager.log(sys: .validation, s: "\(tabs)Number - \(numberContext)")
            Messager.log(sys: .validation, s:  "\(tabs)Chcking Number ... \(numberContext)")
            Messager.log(sys: .validation, s:  "\(tabs)Checked Number context. Assuming valid for now")
            isvalid = true

        case let .string(strCoreContext, stringContext):
            Messager.log(sys: .validation, s:  "\(tabs) \(key) context is \(stringContext)")
        
            switch strCoreContext.format {
            case .dateTime:
                let responseChecked = check(responseValue: response, as: .date)
                isvalid = responseChecked.isValid
                
            case .other("uuid"):
                let responseChecked = check(responseValue: response, as: .uuid)
                isvalid = responseChecked.isValid
                
            case .other("url"):
                let responseChecked = check(responseValue: response, as: .url)
                isvalid = responseChecked.isValid
                
            case .generic:
                let responseChecked = check(responseValue: response, as: .unknown)
                isvalid = responseChecked.isValid
                
            default: break
            }

        case let .all(of: schemas, core: context):
            Messager.log(sys: .validation, s: "All of core -")
            Messager.log(sys: .validation, s: "\(schemas) , \(context)")
            isvalid = true

        case let .any(of: schemas, core: context):
            Messager.log(sys: .validation, s: "Any of core -")
            Messager.log(sys: .validation, s: "\(schemas) , \(context)")
            isvalid = true

        case let .one(of: schemas, core: context):
            Messager.log(sys: .validation, s: "One of core -")
            Messager.log(sys: .validation, s: "\(schemas) , \(context)")
            isvalid = true

        case let .not(schema, core: context):
            Messager.log(sys: .validation, s: "Not core -")
            Messager.log(sys: .validation, s: "\(schema), \(context)")
            isvalid = true

        case let .fragment(context):
            Messager.log(sys: .validation, s: "Fragment -")
            Messager.log(sys: .validation, s: "\(context)")
            isvalid = true

        }
        
        return isvalid
    }
    
    func check(responseValue: AnyCodable? = nil,
               allowedValues: [AnyCodable]? = nil,
               as customType: CustomStringRepresentedType,
               depth: Int = 0) -> (responseType: ResponseType, isValid: Bool) {
        
        let response = responseValue ?? response
        Messager.log(sys: .validation, s:  "Checking response value in " + "\(response.value)" + " at depth \(depth)" + " as " + "\(customType)" + " fits " + "\(allowedValues ?? [])")
        switch response.value {
#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
        case let number as NSNumber:
            // now we check at this level
            Messager.log(sys: .validation, s: "Number - \(number) Will need to check expected numeric enum types...")
            break
#endif
        case is NSNull, is Void:
            // now we check at this level
            Messager.log(sys: .validation, s: "Null")
            break
        case let bool as Bool:
            // now we check at this level
            Messager.log(sys: .validation, s:  "Bool \(bool)")
            break
        case let int as Int:
            // now we check at this level
            Messager.log(sys: .validation, s:  "Int \(int)")
            break
        case let int8 as Int8:
            // now we check at this level
            Messager.log(sys: .validation, s:  "Int8 \(int8)")
            break
        case let int16 as Int16:
            // now we check at this level
            Messager.log(sys: .validation, s:  "Int16 \(int16)")
            break
        case let int32 as Int32:
            // now we check at this level
            Messager.log(sys: .validation, s: "Int32 \(int32)")
            break
        case let int64 as Int64:
            // now we check at this level
            Messager.log(sys: .validation, s: "Int64 \(int64)")
            break
            
        case let uint as UInt:
            // now we check at this level
            Messager.log(sys: .validation, s: "UInt - \(uint)")
            break
            
        case let uint8 as UInt8:
            // now we check at this level
            Messager.log(sys: .validation, s: "UInt8 \(uint8)")
            break
            
        case let uint16 as UInt16:
            // now we check at this level
            Messager.log(sys: .validation, s: "UInt16 - \(uint16)")
            break
            
        case let uint32 as UInt32:
            // now we check at this level
            Messager.log(sys: .validation, s: "Int32 \(uint32)")
            break
            
        case let uint64 as UInt64:
            // now we check at this level
            Messager.log(sys: .validation, s:  "UInt64 - \(uint64)")
            break
            
        case let float as Float:
            // now we check at this level
            Messager.log(sys: .validation, s:  "Float \(float)")
            break
            
        case let double as Double:
            // now we check at this level
            Messager.log(sys: .validation, s:  "Double - \(double)")
            break
            
        case let string as String:
            Messager.log(sys: .validation, s:  "CUSTOM TYPE: \(customType) string = '\(string)'")
            
            switch customType {
            case .date:
                Messager.log(sys: .validation, s: "Decoding Date ...")
                let formatter = DateFormatter.iso8601InternetTimeZone
                if let decoded = formatter.date(from: string) {
                    Messager.log(sys: .validation, s:  "decoded Date \(decoded)")
                    return (.stringRepresented(.date), true)
                }
            case .uuid:
                Messager.log(sys: .validation, s:  "Decoding UUID ...")
                
                if let decoded = UUID(uuidString: string) {
                    Messager.log(sys: .validation, s: "Decoded UUID \(decoded)")
                    if let allowedValues {
                        let containsAllowed = allowedValues.contains(response)
                        Messager.log(sys: .validation, s: "CONTAINS allowed value \(containsAllowed)")
                        return (.stringRepresented(.uuid) , containsAllowed)
                    }else {
                        Messager.log(sys: .validation, s: "allowed value not found.")
                        return (.stringRepresented(.uuid), true)
                    }
                }else {
                    return (.stringRepresented(.uuid), false)
                }
                
            case .url:
                if  let decoded = URL(string: string) {
                    Messager.log(sys: .validation, s: "decoded  URL \(decoded)")
                    return (.stringRepresented(.uuid), true)
                }else {
                    return (.stringRepresented(.url), false)

                }
                
            case .trunk:
                let decoded = "trunk not decoded. should hit leaves upon recursion"
                Messager.log(sys: .validation, s: "decoded  trunk as \(decoded)")
                Messager.log(sys: .validation, s: "Didn't decode as CustomStringRepresentedType.")
                return (.string, false)
                
            case .unknown:
                Messager.log(sys: .validation, s: " -- unknown string type assuming valid")
                return (.string, true)
            
            }

        case let date as Date:
            // now we check at this level
            Messager.log(sys: .validation, s: "Date Check \(date)")
            break
            
        case let url as URL:
            // now we check at this level
            Messager.log(sys: .validation, s: "url check \(url)")
            break
            
        case let array as [AnyCodable]:
            // now we check at this level
            Messager.log(sys: .validation, s: "Array of AnyCodable check \(array.count) items.")
            break
            
        case let dictionary as [String: AnyCodable]:
            // now we check at this level
            Messager.log(sys: .validation, s:  "Dicrionary of AnyCodable check \(dictionary.count) items.")
            return (.dictionary(of: .any), true)
        case let dictionary as [String:String]:
            Messager.log(sys: .validation, s: "Dictionary of Strings at depth \(depth) of \(dictionary.count) items. ")
            Messager.log(sys: .validation, s:  "dictionary = \(dictionary)")
            return (.dictionary(of: .string), true)
            
        default:
            Messager.log(sys: .validation, s:  "default - " + "Returning raw value for value")
            Messager.log(sys: .validation, s:  "\(response.value)")
            return (.unknown, false)

        }
        //never reached?
        return (.unknown, false)

    }
    
    public enum ResponseType: Equatable {
        case number
        case string
        case unknown
        case any
        indirect case dictionary(of: ResponseType)
        // add more here
        indirect case stringRepresented(CustomStringRepresentedType)
        case uuid
        case url
        case bytes
        
    }
}
