//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 24/08/2023.
//

import Foundation

#if os(iOS)
import UIKit
public typealias BKTextContentType = UITextContentType
#endif

#if os(macOS)
import AppKit
public typealias BKTextContentType = NSTextContentType
#endif
