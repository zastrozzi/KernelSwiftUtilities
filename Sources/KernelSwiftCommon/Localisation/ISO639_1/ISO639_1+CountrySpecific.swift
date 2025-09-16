//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

extension KernelLocalisation.ISO639_1 {
    public enum CountrySpecific: String, CaseIterable, Codable, Sendable {
        case ar_DZ = "ar-DZ"                        // Arabic (Algeria)
        case ar_BH = "ar-BH"                        // Arabic (Bahrain)
        case ar_EG = "ar-EG"                        // Arabic (Egypt)
        case ar_IQ = "ar-IQ"                        // Arabic (Iraq)
        case ar_JO = "ar-JO"                        // Arabic (Jordan)
        case ar_KW = "ar-KW"                        // Arabic (Kuwait)
        case ar_LB = "ar-LB"                        // Arabic (Lebanon)
        case ar_LY = "ar-LY"                        // Arabic (Libya)
        case ar_MA = "ar-MA"                        // Arabic (Morocco)
        case ar_OM = "ar-OM"                        // Arabic (Oman)
        case ar_QA = "ar-QA"                        // Arabic (Qatar)
        case ar_SA = "ar-SA"                        // Arabic (Saudi Arabia)
        case ar_SY = "ar-SY"                        // Arabic (Syria)
        case ar_TN = "ar-TN"                        // Arabic (Tunisia)
        case ar_AE = "ar-AE"                        // Arabic (U.A.E.)
        case ar_YE = "ar-YE"                        // Arabic (Yemen)
        case zh_HK = "zh-HK"                        // Chinese (Hong Kong)
        case zh_CN = "zh-CN"                        // Chinese (PRC)
        case zh_SG = "zh-SG"                        // Chinese (Singapore)
        case zh_TW = "zh-TW"                        // Chinese (Taiwan)
        case nl_BE = "nl-BE"                        // Dutch (Belgium)
        case nl_NL = "nl-NL"                        // Dutch (Netherlands)
        case en_AU = "en-AU"                        // English (Australia)
        case en_BZ = "en-BZ"                        // English (Belize)
        case en_CA = "en-CA"                        // English (Canada)
        case en_IE = "en-IE"                        // English (Ireland)
        case en_JM = "en-JM"                        // English (Jamaica)
        case en_NZ = "en-NZ"                        // English (New Zealand)
        case en_ZA = "en-ZA"                        // English (South Africa)
        case en_TT = "en-TT"                        // English (Trinidad)
        case en_GB = "en-GB"                        // English (United Kingdom)
        case en_US = "en-US"                        // English (United States)
        case fr_BE = "fr-BE"                        // French (Belgium)
        case fr_CA = "fr-CA"                        // French (Canada)
        case fr_FR = "fr-FR"                        // French (France)
        case fr_LU = "fr-LU"                        // French (Luxembourg)
        case fr_CH = "fr-CH"                        // French (Switzerland)
        case de_AT = "de-AT"                        // German (Austria)
        case de_DE = "de-DE"                        // German (Germany)
        case de_LI = "de-LI"                        // German (Liechtenstein)
        case de_LU = "de-LU"                        // German (Luxembourg)
        case de_CH = "de-CH"                        // German (Switzerland)
        case it_CH = "it-CH"                        // Italian (Switzerland)
        case it_IT = "it-IT"                        // Italian (Italy)
        case pt_BR = "pt-BR"                        // Portuguese (Brazil)
        case pt_PT = "pt-PT"                        // Portuguese (Portugal)
        case ro_MD = "ro-MD"                        // Romanian (Republic of Moldova)
        case ro_RO = "ro-RO"                        // Romanian (Romania)
        case ru_MD = "ru-MD"                        // Russian (Republic of Moldova)
        case ru_RU = "ru-RU"                        // Russian (Russia)
        case es_AR = "es-AR"                        // Spanish (Argentina)
        case es_BO = "es-BO"                        // Spanish (Bolivia)
        case es_CL = "es-CL"                        // Spanish (Chile)
        case es_CO = "es-CO"                        // Spanish (Colombia)
        case es_CR = "es-CR"                        // Spanish (Costa Rica)
        case es_DO = "es-DO"                        // Spanish (Dominican Republic)
        case es_EC = "es-EC"                        // Spanish (Ecuador)
        case es_SV = "es-SV"                        // Spanish (El Salvador)
        case es_GT = "es-GT"                        // Spanish (Guatemala)
        case es_HN = "es-HN"                        // Spanish (Honduras)
        case es_MX = "es-MX"                        // Spanish (Mexico)
        case es_NI = "es-NI"                        // Spanish (Nicaragua)
        case es_ES = "es-ES"                        // Spanish (Spain)
        case es_PA = "es-PA"                        // Spanish (Panama)
        case es_PY = "es-PY"                        // Spanish (Paraguay)
        case es_PE = "es-PE"                        // Spanish (Peru)
        case es_PR = "es-PR"                        // Spanish (Puerto Rico)
        case es_UY = "es-UY"                        // Spanish (Uruguay)
        case es_VE = "es-VE"                        // Spanish (Venezuela)
        case sv_FI = "sv-FI"                        // Swedish (Finland)
        case sv_SE = "sv-SE"                        // Swedish (Sweden)
    }
}

