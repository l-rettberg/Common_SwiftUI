//
//  LineGraph.swift
//  CommonSwiftUI
//
//  Created by James Thang on 6/2/25.
//

import SwiftUI

/// A view that draws a line chart from an array of `Double` values.
///
/// `LineGraph` animates its stroke when it first appears, showing the line being drawn
/// from left to right. It also provides the ability to ensure a minimum number
/// of points are displayed if desired.
/// - Parameters:
///   - points: The values to plot on the line graph.
///   - minPointsDisplayCount: Ensures a minimum number of points in the drawn graph,
///     which can be useful for spacing or styling.
///   - animated: If `true`, the graph will animate from 0% to 100% on appear.
///
public struct LineGraph: View {
    
    @State private var end: CGFloat
    private let points: [Double]
    private let minPointsDisplayCount: Int?
    
    public init(
        _ points: [Double],
        minPointsDisplayCount: Int? = nil,
        animated: Bool = true
    ) {
        self.points = points
        self.minPointsDisplayCount = minPointsDisplayCount
        end = animated ? 0 : 1
    }

    public var body: some View {
        LineShape(points, minPointsDisplayCount: minPointsDisplayCount)
            .trim(from: 0, to: end)
            .stroke(AnyShapeStyle(.tint), style: .init(lineWidth: 1.5, lineCap: .round, lineJoin: .round))
            .animation(.bouncy, value: end)
            .onAppear {
                withAnimation(.interactiveSpring) {
                    end = 1
                }
            }
    }

    struct LineShape: Shape {
        
        private var points: [Double]
        private let minPointsDisplayCount: Int?

        init(_ points: [Double], minPointsDisplayCount: Int? = nil) {
            self.points = points
            self.minPointsDisplayCount = minPointsDisplayCount
        }

        var animatableData: AnimatableLine {
            get { AnimatableLine(values: points) }
            set { points = newValue.values }
        }

        func path(in rect: CGRect) -> Path {
            Path { path in
                for index in points.indices {
                    var pointsCount = points.count
                    if let minPointsDisplayCount, minPointsDisplayCount > pointsCount {
                        pointsCount = minPointsDisplayCount
                    }
                    let xPosition = rect.width / CGFloat(pointsCount - 1) * CGFloat(index)

                    let maxY = points.max() ?? 0
                    let minY = points.min() ?? 0
                    let yAxis = maxY - minY
                    let yPosition: CGFloat
                    if yAxis == 0 {
                        yPosition = rect.height / 2
                    } else {
                        yPosition = (1 - CGFloat((Double(points[index]) - minY) / yAxis)) * rect.height
                    }

                    if index == 0 {
                        path.move(to: .init(x: 0, y: yPosition))
                    }
                    path.addLine(to: .init(x: xPosition, y: yPosition))
                }
            }
        }
    }

    struct AnimatableLine: VectorArithmetic {
        var values: [Double]

        var magnitudeSquared: Double {
            return values.map { $0 * $0 }.reduce(0, +)
        }

        mutating func scale(by rhs: Double) {
            values = values.map { $0 * rhs }
        }

        static var zero: AnimatableLine {
            .init(values: [0.0])
        }

        static func - (lhs: AnimatableLine, rhs: AnimatableLine) -> AnimatableLine {
            .init(values: zip(lhs.values, rhs.values).map(-))
        }

        static func -= (lhs: inout AnimatableLine, rhs: AnimatableLine) {
            lhs = lhs - rhs
        }

        static func + (lhs: AnimatableLine, rhs: AnimatableLine) -> AnimatableLine {
            .init(values: zip(lhs.values, rhs.values).map(+))
        }

        static func += (lhs: inout AnimatableLine, rhs: AnimatableLine) {
            lhs = lhs + rhs
        }
    }
}

struct LineGraphPreview: View {
    @State private var randomData = (1 ... 10).map { _ in Double.random(in: 1 ... 10) }
    @State private var serialData: [Double] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

    var body: some View {
        VStack(spacing: 32) {
            Text(randomData.map { String(format: "%.1f", $0) }.joined(separator: ", "))
                
            LineGraph(randomData, animated: true)
                .frame(height: 100)
                .animation(.default, value: randomData)

            Text(serialData.map { String(format: "%.f", $0) }.joined(separator: ", "))

            LineGraph(serialData)
                .frame(height: 100)
                .animation(.default, value: serialData)

            Button("Update Data") {
                generateRandomData()
                generateSerialData()
            }
        }
    }

    private func generateRandomData() {
        randomData = (1 ... 10).map { _ in Double.random(in: 1 ... 10) }
    }

    private func generateSerialData() {
        let lastDatum = serialData.last ?? 0
        let secondLastDatum = serialData.dropLast().last ?? 0

        if lastDatum == 0 || secondLastDatum < lastDatum, lastDatum < 10 {
            serialData = serialData.dropFirst() + [lastDatum + 1]
        } else {
            serialData = serialData.dropFirst() + [lastDatum - 1]
        }
    }
    
}

#Preview {
    LineGraphPreview()
}
