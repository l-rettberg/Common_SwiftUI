//
//  RadarScanAnimation.swift
//  CommonSwiftUI
//
//  Created by James Thang on 10/2/25.
//

import SwiftUI
import GameplayKit

/// A SwiftUI view component that renders a customizable radar scanning animation.
///
/// The `RadarScanAnimation` view simulates a radar scanning effect by continuously rotating an
/// angular gradient. An optional noise texture overlay, generated using GameplayKit, is blended
/// into the view to add visual complexity. The animation's speed, rotation direction, and appearance
/// are fully configurable via the component's parameters.
///
/// - Parameters:
///   - color: The color used for the radar's scanning sweep. Defaults to blue.
///   - backgroundColor: The background color of the radar view. Defaults to black.
///   - showNoiseImage: A Boolean value indicating whether a noise texture overlay is displayed.
///                     This overlay adds organic visual complexity to the radar effect. Defaults to true.
///   - counterClockwise: A Boolean value that determines the rotation direction of the scanning animation.
///                        When true, the radar rotates counterclockwise; when false, it rotates clockwise.
///                        Defaults to true.
///   - animationSpeed: The speed of the scanning animation, represented by the `RadarAnimationSpeed` enum.
///                     Defaults to `.normal`.
///
/// ## Usage:
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         RadarScanAnimation(
///             color: .green,
///             backgroundColor: .black,
///             showNoiseImage: true,
///             counterClockwise: false,
///             animationSpeed: .fast
///         )
///         .frame(width: 300, height: 300)
///     }
/// }
/// ```
public struct RadarScanAnimation: View {
    
    // MARK: - Configuration Properties
    private let radarColor: Color
    private let backgroundColor: Color
    private let showNoiseImage: Bool
    private let counterClockwise: Bool
    private let animationSpeed: RadarScanAnimation.Speed

    @State private var isAnimating = false

    private var rotationDegrees: Double {
        counterClockwise ? -360 : 360
    }
    
    private var primaryGradientStops: [Gradient.Stop] {
        counterClockwise ?
        [
            .init(color: radarColor, location: 0.03),
            .init(color: .clear, location: 0.4)
        ] :
        [
            .init(color: .clear, location: 0.6),
            .init(color: radarColor, location: 0.97)
        ]
    }

    private var secondaryGradientStops: [Gradient.Stop] {
        counterClockwise ?
        [
            .init(color: radarColor, location: 0.0),
            .init(color: .clear, location: 0.5)
        ] :
        [
            .init(color: .clear, location: 0.5),
            .init(color: radarColor, location: 1.0)
        ]
    }
    
    private var noiseImage: Image? {
        guard showNoiseImage else { return nil }
        let noiseTexture = GKNoise(
            GKPerlinNoiseSource(
                frequency: 1,
                octaveCount: 4,
                persistence: 2,
                lacunarity: 2,
                seed: 2
            )
        )
        let noiseMap = GKNoiseMap(noiseTexture)
        
        return Image(SKTexture(noiseMap: noiseMap).cgImage(),
                     scale: 1,
                     label: Text("Noise"))
                    .resizable()
    }
    
    // MARK: - Initializer
    public init(color: Color = .blue,
                backgroundColor: Color = .black,
                showNoiseImage: Bool = true,
                counterClockwise: Bool = true,
                animationSpeed: RadarScanAnimation.Speed = .normal) {
        self.radarColor = color
        self.backgroundColor = backgroundColor
        self.showNoiseImage = showNoiseImage
        self.counterClockwise = counterClockwise
        self.animationSpeed = animationSpeed
    }
    
    // MARK: - View Body
    public var body: some View {
        ZStack {
            Circle()
                .fill(
                    AngularGradient(
                        gradient: Gradient(stops: primaryGradientStops),
                        center: .center
                    )
                )
                .rotationEffect(.degrees(isAnimating ? rotationDegrees : 0))
                .overlay {
                    ZStack {
                        if let noiseImage {
                            noiseImage
                                .blur(radius: 2)
                                .blendMode(.multiply)
                                .opacity(0.6)
                        }
 
                        AngularGradient(
                            gradient: Gradient(stops: secondaryGradientStops),
                            center: .center
                        )
                        .rotationEffect(.degrees(isAnimating ? rotationDegrees : 0))
                        .blendMode(.plusLighter)
                    }
                }
                .background(backgroundColor)
                .mask(Circle())
        }
        .onAppear {
            withAnimation(.linear(duration: animationSpeed.duration).repeatForever(autoreverses: false)) {
                isAnimating = true
            }
        }
    }
    
    /// An enumeration representing animation speeds for the radar scanning animation.
    ///
    /// The `Speed` enum defines preset animation speeds for the radar scanning animation.
    /// You can choose one of the built-in speeds (`slow`, `normal`, `fast`) or specify a custom
    /// animation duration using the `custom` case.
    ///
    /// - Cases:
    ///   - slow: A slow animation speed with a full rotation duration of 10 seconds.
    ///   - normal: A normal animation speed with a full rotation duration of 5 seconds.
    ///   - fast: A fast animation speed with a full rotation duration of 2.5 seconds.
    ///   - custom(TimeInterval): A custom animation speed with the provided time interval as the full rotation duration.
    public enum Speed {
        case slow, normal, fast
        case custom(TimeInterval)
        
        /// The duration, in seconds, for one full rotation of the radar scanning animation.
        public var duration: Double {
            switch self {
            case .slow:
                return 10.0
            case .normal:
                return 5.0
            case .fast:
                return 2.5
            case .custom(let interval):
                return interval
            }
        }
    }
    
}

#Preview {
    VStack {
        RadarScanAnimation(showNoiseImage: false)
        RadarScanAnimation(color: .init(hue: 0.3, saturation: 1, brightness: 1), counterClockwise: false)
    }
}
