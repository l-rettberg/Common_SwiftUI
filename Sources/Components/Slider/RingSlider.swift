//
//  RingSlider.swift
//  CommonSwiftUI
//
//  Created by James Thang on 02/07/2024.
//

import SwiftUI

/// A customizable ring-shaped slider view for selecting angular ranges.
///
/// `RingSlider` provides a visual and interactive way to select a range of angles using draggable handles that can be customized with images or styled directly via a `ControlConfig`. The appearance of the slider, including line width, colors, and handle customization, is adjustable.
///
/// - Parameters:
///   - startAngle: The starting angle of the slider, modifiable via a binding.
///   - toAngle: The ending angle of the slider, modifiable via a binding.
///   - lineWidth: The thickness of the ring's line.
///   - tint: The primary color of the slider's line and handle if not using images.
///   - backgroundColor: The color behind the slider's line for contrast.
///   - controlConfig: Configuration for the slider's handles, including color, width, images, and shadow.
///
/// ## Example:
/// ```swift
/// @State private var startAngle: Angle = .degrees(30)
/// @State private var toAngle: Angle = .degrees(150)
///
/// var body: some View {
///     RingSlider(
///         startAngle: $startAngle,
///         toAngle: $toAngle,
///         lineWidth: 20,
///         tint: .blue,
///         backgroundColor: .gray.opacity(0.5),
///         controlConfig: RingSlider.ControlConfig(tint: .red, width: 30, startSliderImage: Image(systemName: "moon.fill"), endSliderImage: Image(systemName: "alarm"))
///     )
/// }
/// ```
/// This configuration leverages the `ControlConfig` to apply custom images for the handles and additional styling options, enhancing the user interaction experience.
/// 
public struct RingSlider: View {
    
    @Binding var startAngle: Angle
    @Binding var toAngle: Angle
    private var lineWidth: CGFloat
    private var color: Color
    private var backgroundColor: Color
    private var controlConfig: ControlConfig
    
    public init(startAngle: Binding<Angle>, toAngle: Binding<Angle>, lineWidth: CGFloat, tint: Color = .blue, backgroundColor: Color = .secondary.opacity(0.3), controlConfig: ControlConfig) {
        self._startAngle = startAngle
        self._toAngle = toAngle
        self.lineWidth = lineWidth
        self.color = tint
        self.backgroundColor = backgroundColor
        self.controlConfig = controlConfig
    }
    
