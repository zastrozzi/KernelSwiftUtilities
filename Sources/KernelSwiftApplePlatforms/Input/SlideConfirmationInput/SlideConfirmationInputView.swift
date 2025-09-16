//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 26/05/2025.
//

import SwiftUI

public struct SlideConfirmationInputView: View {
    
    @Binding private var isCompleted: Bool
    @State private var animateText: Bool = false
    @State private var offsetX: CGFloat = 0
    @Environment(\.isEnabled) var isEnabled
    
    
    var idleText: String
    var swipeText: String
    var confirmationText: String
    var tintColor: Color
    var foregroundColor: Color
    var height: CGFloat
    var knobPadding: CGFloat
    var textFont: Font
    
    var onSwipe: () -> Void
    
    public init(
        _ isCompleted: Binding<Bool>,
        idleText: String = "Slide to confirm",
        swipeText: String = "Swipe to confirm",
        confirmationText: String = "Confirmed",
        tintColor: Color = .blue,
        foregroundColor: Color = .white,
        height: CGFloat = 65,
        knobPadding: CGFloat = 5,
        textFont: Font = .body.weight(.semibold),
        onSwipe: @escaping () -> Void
    ) {
        self._isCompleted = isCompleted
        self.idleText = idleText
        self.swipeText = swipeText
        self.confirmationText = confirmationText
        self.tintColor = tintColor
        self.foregroundColor = foregroundColor
        self.height = height
        self.knobPadding = knobPadding
        self.textFont = textFont
        self.onSwipe = onSwipe
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let knobSize = size.height
            let maxLimit = size.width - knobSize
            let progress: CGFloat = isCompleted ? 1 : (offsetX / maxLimit)
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(
                        Color.secondarySystemBackground
                            .shadow(.inner(color: .black.opacity(0.2), radius: 10))
                    )
                let extraCapsuleWidth = (size.width - knobSize) * progress
                
                Capsule()
                    .fill(isEnabled ? tintColor.gradient : Color.gray.gradient)
                    .frame(width: knobSize + extraCapsuleWidth, height: knobSize)
                
                leadingTextView(size, progress: progress)
                
                HStack(spacing: 0) {
                    knobView(size, progress: progress, maxLimit: maxLimit)
                        .zIndex(1)
                    shimmerTextView(size, progress: progress)
                }
            }
        }
        .frame(height: isCompleted ? 50 : height)
        .padding(.horizontal)
        .containerRelativeFrame(.horizontal) { value, _ in
            let ratio: CGFloat = isCompleted ? 0.5 : 1
            return value * ratio
        }
        .allowsHitTesting(!isCompleted)
    }
    
    @ViewBuilder
    public func knobView(
        _ size: CGSize,
        progress: CGFloat,
        maxLimit: CGFloat
    ) -> some View {
        Circle()
            .fill(.background)
            .padding(knobPadding)
            .frame(width: size.height, height: size.height)
            .overlay {
                ZStack {
                    Image(systemName: "chevron.right")
                        .opacity(1 - progress)
                        .blur(radius: progress * 10)
                    
                    Image(systemName: "checkmark")
                        .opacity(progress)
                        .blur(radius: (1 - progress) * 10)
                }
                .font(.title3.bold())
            }
            .contentShape(.circle)
            .scaleEffect(isCompleted ? 0.6 : 1, anchor: .center)
            .offset(x: isCompleted ? maxLimit : offsetX)
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offsetX = min(max(value.translation.width, 0), maxLimit)
                    }).onEnded({ value in
                        if offsetX == maxLimit {
                            onSwipe()
                            animateText = false
                            
                            withAnimation(.smooth) {
                                isCompleted = true
                            }
                        } else {
                            withAnimation(.smooth) {
                                offsetX = 0
                            }
                        }
                    })
            )
    }
    
    @ViewBuilder
    public func shimmerTextView(
        _ size: CGSize,
        progress: CGFloat
    ) -> some View {
        Text(isCompleted ? confirmationText : idleText)
            .foregroundStyle(.gray.opacity(0.6))
            .overlay {
                Rectangle()
                    .frame(height: 15)
                    .rotationEffect(.init(degrees: 90))
                    .visualEffect { [animateText] content, proxy in
                        content
                            .offset(x: -proxy.size.width / 1.8)
                            .offset(x: animateText ? proxy.size.width * 1.2 : 0)
                    }
                    .mask(alignment: .leading) {
                        Text(isCompleted ? confirmationText : idleText)
                            .font(textFont)
                    }
                    .blendMode(.softLight)
            }
            .font(textFont)
            .frame(maxWidth: .infinity)
            .padding(.trailing, size.height / 2)
            .mask {
                Rectangle()
                    .scale(x: 1 - progress, anchor: .trailing)
            }
            .frame(height: size.height)
            .task {
                guard !isCompleted && !animateText else { return }
                try? await Task.sleep(for: .seconds(0))
                withAnimation(.linear(duration: 2.5).repeatForever(autoreverses: false)) {
                    animateText = true
                }
            }
    }
    
    @ViewBuilder
    public func leadingTextView(
        _ size: CGSize,
        progress: CGFloat
    ) -> some View {
        ZStack {
            Text(swipeText)
                .opacity(isCompleted ? 0 : 1)
                .blur(radius: isCompleted ? 10 : 0)
            
            Text(confirmationText)
                .opacity(!isCompleted ? 0 : 1)
                .blur(radius: !isCompleted ? 10 : 0)
        }
        .font(textFont)
        .foregroundStyle(foregroundColor)
        .frame(maxWidth: .infinity)
        .padding(.trailing, (size.height * (isCompleted ? 0.6 : 1)) / 2)
        .mask {
            Rectangle()
                .scale(x: progress, anchor: .leading)
        }
    }
}
