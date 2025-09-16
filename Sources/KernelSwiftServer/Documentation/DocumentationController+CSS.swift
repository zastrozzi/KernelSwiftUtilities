//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/11/2023.
//

import KernelSwiftCommon

extension DocumentationController {
    public func darkStyles(backgroundColor: KernelSwiftCommon.RGBAColor) -> String {
"""
body { margin: 0; padding: 0; }
.background-gradient {
    background: linear-gradient(
        180deg,
        \(backgroundColor.toHexString(withAlpha: false)) 0%,
        \(backgroundColor.darker(by: 20).toHexString(withAlpha: false)) 100%
    ) !important;
    height: 100vh !important;
    overflow: scroll !important;
}
.redoc-wrap > div > div > svg { color: \(backgroundColor.toHexString(withAlpha: false)) !important; }
.react-tabs__tab-panel { background-color: rgba(0,0,0,0.2) !important; border-radius: 10px; }
.react-tabs__tab { background-color: rgba(0,0,0,0.2) !important; }
.react-tabs__tab--selected { background-color: rgba(0,0,0,0.4) !important; }
.menu-content {
    border-radius: 15px;
    top: 10px !important;
    left: 10px !important;
    right: 10px !important;
    margin-right: 10px !important;
    max-height: calc(100vh - 20px) !important;
    max-width: calc(100vw - 20px) !important;
    box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.15), 0 6px 20px 0 rgba(0, 0, 0, 0.1) !important;
    background: linear-gradient(
        180deg,
        \(backgroundColor.lighter(by: 5).toHexString(withAlpha: false)) 0%,
        \(backgroundColor.darker(by: 15).toHexString(withAlpha: false)) 100%
    ) !important;
}
table > tbody > tr > td > div { background-color: transparent !important; }
.security-details > tbody > tr { background-color: transparent !important; }
div > span > span > i { color: black !important; }
.api-content > div > div > div > div > div > div > div > h5 { color: white !important; }
.api-content > div > div > div > div > div > div > div > h5 > span { color: white !important; }
.api-content > div > div > div > div > div > div > h5 { color: white !important; }
.api-content > div > div > div > div > div > div > h5 > span { color: white !important; }
.api-content > div > div > div > div > div > h5 { color: white !important; }
.api-content > div > div > div > div > h5 { color: white !important; }
.api-content > div > div > div > div > h3 { font-weight: 400 !important; }
.api-content > div > div > div > div > div > span > span > i { color: #efefef !important; }
.api-content > div > div > div > div > div { background-color: transparent !important; }
.api-content > div > div > div > h2 { color: white !important; }
.api-content > div > div > div > div > h2 { color: white !important; }
.api-content > div > div > div > h5 { color: white !important; }
.api-content > div > div > div > div > div > span > span > a { color: #efefef !important; }
.api-content > div > div > div > h5 > span { color: #efefef !important; }
.api-content > div > div > div > table > tbody > tr > td > div > div > div > button { background-color: transparent !important; }
.api-content > div > div > div > table > tbody > tr > td > div > div > div > div > div > div > button { background-color: transparent !important; }
.api-content > div > div > div > div > div > div > div[role=button] > div {
    background-color: \(backgroundColor.darker(by: 20).toHexString(withAlpha: false)) !important;
}
.api-content > div > div > div > div > div > div > table > tbody > tr > td > div > table > tbody > tr > td > div > div > div > button {
    background-color: \(backgroundColor.darker(by: 20).toHexString(withAlpha: false)) !important;
}
.api-content > div > div > div > div > div > div > table > tbody > tr > td > div > table > tbody > tr > td > div > div > table > tbody > tr > td > div > div > div > button {
    background-color: \(backgroundColor.darker(by: 20).toHexString(withAlpha: false)) !important;
}
.opblock.is-open { background-color: rgba(0,0,0,0.2) !important; border-radius: 10px !important; padding-top: 5px !important; }
.opblock-section-header { background-color: rgba(0,0,0,0.2) !important; border-radius: 10px !important; padding: 2px 10px 0px 10px !important; min-height: 30px !important; }
.opblock-section-header > .tab-header { align-items: center !important; }
.opblock-title { border-bottom-width: 0px !important; font-weight: 500 !important; color: #ffffffaa !important; }
.opblock select { background-color: transparent !important; }
.execute { font-family: "DM Mono", monospace !important; }
td.parameters-col_description > input[type=text] {
    background-color: rgba(0,0,0,0.2) !important;
    font-size: 12px !important;
    margin-left: 10px !important;
    margin-top: 0px !important;
    float: right;
    border-bottom-width: 0px !important;
    border-radius: 10px !important;
}
td.parameters-col_description > select { margin-top: 0px !important; }
.parameters-col_name > .parameter__in { display: none !important; }
.parameters-col_name > .parameter__name { float: left !important; padding-left: 5px !important; }
.parameters-col_name > .parameter__type { padding-top: 0px !important; margin-left: 15px !important; font-size: 12px !important; }
.parameters-col_name > span { margin: 0px 0px 0px 0px !important; }
.search-input {
    background-color: rgba(0,0,0,0.3) !important;
    border-bottom-width: 0px !important;
    border-radius: 10px !important;
    padding: 10px 10px 10px 35px !important;
    margin-left: 5px !important;
    margin-right: 5px !important;
    width: calc(100% - 10px) !important;
    font-weight: 400 !important;
}
.search-icon { top: 10px !important; }
div[role=search] > i { line-height: 14px !important; top: 16px !important; }
label[role=menuitem] { padding-left: 15px !important; padding-right: 15px !important; align-items: center; font-size: 12px !important; }
label[role=menuitem] > span.operation-type { margin-top: 0px !important; margin-right: 10px !important; }
label[role=menuitem] > span:not(.operation-type) { line-height: 15px !important; }
label[role=menuitem].-depth1:has(+ ul > li > label.-depth2.active) { background-color: #00000022 !important; color: #ffffff !important; font-weight: 500 !important; }
label[role=menuitem].-depth1.active { background-color: #00000033 !important; color: #ffffff !important; font-weight: 500 !important; }
label[role=menuitem].-depth2.active { background-color: #00000033 !important; color: #ffffff !important; font-weight: 500 !important; }
label[role=menuitem]:hover { background-color: #00000033 !important; }
div.menu-content > div.undefined > div > a { display: none !important; }
"""
    }
}
