//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 08/09/2023.
//

import Foundation
import KernelSwiftCommon

public protocol TypeReturnable {
    associatedtype ReturnType
    func returnType() -> ReturnType
}

public enum WellKnownResourceIdentifier: LabelRepresentable, TypeReturnable {
    public typealias ReturnType = any Sendable.Type
    
    case acmeChallenge(host: String)
    case amphtml(host: String)
    case appspecific(host: String)
    case ashrae(host: String)
    case assetlinksJSON(host: String)
    case brski(host: String)
    case caldav(host: String)
    case carddav(host: String)
    case changePassword(host: String)
    case cmp(host: String)
    case coap(host: String)
    case core(host: String)
    case csaf(host: String)
    case csafAggregator(host: String)
    case csvm(host: String)
    case didJSON(host: String)
    case didConfigurationJSON(host: String)
    case dnt(host: String)
    case dntPolicyTxt(host: String)
    case dots(host: String)
    case ecips(host: String)
    case edhoc(host: String)
    case enterpriseNetworkSecurity(host: String)
    case enterpriseTransportSecurity(host: String)
    case est(host: String)
    case genid(host: String)
    case gpcJSON(host: String)
    case gs1resolver(host: String)
    case hoba(host: String)
    case hostMeta(host: String)
    case hostMetaJSON(host: String)
    case hostingProvider(host: String)
    case httpOpportunistic(host: String)
    case idpProxy(host: String)
    case jmap(host: String)
    case keybaseTxt(host: String)
    case knx(host: String)
    case lookingGlass(host: String)
    case masque(host: String)
    case matrix(host: String)
    case mercure(host: String)
    case mtaStsTxt(host: String)
    case mud(host: String)
    case nfvOAuthServerConfiguration(host: String)
    case ni(host: String)
    case oAuthAuthorizationServer(host: String)
    case openIDConfiguration(host: String)
    case openorg(host: String)
    case oslc(host: String)
    case pkiValidation(host: String)
    case posh(host: String)
    case probingTxt(host: String)
    case pvd(host: String)
    case rd(host: String)
    case reloadConfig(host: String)
    case reputeTemplate(host: String)
    case resourcesync(host: String)
    case sbom(host: String)
    case securityTxt(host: String)
    case sshfp(host: String)
    case stunKey(host: String)
    case thread(host: String)
    case time(host: String)
    case timezone(host: String)
    case torRelay(host: String)
    case trafficAdvice(host: String)
    case trustTxt(host: String)
    case uma2Configuration(host: String)
    case void(host: String)
    case webfinger(host: String)
    case webweaverJSON(host: String)
    case wot(host: String)
    
    public var id: String { label }
    
    public var label: String { host + "/.well-known/" + suffix }
    
    public var host: String {
        switch self {
        case .acmeChallenge(let host): host
        case .amphtml(let host): host
        case .appspecific(let host): host
        case .ashrae(let host): host
        case .assetlinksJSON(let host): host
        case .brski(let host): host
        case .caldav(let host): host
        case .carddav(let host): host
        case .changePassword(let host): host
        case .cmp(let host): host
        case .coap(let host): host
        case .core(let host): host
        case .csaf(let host): host
        case .csafAggregator(let host): host
        case .csvm(let host): host
        case .didJSON(let host): host
        case .didConfigurationJSON(let host): host
        case .dnt(let host): host
        case .dntPolicyTxt(let host): host
        case .dots(let host): host
        case .ecips(let host): host
        case .edhoc(let host): host
        case .enterpriseNetworkSecurity(let host): host
        case .enterpriseTransportSecurity(let host): host
        case .est(let host): host
        case .genid(let host): host
        case .gpcJSON(let host): host
        case .gs1resolver(let host): host
        case .hoba(let host): host
        case .hostMeta(let host): host
        case .hostMetaJSON(let host): host
        case .hostingProvider(let host): host
        case .httpOpportunistic(let host): host
        case .idpProxy(let host): host
        case .jmap(let host): host
        case .keybaseTxt(let host): host
        case .knx(let host): host
        case .lookingGlass(let host): host
        case .masque(let host): host
        case .matrix(let host): host
        case .mercure(let host): host
        case .mtaStsTxt(let host): host
        case .mud(let host): host
        case .nfvOAuthServerConfiguration(let host): host
        case .ni(let host): host
        case .oAuthAuthorizationServer(let host): host
        case .openIDConfiguration(let host): host
        case .openorg(let host): host
        case .oslc(let host): host
        case .pkiValidation(let host): host
        case .posh(let host): host
        case .probingTxt(let host): host
        case .pvd(let host): host
        case .rd(let host): host
        case .reloadConfig(let host): host
        case .reputeTemplate(let host): host
        case .resourcesync(let host): host
        case .sbom(let host): host
        case .securityTxt(let host): host
        case .sshfp(let host): host
        case .stunKey(let host): host
        case .thread(let host): host
        case .time(let host): host
        case .timezone(let host): host
        case .torRelay(let host): host
        case .trafficAdvice(let host): host
        case .trustTxt(let host): host
        case .uma2Configuration(let host): host
        case .void(let host): host
        case .webfinger(let host): host
        case .webweaverJSON(let host): host
        case .wot(let host): host
        }
    }
    
    
    public var suffix: String {
        switch self {
        case .acmeChallenge: "acme-challenge"
        case .amphtml: "amphtml"
        case .appspecific: "appspecific"
        case .ashrae: "ashrae"
        case .assetlinksJSON: "assetlinks.json"
        case .brski: "brski"
        case .caldav: "caldav"
        case .carddav: "carddav"
        case .changePassword: "change-password"
        case .cmp: "cmp"
        case .coap: "coap"
        case .core: "core"
        case .csaf: "csaf"
        case .csafAggregator: "csaf-aggregator"
        case .csvm: "csvm"
        case .didJSON: "did.json"
        case .didConfigurationJSON: "did-configuration.json"
        case .dnt: "dnt"
        case .dntPolicyTxt: "dnt-policy.txt"
        case .dots: "dots"
        case .ecips: "ecips"
        case .edhoc: "edhoc"
        case .enterpriseNetworkSecurity: "enterprise-network-security"
        case .enterpriseTransportSecurity: "enterprise-transport-security"
        case .est: "est"
        case .genid: "genid"
        case .gpcJSON: "gpc.json"
        case .gs1resolver: "gs1resolver"
        case .hoba: "hoba"
        case .hostMeta: "host-meta"
        case .hostMetaJSON: "host-meta.json"
        case .hostingProvider: "hosting-provider"
        case .httpOpportunistic: "http-opportunistic"
        case .idpProxy: "idp-proxy"
        case .jmap: "jmap"
        case .keybaseTxt: "keybase.txt"
        case .knx: "knx"
        case .lookingGlass: "looking-glass"
        case .masque: "masque"
        case .matrix: "matrix"
        case .mercure: "mercure"
        case .mtaStsTxt: "mta-sts.txt"
        case .mud: "mud"
        case .nfvOAuthServerConfiguration: "nfv-oauth-server-configuration"
        case .ni: "ni"
        case .oAuthAuthorizationServer: "oauth-authorization-server"
        case .openIDConfiguration: "openid-configuration"
        case .openorg: "openorg"
        case .oslc: "oslc"
        case .pkiValidation: "pki-validation"
        case .posh: "posh"
        case .probingTxt: "probing.txt"
        case .pvd: "pvd"
        case .rd: "rd"
        case .reloadConfig: "reload-config"
        case .reputeTemplate: "repute-template"
        case .resourcesync: "resourcesync"
        case .sbom: "sbom"
        case .securityTxt: "security.txt"
        case .sshfp: "sshfp"
        case .stunKey: "stun-key"
        case .thread: "thread"
        case .time: "time"
        case .timezone: "timezone"
        case .torRelay: "tor-relay"
        case .trafficAdvice: "traffic-advice"
        case .trustTxt: "trust.txt"
        case .uma2Configuration: "uma2-configuration"
        case .void: "void"
        case .webfinger: "webfinger"
        case .webweaverJSON: "webweaver.json"
        case .wot: "wot"
        }
    }
    
