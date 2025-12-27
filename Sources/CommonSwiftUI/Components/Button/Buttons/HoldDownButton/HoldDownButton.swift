//
//  HoldDownButton.swift
//  CommonSwiftUI
//
//  Created by James Thang on 01/06/2024.
//

import SwiftUI

/// A SwiftUI view that implements a hold-down button with progress feedback.
///
/// `HoldDownButton` allows users to interact with a button that requires being held down for a specific duration to activate. It visually indicates the progress of the hold duration using a loading bar and supports customizable text, colors, and shape.
///
/// - Parameters:
///   - text: The label displayed on the button.
///   - paddingHorizontal: Horizontal padding around the text.
///   - paddingVertical: Vertical padding around the text.
///   - duration: The time in seconds the button needs to be held to activate.
///   - scale: The scale effect applied to the button when pressed.
///   - color: The text color.
///   - background: The button's background color.
///   - loadingTint: The color of the progress indicator.
///   - shape: The shape of the button, defined using a generic `Shape`.
///   - action: The closure to execute when the hold duration is completed.
///
/// ## Example Usage:
/// ```swift
/// HoldDownButton(
///     text: "Press and Hold",
///     paddingHorizontal: 24,
///     paddingVertical: 12,
///     duration: 2,
///     scale: 0.95,
///     color: .white,
///     background: .blue,
///     loadingTint: .green.opacity(0.5),
///     clipShape: RoundedRectangle(cornerRadius: 10),
///     action: {
///         print("Action triggered!")
///     }
/// )
/// ```
///
/// This component is useful for actions that require confirmation or extended interaction, preventing accidental triggers.
///
public struct HoldDownButton<MyShape: Shape>: View {
    
    // Config
    private var text: String
    private var paddingHorizontal: CGFloat
    private var paddingVertical: CGFloat

    private var duration: CGFloat
    private var scale: CGFloat
    private var color: Color
    private var background: Color
    private var loadingTint: Color
    private var shape: MyShape
    private var action: () -> ()
    // View Properties
    @State private var timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    @State private var timerCount: CGFloat = 0
    @State private var progress: CGFloat = 0
    @State private var isHolding: Bool = false
    @State private var isCompleted: Bool = false
    
    public init(text: String, paddingHorizontal: CGFloat = 24, paddingVertical: CGFloat = 12, duration: CGFloat = 1, scale: CGFloat = 0.95, color: Color = .primary, background: Color = .secondary, loadingTint: Color = .secondary.opacity(0.3), clipShape: MyShape = .rect, action: @escaping () -> Void) {
        self.text = text
        self.paddingHorizontal = paddingHorizontal
        self.paddingVertical = paddingVertical
        self.duration = duration
        self.scale = scale
        self.color = color
        self.background = background
        self.loadingTint = loadingTint
        self.shape = clipShape
        self.action = action
    }

    public var body: some View {
        Text(text)
            .padding(.vertical, paddingVertical)
            .padding(.horizontal, paddingHorizontal)
            .foregroundStyle(color)
            .background {
                ZStack(alignment: .leading) {
                    Rectangle()
                        .apply {
                            if #available(iOS 16.0, *) {
                                $0.fill(background.gradient)
                            } else {
                                $0.fill(background)
                            }
                        }
                    
                    GeometryReader {
                        let size = $0.size
                        if !isCompleted {
                            Rectangle()
                                .fill(loadingTint)
                                .frame(width: size.width * progress)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .clipShape(shape)
            .contentShape(shape)
            .scaleEffect(isHolding ? scale : 1)
            .animation(.snappy, value: isHolding)
            .gesture(longPressGesture)
            .simultaneousGesture(dragGesture)
            .onReceive(timer) { _ in
                if isHolding && progress != 1 {
                    timerCount += 0.01
                    progress = max(min(timerCount / duration, 1), 0)
                }
            }
            .onAppear(perform: cancelTimer)
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onEnded { _ in
                guard !isCompleted else { return }
                cancelTimer()
                withAnimation(.snappy) {
                    reset()
                }
            }
    }
    
    private var longPressGesture: some Gesture {
        LongPressGesture(minimumDuration: duration)
            .onChanged {
                isCompleted = false
                reset()
                isHolding = $0
                addTimer()
            }.onEnded { status in
                isHolding = false
                cancelTimer()
                withAnimation(.easeInOut(duration: 0.2)) {
                    isCompleted = status
                }
                
                action()
            }
    }
    
    // Add Timer
    private func addTimer() {
        timer = Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()
    }
    
    // Cancel Timer
    private func cancelTimer() {
        timer.upstream.connect().cancel()
    }
    
    // Reset to Initial state
    private func reset() {
        isHolding = false
        progress = 0
        timerCount = 0
    }
    
}
