//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import Foundation
import HTTPTypes
import KernelSwiftCommon

@available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
extension URLSession {
    func bidirectionalStreamingRequest(
        for request: HTTPRequest,
        baseURL: URL,
        requestBody: KernelNetworking.HTTPBody?,
        requestStreamBufferSize: Int,
        responseStreamWatermarks: (low: Int, high: Int)
    ) async throws -> (HTTPResponse, KernelNetworking.HTTPBody?) {
        let urlRequest = try URLRequest(request, baseURL: baseURL)
        let task: URLSessionTask
        if requestBody != nil {
            task = uploadTask(withStreamedRequest: urlRequest)
        } else {
            task = dataTask(with: urlRequest)
        }
        return try await withTaskCancellationHandler {
            try Task.checkCancellation()
            let delegate = KernelNetworking.BidirectionalStreamingURLSessionDelegate(
                requestBody: requestBody,
                requestStreamBufferSize: requestStreamBufferSize,
                responseStreamWatermarks: responseStreamWatermarks
            )
            let response = try await withCheckedThrowingContinuation { continuation in
                delegate.responseContinuation = continuation
                task.delegate = delegate
                task.resume()
            }
            let responseBody = KernelNetworking.HTTPBody(
                delegate.responseBodyStream,
                length: .init(from: response),
                iterationBehaviour: .single
            )
            try Task.checkCancellation()
            return (try HTTPResponse(response), responseBody)
        } onCancel: {
            KernelNetworking.logger.debug("Concurrency task cancelled, cancelling URLSession task.")
            task.cancel()
        }
    }
}
