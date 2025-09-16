//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 26/11/2023.
//

import Foundation
import KernelSwiftCommon

//extension DocumentationController {
//    public func makeOpenAPIDocsHTML(
//        title: String,
//        contentColor: KernelSwiftCommon.RGBAColor,
//        styles: String,
//        theme: String,
//        path: String
//    ) -> String {
//"""
//<!DOCTYPE html>
//<html>
//    <head>
//        <title>\(title)</title>
//        <meta charset="utf-8"/>
//        <meta name="viewport" content="width=device-width, initial-scale=1">
//        <meta name="theme-color" content="\(contentColor.toHexString(withAlpha: false))">
//        <link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
//        <script src="https://cdn.jsdelivr.net/npm/redoc@2.0.0-rc.55/bundles/redoc.standalone.min.js"> </script>
//        <script src="https://cdn.jsdelivr.net/npm/redoc-try@1.4.10/dist/try.js"></script>
//        
//        <style>\(styles)</style>
//    </head>
//    <body>
//        <div id="redoc-container" class="background-gradient" show-object-schema-examples sort-tags-alphabetically="true" sort-operations-alphabetically="true" sort-props-alphabetically="true" theme='\(theme)'></div>
//          
//          <script>
//            initTry({
//              openApi: `\(path)`,
//              redocOptions: {scrollYOffset: 50}
//            })
//          </script>
//    </body>
//</html>
//"""
//    }
//}

extension DocumentationController {
    public func makeOpenAPIDocsHTML(
        title: String,
        contentColor: KernelSwiftCommon.RGBAColor,
        styles: String,
        theme: String,
        path: String
    ) -> String {
"""
<!DOCTYPE html>
<html>
    <head>
        <title>\(title)</title>
        <meta charset="utf-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta name="theme-color" content="\(contentColor.toHexString(withAlpha: false))">
        <link href="https://fonts.googleapis.com/css2?family=DM+Mono:wght@300;400;500&display=swap" rel="stylesheet">
        <script type="text/javascript" src="https://cdn.jsdelivr.net/npm/redoc-try-it-out/dist/try-it-out.min.js"></script>
        
        <style>\(styles)</style>
    </head>
    <body>
        <div id="openapi_docs_content" class="background-gradient" show-object-schema-examples sort-tags-alphabetically="true" sort-operations-alphabetically="true" sort-props-alphabetically="true" theme='\(theme)'></div>
        <script>
            RedocTryItOut.init('\(path)', {}, document.getElementById('openapi_docs_content'))
        </script>
    </body>
</html>
"""
    }
}

extension DocumentationController {
    public static func makeOpenAPIDocsScalarHTML(
        title: String,
        contentColor: KernelSwiftCommon.RGBAColor,
        path: String
    ) -> String {
"""
<!doctype html>
<html>
  <head>
    <title>\(title)</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="theme-color" content="\(contentColor.toHexString(withAlpha: false))">
  </head>

  <body>
    <div id="app"></div>
    <script src="https://cdn.jsdelivr.net/npm/@scalar/api-reference"></script>
    <script>
      Scalar.createApiReference('#app', {
        url: '\(path)',
        // Avoid CORS issues
        proxyUrl: 'https://proxy.scalar.com',
      })
    </script>
  </body>
</html>
"""
    }
}