    public var body: some View {
        GeometryReader { geometry in
            
            let width = geometry.size.width
            
            ZStack {
                
                Circle()
                    .stroke(backgroundColor, lineWidth: lineWidth)
                
                // Allowing Reverse Sliding
                let startProgress = $startAngle.wrappedValue.degrees / 360
                let toProgress = $toAngle.wrappedValue.degrees / 360
                let reverseRotation = (startProgress > toProgress) ? -Double((1 - startProgress) * 360) : 0
                
                Circle()
                    .trim(from: startProgress > toProgress ? 0 : startProgress, to: toProgress + (-reverseRotation/360))
                    .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .rotationEffect(.init(degrees: reverseRotation))
                
                // Start Slider Button
                if let startSliderImage = controlConfig.startSliderImage {
                    startSliderImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(8)
                        .frame(width: controlConfig.width, height: controlConfig.width)
                        .foregroundStyle(color)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(-startAngle)
                        .background(
                            Circle()
                                .fill(controlConfig.tint)
                                .shadow(color: controlConfig.enableShadow ? .black.opacity(0.3) : .clear, radius: 5, x: 5, y: 5)
                        )
                        .offset(x: width/2)
                        .rotationEffect(startAngle)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    onDrag(value: value, fromSlider: true)
                                })
                        )
                        .rotationEffect(.init(degrees: -90))
                } else {
                    Circle()
                        .frame(width: controlConfig.width, height: controlConfig.width)
                        .shadow(color: controlConfig.enableShadow ? .black.opacity(0.3) : .clear, radius: 5, x: 5, y: 5)
                        .foregroundStyle(controlConfig.tint)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(-startAngle)
                        .offset(x: width/2)
                        .rotationEffect(startAngle)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    onDrag(value: value, fromSlider: true)
                                })
                        )
                        .rotationEffect(.init(degrees: -90))
                }
                
                // Slider Button
                if let endSliderImage = controlConfig.endSliderImage {
                    endSliderImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(8)
                        .frame(width: controlConfig.width, height: controlConfig.width)
                        .foregroundStyle(color)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(-toAngle)
                        .background(
                            Circle()
                                .fill(controlConfig.tint)
                                .shadow(color: controlConfig.enableShadow ? .black.opacity(0.3) : .clear, radius: 5, x: 5, y: 5)
                        )                        .offset(x: width/2)
                        .rotationEffect(toAngle)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    onDrag(value: value)
                                })
                        )
                        .rotationEffect(.init(degrees: -90))
                } else {
                    Circle()
                        .frame(width: controlConfig.width, height: controlConfig.width)
                        .shadow(color: controlConfig.enableShadow ? .black.opacity(0.3) : .clear, radius: 5, x: 5, y: 5)
                        .foregroundStyle(controlConfig.tint)
                        .rotationEffect(.init(degrees: 90))
                        .rotationEffect(-toAngle)
                        .offset(x: width/2)
                        .rotationEffect(toAngle)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    onDrag(value: value)
                                })
                        )
                        .rotationEffect(.init(degrees: -90))
                }
            }
        }
    }
    
    @ViewBuilder
    private func Clock(width: CGFloat) -> some View {
        ZStack {
            ForEach(1...60, id: \.self) { index in
                Rectangle()
                    .fill(index % 5 == 0 ? .black : .gray)
                    .clipShape(Rectangle())
                    .frame(width: 2, height: index % 5 == 0 ? 15 : 5)
                    .offset(y: (width - 60) / 2)
                    .rotationEffect(.init(degrees: Double(index) * 6))
            }
            
            // Clock Text
            let texts = [6, 9, 12, 3]
            ForEach(texts.indices, id: \.self) { index in
                Text("\(texts[index])")
                    .font(.caption.bold())
                    .foregroundColor(.black)
                    .rotationEffect(.init(degrees: Double(index) * -90))
                    .offset(y: (width - 90)/2 )
                    .rotationEffect(.init(degrees: Double(index)*90))
            }
        }
    }
    
    private func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        // Converting Translation into Angle
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        // 15 is half button size
        let radians = atan2(vector.dy - controlConfig.width/2, vector.dx - controlConfig.width/2)
        
        // Convert to Angle
        var angle = radians * 180 / .pi
        if angle < 0 {
            angle = 360 + angle
        }
                
        if fromSlider {
            // Update From Value
            self.startAngle = Angle(degrees: Double(angle))
        } else {
            // Update To Value
            self.toAngle = Angle(degrees: Double(angle))
        }
    }
    
    /// `ControlConfig` provides customizable settings for the `RingSlider` component's controls.
    ///
    /// This structure configures the appearance and behavior of the slider controls in `RingSlider`, including optional images for slider handles and shadow effects.
    ///
    /// - Parameters:
    ///   - tint: The color used for the slider control's tint, defaulting to `.white`.
    ///   - width: The thickness or size of the slider handles in points.
    ///   - startSliderImage: An optional image for the slider's starting handle.
    ///   - endSliderImage: An optional image for the slider's ending handle.
    ///   - enableShadow: A Boolean value that determines whether a shadow is applied to the slider handles, defaulting to `true`.
    ///
    /// ## Example:
    ///
    /// ```swift
    /// var ringSliderConfig = ControlConfig(tint: .blue, width: 20, startSliderImage: Image("startIcon"), endSliderImage: Image("endIcon"), enableShadow: true)
    /// ```
    ///
    /// This configuration applies custom images, a blue tint, sets the handle width to 20 points, and enables shadows, specifically for enhancing the `RingSlider` user interface.
    public struct ControlConfig {
        private(set) var tint: Color
        private(set) var width: CGFloat
        private(set) var startSliderImage: Image?
        private(set) var endSliderImage: Image?
        private(set) var enableShadow: Bool
        
        public init(tint: Color = .white, width: CGFloat, startSliderImage: Image? = nil, endSliderImage: Image? = nil, enableShadow: Bool = true) {
            self.tint = tint
            self.width = width
            self.startSliderImage = startSliderImage
            self.endSliderImage = endSliderImage
            self.enableShadow = enableShadow
        }
    }
    
}