extension KernelLocalisation.ISO639_1 {
    public func countrySpecificVariants() -> [CountrySpecific] {
        switch self {
        case .ar: [ 
            .ar_DZ, .ar_BH, .ar_EG, .ar_IQ, .ar_JO, .ar_KW, .ar_LB, .ar_LY,
            .ar_MA, .ar_OM, .ar_QA, .ar_SA, .ar_SY, .ar_TN, .ar_AE, .ar_YE
        ]
        case .zh: [.zh_HK, .zh_CN, .zh_SG, .zh_TW]
        case .nl: [.nl_BE, .nl_NL]
        case .en: [
            .en_AU, .en_BZ, .en_CA, .en_IE, .en_JM, .en_NZ, .en_ZA, .en_TT,
            .en_GB, .en_US
        ]
        case .fr: [.fr_BE, .fr_CA, .fr_FR, .fr_LU, .fr_CH]
        case .de: [.de_AT, .de_DE, .de_LI, .de_LU, .de_CH]
        case .it: [.it_CH, .it_IT]
        case .pt: [.pt_BR, .pt_PT]
        case .ro: [.ro_MD, .ro_RO]
        case .ru: [.ru_MD, .ru_RU]
        case .es: [
            .es_AR, .es_BO, .es_CL, .es_CO, .es_CR, .es_DO, .es_EC, .es_SV,
            .es_GT, .es_HN, .es_MX, .es_NI, .es_ES, .es_PA, .es_PY, .es_PE,
            .es_PR, .es_UY, .es_VE
        ]
        case .sv: [.sv_FI, .sv_SE]
        default: []
        }
    }
}

extension KernelLocalisation.ISO639_1.CountrySpecific {
    public func fallback() -> KernelLocalisation.ISO639_1 {
        switch self {
        case
            .ar_DZ, .ar_BH, .ar_EG, .ar_IQ, .ar_JO, .ar_KW, .ar_LB, .ar_LY,
            .ar_MA, .ar_OM, .ar_QA, .ar_SA, .ar_SY, .ar_TN, .ar_AE, .ar_YE
            : .ar
        case
            .zh_HK, .zh_CN, .zh_SG, .zh_TW
            : .zh
        case
            .nl_BE, .nl_NL
            : .nl
        case
            .en_AU, .en_BZ, .en_CA, .en_IE, .en_JM, .en_NZ, .en_ZA, .en_TT,
            .en_GB, .en_US
            : .en
        case
            .fr_BE, .fr_CA, .fr_FR, .fr_LU, .fr_CH
            : .fr
        case
            .de_AT, .de_DE, .de_LI, .de_LU, .de_CH
            : .de
        case 
            .it_CH, .it_IT
            : .it
        case 
            .pt_BR, .pt_PT
            : .pt
        case 
            .ro_MD, .ro_RO
            : .ro
        case 
            .ru_MD, .ru_RU
            : .ru
        case
            .es_AR, .es_BO, .es_CL, .es_CO, .es_CR, .es_DO, .es_EC, .es_SV,
            .es_GT, .es_HN, .es_MX, .es_NI, .es_ES, .es_PA, .es_PY, .es_PE,
            .es_PR, .es_UY, .es_VE
            : .es
        case
            .sv_FI, .sv_SE
            : .sv
        }
    }
}
