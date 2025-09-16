//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 10/17/23.
//

import Foundation
import OpenAPIKit30
import Yams

/// Networking class to encapsulate the networking needed to support test plan generatioon and execution.
class TesterNetworking: NSObject, URLSessionTaskDelegate {
    struct VaporError:Codable {
        let error: Bool
        let reason: String
    }
    public typealias Thruple = ( Data, HTTPURLResponse?, URLRequest)
    
    public static let shared = TesterNetworking()
    
    /// Retrieves a YAML file as Data from the provided url.
    public func getYamlDataFrom(url: URL) -> Data {
        let semaphore = DispatchSemaphore(value: 0)
        var yamlData = "".data(using: .utf8)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data {
                yamlData = data
            }else {
                Messager.log(sys:.networking, s: " 💥 Got error \(String(describing: error?.localizedDescription)) ")
            }
            semaphore.signal()
        }
        task.delegate = self
        Messager.log(sys:.networking, s: "Getting data from \(String(describing: task.currentRequest?.httpMethod)) \(String(describing: task.currentRequest)) \(String(describing: task.currentRequest?.httpBody))")

        task.resume()
        
        semaphore.wait()
        return yamlData
    }
    
    /// Gets data from the url and denormalizes the result into a TesterNetowkring.Thruple.
    public func from(url: URL,
                     with req: URLRequest,
                     for id: UUID) -> Thruple {
        
        Messager.log(sys: .networking, s: " <-> ID " + "\(id.uuidString)")
        let semaphore = DispatchSemaphore(value: 0)
        var rData = Data()
        
        let task = URLSession.shared.dataTask(with: req) { (data, response, error) in
            if let d = data {
                rData = d
            }
            semaphore.signal()
        }
        task.delegate = self
        
        if let body = req.httpBody,
           let _ = String(data: body, encoding: .utf8),
           let headers = req.allHTTPHeaderFields {
           let _ = "\(headers)"
               
            Messager.log(sys:.networking, s: " 📤 Getting data from " + "\(String(describing: req.httpMethod!)) " + "to " + "\(req)")
        }else {
            Messager.log(sys:.networking, s:  " 📤 Getting data from " + "\(String(describing: req.httpMethod!)) " + "to " + "\(req)") // + " with headers\n".cyan + "\(String(describing: req.allHTTPHeaderFields!))\n".hex(.grayish) + " and no body.".hex("AA88EE"))
        }
        
        task.resume()
        semaphore.wait()
        
        // TODO: Look into timing network transit time?
        Messager.log(sys:.networking, s: " 📥 Got response . ")
        if let decodedError = try? JSONDecoder().decode(VaporError.self,
                                                        from: rData) {
            Messager.log(sys:.networking, s: " 💥 ERROR " + "->" +  "\n \(decodedError)")
            
            if let body = req.httpBody,
               let bodyString = String(data: body, encoding: .utf8),
               let headers = req.allHTTPHeaderFields {
                let headerString = "\(headers)"
                Messager.log(sys:.networking, s:  headerString)
                Messager.log(sys:.networking, s:  bodyString)
            }
        }else {
            Messager.log(sys:.networking, s:  " ☑︎")
        }
        guard let _ = task.response else { return  Thruple( Data(), nil, task.originalRequest!)}
        
        let thruple = ( rData, task.response as? HTTPURLResponse, task.originalRequest!)
  
        return thruple
    }
}
