//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/27/23.
//

import Foundation
import KernelSwiftCommon

extension TesterNetworking: URLSessionDelegate {
    public func urlSession(_ session: URLSession,
                           didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        //Trust the certificate even if not valid
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        
        completionHandler(.useCredential, urlCredential)
    }
}
