//
//  File.swift
//  KernelSwiftUtilities
//
//  Created by Jonathan Forbes on 01/12/2025.
//

import Foundation
import SwiftUI

public struct BouncingLoopAnimationViewModifier: ViewModifier {
    // MARK: - Configuration
    public var parameters: BounceParameters
    
    // MARK: - State
    @State private var yOffset: CGFloat = 0
    @State private var bounceTask: Task<Void, Error>? = nil
    private var isBouncing: Bool
    
    // MARK: - Init
    public init(parameters: BounceParameters, isBouncing: Bool) {
        self.parameters = parameters
        self.isBouncing = isBouncing
    }
    
    // MARK: - Body
    public func body(content: Content) -> some View {
        content
            .offset(y: yOffset)
            .onChange(of: isBouncing, { oldValue, newValue in
                if newValue {
                    startLoopIfNeeded()
                } else {
                    stopLoop()
                }
            })
            .onChange(of: parameters) { restartLoop() }
            .onDisappear {
                stopLoop()
            }
    }
    
    // MARK: - Control
    private func startLoopIfNeeded() {
        guard bounceTask == nil else { return }
        let task = Task { try await animateBounceLoop(parameters: parameters) }
        bounceTask = task
    }
    
    private func stopLoop() {
        bounceTask?.cancel()
        bounceTask = nil
    }
    
    private func restartLoop() {
        guard isBouncing else { return }
        stopLoop()
        startLoopIfNeeded()
    }
    
    // MARK: - Animation Loop
    private func apply(offset: CGFloat, animation: Animation) {
        withAnimation(animation) {
            yOffset = offset
        }
    }
    
    private func animateBounceLoop(parameters: BounceParameters) async throws {
        try await withTaskCancellationHandler(operation: {
            // Repeat until cancelled
            while !Task.isCancelled {
                for keyframe in parameters.bounceKeyframes {
                    if Task.isCancelled { break }
                    apply(offset: keyframe.offset, animation: keyframe.animation)
//                    // Apply animation on the main actor
//                    await MainActor.run {
//                        
//                    }
                    try await Task.sleep(nanoseconds: UInt64(keyframe.duration * 1_000_000_000))
                    // Sleep for the keyframe duration, but remain cancellation-cooperative
//                    do {
//                        
//                    } catch {
//                        // Cancellation or sleep error -> break out to cleanup
//                        break
//                    }
                }
            }
        }, onCancel: {
            // Snap to rest on cancellation using the last keyframe's animation if available
            Task {
                if let last = parameters.bounceKeyframes.last {
                    await apply(offset: last.offset, animation: last.animation)
                }
            }
        })
        
        // Ensure UI state reflects that we stopped
//        await MainActor.run {
//            bounceTask = nil
//        }
        bounceTask = nil
    }
}

extension BouncingLoopAnimationViewModifier {
    public struct BounceParameters: Equatable, Sendable {
        /// Peak displacement for the first rise (points).
        /// Suggested: -60 ... -10 for an upward bounce (negative moves up),
        /// or 10 ... 60 for a downward bounce. Larger magnitudes = bigger bounces.
        public var height: CGFloat
        /// Spring stiffness (N/m-ish, unitless here).
        /// Suggested: 80 ... 400. Higher = snappier, faster oscillations.
        public var stiffness: Double
        /// Linear damping (unitless here) affecting how quickly energy is lost.
        /// Suggested: 5 ... 40. Higher = fewer oscillations, quicker settle.
        public var damping: Double
        /// Effective mass of the system.
        /// Suggested: 0.5 ... 3.0. Higher = slower oscillations (heavier feel).
        public var mass: Double
        /// Amplitude decay per bounce (0 < decay < 1).
        /// Suggested: 0.45 ... 0.85. Lower = bounces shrink faster; higher = linger longer.
        public var decay: Double   // 0 < decay < 1, how much each bounce amplitude reduces
        /// Pause/settle duration for the final segment (seconds).
        /// Suggested: 0.2 ... 1.2. Larger values linger a bit at rest.
        public var finalPause: Double // seconds to pause/settle at the end
        /// Number of bounce peaks after the initial rise.
        /// Suggested: 1 ... 5. More bounces = longer animation.
        public var totalBounces: Int
        
        public var bounceKeyframes: [BounceKeyframe] = []
        
