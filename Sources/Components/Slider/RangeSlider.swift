//
//  RangeSlider.swift
//  CommonSwiftUI
//
//  Created by James Thang on 01/06/2024.
//

import SwiftUI

/// A customizable range slider view in SwiftUI.
///
/// Allows users to select a closed range of values using two draggable thumbs. This component is highly customizable with options for defining the range limits, thumb spacing, and appearance.
///
/// - Parameters:
///   - selection: A binding to the selected range of values.
///   - range: The total range from which values can be selected.
///   - minimumDistance: The minimum allowable distance between the two thumbs.
///   - lineWidth: The thickness of the slider's active range.
///   - tint: The color of the slider's active range and thumbs.
///   - backgroundColor: The color of the slider's track.
///   - controlConfig: Configuration for the control's appearance including thumb tint, width, and shadow.
///
/// ## Example Usage:
/// ```swift
/// @State private var selection: ClosedRange<CGFloat> = 60...90
///
/// var body: some View {
///     NavigationView {
///         VStack {
///             RangeSlider(
///                 selection: $selection,
///                 range: 10...100,
///                 minimumDistance: 10,
///                 lineWidth: 5,
///                 tint: .purple,
///                 backgroundColor: .secondary.opacity(0.3),
///                 controlConfig: RangeSlider.ControlConfig(tint: .white, width: 15, enableShadow: true)
///             )
///
///             Text("\(Int(selection.lowerBound)):\(Int(selection.upperBound))")
///                 .font(.largeTitle.bold())
///                 .padding(.top, 10)
///         }
///         .padding()
///         .navigationTitle("Range Slider")
///     }
/// }
/// ```
/// This setup demonstrates configuring a `RangeSlider`, displaying the selected value range with customized control appearance.
///
public struct RangeSlider: View {
    
    @Binding var selection: ClosedRange<CGFloat>
    private var range: ClosedRange<CGFloat>
    private var minimumDistance: CGFloat
    private var lineWidth: CGFloat
    private var tint: Color
    private var backgroudColor: Color
    private var controlConfig: ControlConfig
    // View properties
    @State private var slider1: GestureProperties = .init()
    @State private var slider2: GestureProperties = .init()
    @State private var indicatorWidth: CGFloat = 0
    @State private var isInitial: Bool = false
    
