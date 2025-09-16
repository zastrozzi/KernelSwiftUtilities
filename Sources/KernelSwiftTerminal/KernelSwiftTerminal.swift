//
//  File.swift
//  
//
//  Created by Jonathan Forbes on 31/10/2023.
//

import Foundation

public enum KernelSwiftTerminal {}

// Application
public typealias KTApplication = KernelSwiftTerminal.Application
public typealias KTControl = KernelSwiftTerminal.Application.Control
public typealias KTWindow = KernelSwiftTerminal.Application.Window

//Model
public typealias KTBinding = KernelSwiftTerminal.Model.Binding
public typealias KTEnvironment = KernelSwiftTerminal.Model.Environment
public typealias KTEnvironmentValues = KernelSwiftTerminal.Model.EnvironmentValues
public typealias KTObservedObject = KernelSwiftTerminal.Model.ObservedObject
public typealias KTState = KernelSwiftTerminal.Model.State

// Style
public typealias KTStyle = KernelSwiftTerminal.Style
public typealias KTColor = KernelSwiftTerminal.Style.Color

// ViewGraph
public typealias KTViewBuilder = KernelSwiftTerminal.ViewGraph.ViewBuilder

// Views
public typealias KTView = KernelSwiftTerminal.View
public typealias KTEmptyView = KernelSwiftTerminal.Views.EmptyView
public typealias KTVStack = KernelSwiftTerminal.Views.VStack
public typealias KTHStack = KernelSwiftTerminal.Views.HStack
public typealias KTForEach = KernelSwiftTerminal.Views.ForEach
public typealias KTGroup = KernelSwiftTerminal.Views.Group
public typealias KTScrollView = KernelSwiftTerminal.Views.ScrollView
public typealias KTSpacer = KernelSwiftTerminal.Views.Spacer

// Input
public typealias KTButton = KernelSwiftTerminal.Views.Button
public typealias KTTextField = KernelSwiftTerminal.Views.TextField

// Data
public typealias KTText = KernelSwiftTerminal.Views.Text
public typealias KTProgressView = KernelSwiftTerminal.Views.ProgressView
