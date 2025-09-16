//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/11/2023.
//

import KernelSwiftCommon

extension DocumentationController {
    public func makeDarkTheme(contentColor: KernelSwiftCommon.RGBAColor) -> String {
"""
{
    "spacing": {
        "unit": 5,
        "sectionHorizontal": 20,
        "sectionVertical": 20
    },
    "breakpoints": {
        "small": "50rem",
        "medium": "90rem",
        "large": "105rem"
    },
    "codeBlock": {
        "borderRadius": "8"
    },
    "typography": {
        "fontSize": "14px",
        "fontFamily": "DM Mono, monospaced",
        "fontWeightRegular": "400",
        "fontWeightBold": "500",
        "fontWeightLight": "300",
        "optimizeSpeed": true,
        "smoothing": "antialiased",
        "headings": {
            "fontFamily": "DM Mono, monospaced",
            "fontWeight": "300",
            "lineHeight": "1.2em"
        },
        "code": {
            "fontWeight": "400",
            "color": "rgba(92, 62, 189, 1)",
            "wrap": true
        },
        "links": {
            "color": "#45586e",
            "visited": "rgba(246, 20, 63, 1)",
            "hover": "#fa768f"
        }
    },
    "colors": {
        "tonalOffset": "0.2",
        "error": {
            "main": "rgba(244, 67, 54, 1)"
        },
        "accent": {
            "main": "rgba(246, 255, 255, 1)",
            "light": "rgba(246, 255, 255, 0.42)",
            "dark": "rgba(246, 255, 255, 0.42)"
        },
        "primary": {
            "main": "rgba(255, 255, 255, 1)",
            "light": "rgba(246, 255, 255, 0.42)",
            "dark": "rgba(246, 255, 255, 0.42)"
        },
        "secondary": {
            "main": "rgba(255, 255, 255, 0.7)",
            "light": "rgba(246, 255, 255, 0.42)",
            "contrastText": "rgba(246, 255, 255, 0.9)"
        },
        "text": {
            "primary": "rgba(255, 255, 255, 0.5)",
            "secondary": "rgba(246, 255, 255, 0.82)",
            "light": "rgba(246, 255, 255, 0.82)"
        },
        "success": {
            "main": "rgba(246, 255, 255, 1)",
            "light": "rgba(246, 255, 255, 0.9)"
        },
        "http": {
            "get": "rgba(0, 200, 219, 1)",
            "post": "rgba(28, 184, 65, 1)",
            "put": "rgba(255, 187, 0, 1)",
            "delete": "rgba(254, 39, 35, 1)"
        }
    },
    "sidebar": {
        "width": "320px",
        "backgroundColor": "\(contentColor.toHexString(withAlpha: false))",
        "textColor": "#ffffffcc",
        "activeTextColor": "#ffffff !important"
    },
    "rightPanel": {
        "backgroundColor": "rgba(0, 0, 0, 0)",
        "width": "45%",
        "textColor": "#ffffff"
    }
}
"""
    }
    
    public func makeLightTheme(contentColor: KernelSwiftCommon.RGBAColor) -> String {
"""
{
    "spacing": {
        "unit": 5,
        "sectionHorizontal": 20,
        "sectionVertical": 20
    },
    "breakpoints": {
        "small": "50rem",
        "medium": "90rem",
        "large": "105rem"
    },
    "codeBlock": {
        "borderRadius": "8"
    },
    "typography": {
        "fontSize": "14px",
        "fontFamily": "DM Mono, monospaced",
        "fontWeightRegular": "400",
        "fontWeightBold": "500",
        "fontWeightLight": "300",
        "optimizeSpeed": true,
        "smoothing": "antialiased",
        "headings": {
            "fontFamily": "DM Mono, monospaced",
            "fontWeight": "300",
            "lineHeight": "1.2em"
        },
        "code": {
            "fontWeight": "400",
            "color": "rgba(92, 62, 189, 1)",
            "wrap": true
        },
        "links": {
            "color": "#45586e",
            "visited": "rgba(246, 20, 63, 1)",
            "hover": "#fa768f"
        }
    },
    "colors": {
        "tonalOffset": "0.2",
        "error": {
            "main": "rgba(244, 67, 54, 1)"
        },
        "accent": {
            "main": "rgba(9, 0, 0, 1)",
            "light": "rgba(9, 0, 0, 0.42)",
            "dark": "rgba(9, 0, 0, 0.42)"
        },
        "primary": {
            "main": "rgba(0, 0, 0, 1)",
            "light": "rgba(9, 0, 0, 0.42)",
            "dark": "rgba(9, 0, 0, 0.42)"
        },
        "secondary": {
            "main": "rgba(0, 0, 0, 0.7)",
            "light": "rgba(9, 0, 0, 0.42)",
            "contrastText": "rgba(9, 0, 0, 0.9)"
        },
        "text": {
            "primary": "rgba(0, 0, 0, 0.5)",
            "secondary": "rgba(9, 0, 0, 0.82)",
            "light": "rgba(9, 0, 0, 0.82)"
        },
        "success": {
            "main": "rgba(9, 0, 0, 1)",
            "light": "rgba(9, 0, 0, 0.9)"
        },
        "http": {
            "get": "rgba(0, 200, 219, 1)",
            "post": "rgba(28, 184, 65, 1)",
            "put": "rgba(255, 187, 0, 1)",
            "delete": "rgba(254, 39, 35, 1)"
        }
    },
    "sidebar": {
        "width": "320px",
        "backgroundColor": "\(contentColor.toHexString(withAlpha: false))",
        "textColor": "#000000cc",
        "activeTextColor": "#000000 !important"
    },
    "rightPanel": {
        "backgroundColor": "rgba(0, 0, 0, 0)",
        "width": "45%",
        "textColor": "#000000"
    }
}
"""
    }
}
