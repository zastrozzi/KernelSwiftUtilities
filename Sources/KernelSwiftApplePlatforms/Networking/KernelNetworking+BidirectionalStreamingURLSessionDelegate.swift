//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 27/03/2025.
//

import HTTPTypes
import KernelSwiftCommon
#if canImport(Darwin)
import Foundation

extension KernelNetworking {
    final class BidirectionalStreamingURLSessionDelegate: NSObject, URLSessionTaskDelegate, URLSessionDataDelegate {
        
        let requestBody: HTTPBody?
        var hasAlreadyIteratedRequestBody: Bool
        
        var hasSuspendedURLSessionTask: KernelSwiftCommon.Concurrency.Core.StreamLock.LockedValueBox<Bool>
        let requestStreamBufferSize: Int
        var requestStream: HTTPBodyOutputStreamBridge?
        
        typealias ResponseContinuation = CheckedContinuation<URLResponse, any Error>
        var responseContinuation: ResponseContinuation?
        
        typealias ResponseBodyStream = KernelSwiftCommon.Concurrency.BufferedStream<HTTPBody.ByteChunk>
        var responseBodyStream: ResponseBodyStream
        var responseBodyStreamSource: ResponseBodyStream.Source
        
        let callbackLock = KernelSwiftCommon.Concurrency.Core.StreamLock()
        
        init(requestBody: HTTPBody?, requestStreamBufferSize: Int, responseStreamWatermarks: (low: Int, high: Int)) {
            self.requestBody = requestBody
            self.hasAlreadyIteratedRequestBody = false
            self.hasSuspendedURLSessionTask = KernelSwiftCommon.Concurrency.Core.StreamLock.LockedValueBox(false)
            self.requestStreamBufferSize = requestStreamBufferSize
            (self.responseBodyStream, self.responseBodyStreamSource) = ResponseBodyStream.makeStream(
                backPressureStrategy: .customWatermark(
                    low: responseStreamWatermarks.low,
                    high: responseStreamWatermarks.high,
                    waterLevelForElement: { $0.count }
                )
            )
        }
        
        func urlSession(_ session: URLSession, needNewBodyStreamForTask task: URLSessionTask) async -> InputStream? {
            callbackLock.withLock {
                KernelNetworking.logger.debug("Task delegate: needNewBodyStreamForTask")
                if hasAlreadyIteratedRequestBody {
                    guard requestBody!.iterationBehaviour == .multiple else {
                        KernelNetworking.logger.debug("Task delegate: Cannot rewind request body, cancelling task")
                        task.cancel()
                        return nil
                    }
                }
                hasAlreadyIteratedRequestBody = true
                
                let (inputStream, outputStream) = createStreamPair(withBufferSize: requestStreamBufferSize)
                
                requestStream = HTTPBodyOutputStreamBridge(outputStream, requestBody!)
                
                return inputStream
            }
        }
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
            callbackLock.withLock {
                KernelNetworking.logger.debug("Task delegate: didReceive data (numBytes: \(data.count))")
                do {
                    switch try responseBodyStreamSource.write(contentsOf: CollectionOfOne(ArraySlice(data))) {
                    case .produceMore: break
                    case .enqueueCallback(let callbackToken):
                        let shouldActuallyEnqueueCallback = hasSuspendedURLSessionTask.withLockedValue {
                            hasSuspendedURLSessionTask in
                            if hasSuspendedURLSessionTask {
                                KernelNetworking.logger.debug("Task delegate: already suspended task, not enqueing another writer callback")
                                return false
                            }
                            KernelNetworking.logger.debug("Task delegate: response stream backpressure, suspending task and enqueing callback")
                            dataTask.suspend()
                            hasSuspendedURLSessionTask = true
                            return true
                        }
                        if shouldActuallyEnqueueCallback {
                            responseBodyStreamSource.enqueueCallback(callbackToken: callbackToken) { result in
                                self.hasSuspendedURLSessionTask.withLockedValue { hasSuspendedURLSessionTask in
                                    switch result {
                                    case .success:
                                        KernelNetworking.logger.debug("Task delegate: response stream callback, resuming task")
                                        dataTask.resume()
                                        hasSuspendedURLSessionTask = false
                                    case .failure(let error):
                                        KernelNetworking.logger.debug("Task delegate: response stream callback, cancelling task, error: \(error)")
                                        dataTask.cancel()
                                    }
                                }
                            }
                        }
                    }
                } catch {
                    KernelNetworking.logger.debug("Task delegate: response stream consumer terminated, cancelling task")
                    dataTask.cancel()
                }
            }
        }
        
        func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async
        -> URLSession.ResponseDisposition
        {
            callbackLock.withLock {
                KernelNetworking.logger.debug("Task delegate: didReceive response")
                responseContinuation?.resume(returning: response)
                responseContinuation = nil
                return .allow
            }
        }
        
        func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
            callbackLock.withLock {
                KernelNetworking.logger.debug("Task delegate: didCompleteWithError (error: \(String(describing: error)))")
                responseBodyStreamSource.finish(throwing: error)
                if let error {
                    responseContinuation?.resume(throwing: error)
                    responseContinuation = nil
                }
            }
        }
    }
}

extension KernelNetworking.BidirectionalStreamingURLSessionDelegate: @unchecked Sendable {}

private func createStreamPair(withBufferSize bufferSize: Int) -> (InputStream, OutputStream) {
    var inputStream: InputStream?
    var outputStream: OutputStream?
    Stream.getBoundStreams(withBufferSize: bufferSize, inputStream: &inputStream, outputStream: &outputStream)
    guard let inputStream, let outputStream else { fatalError("getBoundStreams did not return non-nil streams") }
    return (inputStream, outputStream)
}

#endif
