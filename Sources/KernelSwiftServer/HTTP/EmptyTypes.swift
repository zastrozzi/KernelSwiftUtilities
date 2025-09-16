//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 28/10/2022.
//

import Foundation
import Vapor
import KernelSwiftCommon

extension KernelSwiftCommon.Networking.HTTP.EmptyPath: AsyncResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyPath: AsyncRequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyPath: ResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyPath: RequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyPath: _KernelSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyPath: _KernelAbstractSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyPath: Content, OpenAPIEncodableSampleable, OpenAPIContent {}

extension KernelSwiftCommon.Networking.HTTP.EmptyQuery: AsyncResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyQuery: AsyncRequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyQuery: ResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyQuery: RequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyQuery: _KernelSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyQuery: _KernelAbstractSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyQuery: Content, OpenAPIEncodableSampleable, OpenAPIContent {}

extension KernelSwiftCommon.Networking.HTTP.EmptyRequest: AsyncResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyRequest: AsyncRequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyRequest: ResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyRequest: RequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyRequest: _KernelSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyRequest: _KernelAbstractSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyRequest: Content, OpenAPIEncodableSampleable, OpenAPIContent {}

extension KernelSwiftCommon.Networking.HTTP.EmptyResponse: AsyncResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyResponse: AsyncRequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyResponse: ResponseEncodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyResponse: RequestDecodable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyResponse: _KernelSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyResponse: _KernelAbstractSampleable {}
extension KernelSwiftCommon.Networking.HTTP.EmptyResponse: Content, OpenAPIEncodableSampleable, OpenAPIContent {}