    public var documentType: any (Codable & Sendable).Type {
        switch self {
        case .openIDConfiguration: return OIDCProviderMetadata.self
        default: return String.self
        }
    }
    
    public func returnType() -> ReturnType {
        switch self {
        case .openIDConfiguration: return OIDCProviderMetadata.self
        default: return String.self
        }
    }
}

extension WellKnownResourceIdentifier {
    public static let allCases: [WellKnownResourceIdentifier] = [
        .acmeChallenge(host: ""),
        .amphtml(host: ""),
        .appspecific(host: ""),
        .ashrae(host: ""),
        .assetlinksJSON(host: ""),
        .brski(host: ""),
        .caldav(host: ""),
        .carddav(host: ""),
        .changePassword(host: ""),
        .cmp(host: ""),
        .coap(host: ""),
        .core(host: ""),
        .csaf(host: ""),
        .csafAggregator(host: ""),
        .csvm(host: ""),
        .didJSON(host: ""),
        .didConfigurationJSON(host: ""),
        .dnt(host: ""),
        .dntPolicyTxt(host: ""),
        .dots(host: ""),
        .ecips(host: ""),
        .edhoc(host: ""),
        .enterpriseNetworkSecurity(host: ""),
        .enterpriseTransportSecurity(host: ""),
        .est(host: ""),
        .genid(host: ""),
        .gpcJSON(host: ""),
        .gs1resolver(host: ""),
        .hoba(host: ""),
        .hostMeta(host: ""),
        .hostMetaJSON(host: ""),
        .hostingProvider(host: ""),
        .httpOpportunistic(host: ""),
        .idpProxy(host: ""),
        .jmap(host: ""),
        .keybaseTxt(host: ""),
        .knx(host: ""),
        .lookingGlass(host: ""),
        .masque(host: ""),
        .matrix(host: ""),
        .mercure(host: ""),
        .mtaStsTxt(host: ""),
        .mud(host: ""),
        .nfvOAuthServerConfiguration(host: ""),
        .ni(host: ""),
        .oAuthAuthorizationServer(host: ""),
        .openIDConfiguration(host: ""),
        .openorg(host: ""),
        .oslc(host: ""),
        .pkiValidation(host: ""),
        .posh(host: ""),
        .probingTxt(host: ""),
        .pvd(host: ""),
        .rd(host: ""),
        .reloadConfig(host: ""),
        .reputeTemplate(host: ""),
        .resourcesync(host: ""),
        .sbom(host: ""),
        .securityTxt(host: ""),
        .sshfp(host: ""),
        .stunKey(host: ""),
        .thread(host: ""),
        .time(host: ""),
        .timezone(host: ""),
        .torRelay(host: ""),
        .trafficAdvice(host: ""),
        .trustTxt(host: ""),
        .uma2Configuration(host: ""),
        .void(host: ""),
        .webfinger(host: ""),
        .webweaverJSON(host: ""),
        .wot(host: "")
    ]
}