        /// Create bounce parameters.
        ///
        /// - Parameters:
        ///   - height: Peak displacement for the first rise (points). Suggested: -60 ... -10 (up) or 10 ... 60 (down). Larger magnitudes = bigger bounces.
        ///   - stiffness: Spring stiffness. Suggested: 80 ... 400. Higher = snappier, faster oscillations.
        ///   - damping: Linear damping. Suggested: 5 ... 40. Higher = fewer oscillations, quicker settle.
        ///   - mass: Effective system mass. Suggested: 0.5 ... 3.0. Higher = slower oscillations (heavier feel).
        ///   - decay: Amplitude decay per bounce (0 < decay < 1). Suggested: 0.45 ... 0.85. Lower = shrink faster; higher = linger longer.
        ///   - finalPause: Pause/settle duration for the final segment (seconds). Suggested: 0.2 ... 1.2.
        ///   - totalBounces: Number of bounce peaks after the initial rise. Suggested: 1 ... 5.
        public init(
            height: CGFloat,
            stiffness: Double,
            damping: Double,
            mass: Double,
            decay: Double,
            finalPause: Double,
            totalBounces: Int
        ) {
            self.height = height
            self.stiffness = max(1.0, stiffness)
            self.damping = max(0.0, damping)
            self.mass = max(0.01, mass)
            self.decay = min(0.99, max(0.05, decay))
            self.finalPause = max(0.0, finalPause)
            self.totalBounces = max(0, totalBounces)
            self.bounceKeyframes = keyframes()
        }
    }
}

extension BouncingLoopAnimationViewModifier.BounceParameters {
    public struct BounceKeyframe: Equatable, Sendable {
        public var offset: CGFloat
        public var animation: Animation
        public var duration: Double
        
        public init(
            offset: CGFloat,
            animation: Animation,
            duration: Double
        ) {
            self.offset = offset
            self.animation = animation
            self.duration = duration
        }
    }
    
    public func keyframes() -> [BounceKeyframe] {
        // Natural-feeling bounce using explicit decay and a softer final pause.
        let k = stiffness
        let c = damping
        let m = mass
        let clampedBounces = totalBounces
        
        // Frequencies
        let omega_n = max(1.0, sqrt(k / m))
        let zeta = min(0.99, max(0.0, c / (2.0 * sqrt(k * m))))
        let omega_d = omega_n * sqrt(max(0.0001, 1.0 - zeta * zeta))
        let dampedPeriod = (2.0 * .pi) / omega_d
        
        // Minimum segment duration to avoid zero-length animations
        let minSegment = 0.06
        
        // Helper to compute per-segment duration based on amplitude
        func duration(for amplitudeScale: Double) -> Double {
            let base = 0.40 * dampedPeriod * max(0.15, amplitudeScale)
            return max(minSegment, base)
        }
        
        var frames: [BounceKeyframe] = []
        
        // Initial rise to peak height
        let initialRiseSpring = Animation.interpolatingSpring(stiffness: k, damping: c)
        frames.append(.init(offset: height, animation: initialRiseSpring, duration: duration(for: 1.0)))
        
        // Alternating drops and rises with exponential decay controlled directly by `decay`
        for i in 0..<clampedBounces {
            let currentScale = pow(decay, Double(i))
            let nextScale = pow(decay, Double(i + 1))
            
            // Drop to ground
            let dropSpring = Animation.interpolatingSpring(
                stiffness: k * (1.0 + 0.10 * Double(i + 1)),
                damping: max(1.0, c * (1.0 + 0.08 * Double(i + 1)))
            )
            frames.append(.init(offset: 0, animation: dropSpring, duration: duration(for: currentScale)))
            
            // Rise to reduced peak
            let riseSpring = Animation.interpolatingSpring(
                stiffness: k * (1.0 + 0.05 * Double(i + 1)),
                damping: max(1.0, c * (1.0 + 0.12 * Double(i + 1)))
            )
            frames.append(.init(offset: height * CGFloat(nextScale), animation: riseSpring, duration: duration(for: nextScale)))
        }
        
        // Final settle: continue the same stiffness/damping progression for a natural finish.
        let finalScale = pow(decay, Double(clampedBounces + 1))
        let finalStiffness = k * (1.0 + 0.05 * Double(clampedBounces + 1))
        let finalDamping = max(1.0, c * (1.0 + 0.12 * Double(clampedBounces + 1)))
        let finalSpring = Animation.interpolatingSpring(stiffness: finalStiffness, damping: finalDamping)
        let finalDuration = max(minSegment, duration(for: finalScale)) + max(0.0, finalPause) * 1
        frames.append(.init(offset: 0, animation: finalSpring, duration: finalDuration))
        
        return frames
    }
}

// MARK: - View convenience
extension View {
    public func bouncingLoopAnimation(
        parameters: BouncingLoopAnimationViewModifier.BounceParameters,
        isBouncing: Bool
    ) -> some View {
        modifier(
            BouncingLoopAnimationViewModifier(
                parameters: parameters,
                isBouncing: isBouncing
            )
        )
    }
}

