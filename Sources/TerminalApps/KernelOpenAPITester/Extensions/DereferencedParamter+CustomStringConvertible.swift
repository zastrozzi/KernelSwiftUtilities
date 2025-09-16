//
//  File.swift
//  
//
//  Created by Jimmy Hough Jr on 11/1/23.
//

import Foundation
import OpenAPIKit30
import KernelSwiftCommon

extension DereferencedParameter: CustomStringConvertible {
    public var description: String {
        """
           name : \(self.name),
           required : \(self.required),
           
        """
    }
}
