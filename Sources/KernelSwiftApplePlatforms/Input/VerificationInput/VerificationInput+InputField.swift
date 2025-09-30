//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 17/05/2025.
//

import SwiftUI

extension VerificationInput {
    public struct InputField: View {
        @Binding public var value: String
        public var codeType: CodeType
        public var style: InputFieldStyle
        public var onChange: (String) async -> InputState
        
        public var activeCellColor: Color
        public var inactiveCellColor: Color
        public var validCellColor: Color
        public var invalidCellColor: Color
        
        @State private var state: InputState = .typing
        @State private var invalidTrigger: Bool = false
        @FocusState private var isActive: Bool
        @State private var attachmentAnchor: UnitPoint = .center
        @State private var showPastePopover: Bool = false
        
        public init(
            _ value: Binding<String>,
            codeType: CodeType,
            style: InputFieldStyle = .roundedBorder,
            activeCellColor: Color = .primary,
            inactiveCellColor: Color = .gray,
            validCellColor: Color = .green,
            invalidCellColor: Color = .red,
            onChange: @escaping (String) async -> InputState
        ) {
            self._value = value
            self.codeType = codeType
            self.style = style
            self.onChange = onChange
            self.activeCellColor = activeCellColor
            self.inactiveCellColor = inactiveCellColor
            self.validCellColor = validCellColor
            self.invalidCellColor = invalidCellColor
        }
        
        public var body: some View {
            HStack(spacing: style == .roundedBorder ? 6 : 10) {
                ForEach(0..<codeType.rawValue, id: \.self) { index in
                    cellView(index).overlay { cellOverlay }
                }
            }
            .animation(.easeInOut(duration: 0.2), value: value)
            .animation(.easeInOut(duration: 0.2), value: isActive)
            .compositingGroup()
            .phaseAnimator([0, 10, -10, 10, -5, 5, 0], trigger: invalidTrigger, content: { content, offset in
                content.offset(x: offset)
            }, animation: { _ in
                .linear(duration: 0.06)
            })
            .background {
                TextField("", text: $value)
                    .focused($isActive)
                #if os(iOS)
                    .keyboardType(.numberPad)
                #endif
                    .textContentType(.oneTimeCode)
                    .mask(alignment: .trailing) {
                        Rectangle()
                            .frame(width: 1, height: 1)
                            .opacity(0.01)
                    }
                    .allowsHitTesting(false)
            }
            .contentShape(.rect)
            .simultaneousGesture(
                TapGesture().onEnded { _ in isActive = true }
            )
            .popover(isPresented: $showPastePopover, attachmentAnchor: .point(attachmentAnchor), arrowEdge: .bottom) {
                pastePopover
            }
            .onChange(of: value) { oldValue, newValue in
                value = String(newValue.prefix(codeType.rawValue))
                Task { @MainActor in
                    state = await onChange(value)
                    if state == .invalid { invalidTrigger.toggle() }
                }
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    Button("Done") {
                        isActive = false
                    }
                    .tint(Color.primary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            .coordinateSpace(.named("VIEW"))
        }
        
        @ViewBuilder
        func cellView(_ index: Int) -> some View {
            Group {
                if style == .roundedBorder {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(borderColor(index), lineWidth: 1.2)
                } else {
                    Rectangle()
                        .fill(borderColor(index))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
            }
            .frame(width: style == .roundedBorder ? 50 : 40, height: 60)
            .overlay {
                let stringValue = string(index)
                
                if stringValue != "" {
                    Text(stringValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .transition(.blurReplace)
                }
            }
        }
        
        @ViewBuilder
        var cellOverlay: some View {
            GeometryReader {
                let frame = $0.frame(in: .named("VIEW"))
                Color.clear
                    .contentShape(.rect)
                    .simultaneousGesture(
                        LongPressGesture(minimumDuration: 0.2)
                            .onEnded { _ in
                                let totalSize = frame.width * CGFloat(codeType.rawValue)
                                let totalSpacing = CGFloat(codeType.rawValue - 1) * (style == .roundedBorder ? 6 : 10)
                                let maxWidth = totalSize + totalSpacing
                                
                                let progress = frame.midX / maxWidth
                                attachmentAnchor = .init(x: progress, y: 0)
                                
                                showPastePopover = true
                            }
                    )
            }
        }
        
        @ViewBuilder
        var pastePopover: some View {
            HStack(spacing: 10) {
                PasteButton(payloadType: String.self) { texts in
                    if let firstText = texts.first {
                        let characterSet = CharacterSet.decimalDigits
                        if
                            firstText.rangeOfCharacter(from: characterSet.inverted) == nil,
                            firstText.count == codeType.rawValue
                        { value = firstText }
                    }
                    
                    showPastePopover = false
                }
                .labelStyle(.titleOnly)
                .tint(Color.primary)
            }
            .padding(5)
            .presentationBackground(.ultraThinMaterial)
            .presentationCompactAdaptation(.popover)
        }
        
        func string(_ index: Int) -> String {
            if value.count > index {
                let startIndex = value.startIndex
                let stringIndex = value.index(startIndex, offsetBy: index)
                return String(value[stringIndex])
            }
            
            return ""
        }
        
        func borderColor(_ index: Int) -> Color {
            switch state {
            case .typing: value.count == index && isActive ? activeCellColor : inactiveCellColor
            case .valid: validCellColor
            case .invalid: invalidCellColor
            }
        }
    }
}
