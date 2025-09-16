//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 20/10/2023.
//

import Foundation
import KernelSwiftCommon

//extension KernelNumerics.EC.Curve: @retroactive _KernelSampleable {}
//extension KernelNumerics.EC.Curve: @retroactive _KernelAbstractSampleable {}
extension KernelNumerics.EC.Curve: _KernelSampleable {}
extension KernelNumerics.EC.Curve: _KernelAbstractSampleable {}
extension KernelNumerics.EC.Curve: OpenAPIStringEnumSampleable {}
