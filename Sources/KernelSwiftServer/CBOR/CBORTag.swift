//
//  File.swift
//
//
//  Created by Jonathan Forbes on 18/09/2023.
//

import Foundation

extension KernelCBOR {
    public enum CBORTag: UInt64, RawRepresentable, Equatable, Hashable, CaseIterable, Sendable {
        case standardDateTimeString                                = 0
        case epochBasedDateTime                                    = 1
        case unsignedBignum                                        = 2
        case negativeBignum                                        = 3
        case decimalFraction                                       = 4
        case bigFloat                                              = 5
        // UNASSIGNED 6-15
        case coseSingleRecipientEncryptedDataObject                = 16
        case coseMacWithoutRecipientsObject                        = 17
        case coseSingleSignerDataObject                            = 18
        case coseStandaloneV2Countersignature                      = 19
        // UNASSIGNED 20
        case expectedConversionToBase64URLEncoding                 = 21
        case expectedConversionToBase64Encoding                    = 22
        case expectedConversionToBase16Encoding                    = 23
        case encodedCBORDataItem                                   = 24
        case referenceNthPreviouslySeenString                      = 25
        case serialisedPerlObjectWithClassnameAndConstructorArgs   = 26
        case serialisedObjectWithTypenameAndConstructorArgs        = 27
        case markValueAsPotentiallyShared                          = 28
        case referenceNthMarkedValue                               = 29
        case rationalNumber                                        = 30
        case absentValueInCBORArray                                = 31
        case uri                                                   = 32
        case base64URL                                             = 33
        case base64                                                = 34
        case regularExpression                                     = 35
        case mimeMessage                                           = 36
        case binaryUUID                                            = 37
        case languageTaggedString                                  = 38
        case identifier                                            = 39
        case multiDimensionalArrayWithRowMajorOrder                = 40
        case homogeneousArray                                      = 41
        case ipldContentIdentifier                                 = 42
        case yangBitsDataType                                      = 43
        case yangEnumerationDataType                               = 44
        case yangIdentityRefDataType                               = 45
        case yangInstanceIdentifierDataType                        = 46
        case yangSchemaItemIdentifier                              = 47
        // UNASSIGNED 48-51
        case ipV4                                                  = 52
        // UNASSIGNED 53
        case ipV6                                                  = 54
        
        case cborWebToken                                          = 61
        
        case encodedCBORSequence                                   = 63
        case uint8TypedArray                                       = 64
        case uint16BigEndianTypedArray                             = 65
        case uint32BigEndianTypedArray                             = 66
        case uint64BigEndianTypedArray                             = 67
        case uint8TypedArrayClampedArithmetic                      = 68
        case uint16LittleEndianTypedArray                          = 69
        case uint32LittleEndianTypedArray                          = 70
        case uint64LittleEndianTypedArray                          = 71
        case sint8TypedArray                                       = 72
        case sint16BigEndianTypedArray                             = 73
        case sint32BigEndianTypedArray                             = 74
        case sint64BigEndianTypedArray                             = 75
        
        case sint16LittleEndianTypedArray                          = 77
        case sint32LittleEndianTypedArray                          = 78
        case sint64LittleEndianTypedArray                          = 79
        
        case selfDescribedCBOR                                     = 55799
    }
}