    public init(selection: Binding<ClosedRange<CGFloat>>, range: ClosedRange<CGFloat>, minimumDistance: CGFloat = 0, lineWidth: CGFloat = 5, tint: Color = .primary, backgroudColor: Color = .secondary.opacity(0.3), controlConfig: ControlConfig = .init()) {
        self._selection = selection
        self.range = range
        self.minimumDistance = minimumDistance
        self.lineWidth = lineWidth
        self.tint = tint
        self.backgroudColor = backgroudColor
        self.controlConfig = controlConfig
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let maxSliderWidth = geometry.size.width - controlConfig.width * 2
            let minimumDistance = minimumDistance == 0 ? 0 : (minimumDistance / (range.upperBound - range.lowerBound)) * maxSliderWidth
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(backgroudColor)
                    .frame(height: lineWidth)
                
                SliderView(geometry: geometry, maxSliderWidth: maxSliderWidth, minimumDistance: minimumDistance)
            }
            .frame(maxHeight: .infinity)
            .task {
                guard !isInitial else { return }
                isInitial = true
                try? await Task.sleep(nanoseconds: 0)
                let maxWidth = geometry.size.width - controlConfig.width * 2
                
                // Converting selection range into Offset
                let start = selection.lowerBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])
                let end = selection.upperBound.interpolate(inputRange: [range.lowerBound, range.upperBound], outputRange: [0, maxWidth])

                slider1.offset = start
                slider1.lastStoredOffset = start
                
                slider2.offset = end
                slider2.lastStoredOffset = end
                
                calculateNewRange(geometry.size)
            }
        }
    }
    
    @ViewBuilder
    private func SliderView(geometry: GeometryProxy, maxSliderWidth: CGFloat, minimumDistance: CGFloat) -> some View {
        HStack(spacing: 0) {
            Circle()
                .fill(controlConfig.tint)
                .frame(width: controlConfig.width, height: controlConfig.width)
                .shadow(color: controlConfig.enableShadow ? .black.opacity(0.3) : .clear, radius: 5, x: 5, y: 5)
                .contentShape(.rect)
                .background(alignment: .leading, content: {
                    Rectangle()
                        .fill(tint)
                        .frame(width: indicatorWidth, height: lineWidth)
                        .offset(x: controlConfig.width / 2)
                        .allowsHitTesting(false)
                })
                .offset(x: slider1.offset)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            // Calculating Offset
                            var translation = value.translation.width + slider1.lastStoredOffset
                            translation = min(max(translation, 0), slider2.offset - minimumDistance)
                            slider1.offset = translation
                            
                            calculateNewRange(geometry.size)
                        }).onEnded({ _ in
                            // Storing previous offset
                            slider1.lastStoredOffset = slider1.offset
                        })
                )
            
            Circle()
                .fill(controlConfig.tint)
                .frame(width: controlConfig.width, height: controlConfig.width)
                .shadow(color: controlConfig.enableShadow ? .black.opacity(0.3) : .clear, radius: 5, x: 5, y: 5)
                .contentShape(.rect)
                .offset(x: slider2.offset)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged({ value in
                            // Calculating Offset
                            var translation = value.translation.width + slider2.lastStoredOffset
                            translation = min(max(translation, slider1.offset + minimumDistance), maxSliderWidth)
                            slider2.offset = translation
                            
                            calculateNewRange(geometry.size)
                        }).onEnded({ _ in
                            // Storing previous offset
                            slider2.lastStoredOffset = slider2.offset
                        })
                )
        }
    }
    
    private func calculateNewRange(_ size: CGSize) {
        indicatorWidth = slider2.offset - slider1.offset + controlConfig.width
        
        let maxWidth = size.width - controlConfig.width * 2
        
        // Calculating New Range values
        let startProgress = slider1.offset / maxWidth
        let endProgress = slider2.offset / maxWidth

        // Interpolating between Upper and Lower bounds
        let newRangeStart = range.lowerBound.interpolated(towards: range.upperBound, amount: startProgress)
        let newRangeEnd = range.lowerBound.interpolated(towards: range.upperBound, amount: endProgress)

        // Updating Selection
        selection = newRangeStart...newRangeEnd
    }
    
    private struct GestureProperties {
        var offset: CGFloat = 0
        var lastStoredOffset: CGFloat = 0
    }
    
    /// `ControlConfig` provides customizable settings for the `RangeSlider` component's controls.
    ///
    /// This structure configures the appearance and behavior of the slider controls in `RangeSlider`, including the color, width, and shadow of the slider handles.
    ///
    /// - Parameters:
    ///   - tint: The color used for the slider handle's tint, defaulting to `.white`.
    ///   - width: The width of the slider handles in points.
    ///   - enableShadow: A Boolean value that indicates whether shadows are enabled for the slider handles, defaulting to `true`.
    ///
    /// ## Example:
    ///
    /// ```swift
    /// var rangeSliderConfig = ControlConfig(tint: .blue, width: 20, enableShadow: true)
    /// ```
    ///
    /// This configuration applies a blue tint, sets the handle width to 20 points, and enables shadows, specifically for enhancing the `RangeSlider` user interface.
    public struct ControlConfig {
        private(set) var tint: Color
        private(set) var width: CGFloat
        private(set) var enableShadow: Bool
        
        public init(tint: Color = .white, width: CGFloat = 15, enableShadow: Bool = true) {
            self.tint = tint
            self.width = width
            self.enableShadow = enableShadow
        }
    }
    
}
