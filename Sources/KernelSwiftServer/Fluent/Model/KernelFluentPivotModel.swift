//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 16/06/2024.
//

import KernelSwiftCommon
import Vapor
import Fluent

public protocol KernelFluentPivotModel: Model, Sendable {}
public protocol KernelFluentNamespacedPivotModel: KernelFluentNamespacedModel, KernelFluentPivotModel {}
