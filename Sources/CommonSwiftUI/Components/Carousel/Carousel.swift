//
//  Carousel.swift
//  CommonSwiftUI
//
//  Created by James Thang on 7/2/25.
//

import SwiftUI

/// A flexible, optionally infinite-scrolling carousel that can scroll horizontally or vertically.
///
/// `Carousel` supports:
/// - Horizontal or vertical layout (`axes`)
/// - Configurable spacing and "peek" offsets
/// - Infinite scrolling by cloning the first/last items
/// - Drag gestures for pagination, including velocity-based flick
/// - External index binding to synchronize with other views or logic
///
public struct Carousel<Content: View>: View {
    
    // MARK: - Public API
    
    @Binding private var index: Int
    
    private let axes: Axis.Set
    private let spacing: CGFloat
    private let peek: CGFloat
    private let content: Content

    public init(
        _ axes: Axis.Set = .horizontal,
        selection: Binding<Int>,
        spacing: CGFloat = 0,
        peek: CGFloat = 0,
        isInfinite: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        _index = selection
        self.axes = axes
        self.spacing = spacing
        self.peek = peek
        self.content = content()
        _isInfiniteScroll = State(initialValue: isInfinite)
    }
    
    // MARK: - Private State & Computed
    
    @State private var isInfiniteScroll: Bool
    @State private var isAnimatedOffset: Bool = false
    @State private var viewCount: Int = 0
    @State private var viewSize: CGSize = .zero
    @State private var dragOffset: CGFloat = .zero
    
    /// The internal "active" index. In infinite mode, we often shift by +1
    /// to accommodate the cloned items at either end.
    @State private var activeIndex: Int = 1 {
        didSet {
            updateIndex()
            changeOffset()
        }
    }
    
    /// If we want to animate offset changes (true during user drags or page flips)
    private var offsetAnimation: Animation? {
        isAnimatedOffset ? .spring() : .none
    }
    
    // MARK: - Body
    
    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            carouselContent
                // Align at the top/leading corner so offsets work in both axes
                .frame(width: size.width, height: size.height, alignment: .topLeading)
                // Apply offset horizontally or vertically:
                .offset(
                    x: axes == .horizontal ? currentOffset : 0,
                    y: axes == .vertical   ? currentOffset : 0
                )
                .gesture(dragGesture)
                // Animate changes to offset (x or y)
                .animation(offsetAnimation, value: currentOffset)
                .onAppear {
                    viewSize = size
                }
                .onChange(of: index) { newValue in
                    // Sync external `index` with internal `activeIndex`
                    if isInfiniteScroll, newValue != activeIndex - 1 {
                        activeIndex = newValue + 1
                    } else if !isInfiniteScroll, newValue != activeIndex {
                        activeIndex = newValue
                    }
                }
        }
        .clipped()
    }
    
    // MARK: - Carousel Content
    
    @ViewBuilder
    private var carouselContent: some View {
        _VariadicView.Tree(
            CarouselLayout(
                axis: axes,
                itemDimension: itemDimension,
                spacing: spacing,
                isInfinite: isInfiniteScroll,
                viewCount: Binding(
                    get: { viewCount },
                    set: { newCount in
                        viewCount = newCount
                        checkViewCount()
                    }
                )
            )
        ) {
            content
        }
    }
    
    // MARK: - Computed Item Dimensions
    
    /// Computes the primary dimension (width or height) based on the axis.
    /// Subtracts spacing + peek on both sides.
    private var itemDimension: CGFloat {
        let primary = axes == .horizontal ? viewSize.width : viewSize.height
        return max(0, primary - (spacing + peek) * 2)
    }
    
    /// The item dimension plus spacing, used in offset calculations.
    private var itemActualDimension: CGFloat {
        itemDimension + spacing
    }
    
    // MARK: - Offset
    
    /// A unified offset property for both horizontal and vertical directions.
    private var currentOffset: CGFloat {
        guard viewCount > 1, viewSize != .zero else { return 0 }
        // Each item is offset by `itemActualDimension` from the previous
        let activeOffset = CGFloat(activeIndex) * itemActualDimension
        // Start from (spacing + peek), then subtract the activeOffset, plus drag
        return (spacing + peek) - activeOffset + dragOffset
    }
    
    // MARK: - State Checks
    
    private func checkViewCount() {
        if viewCount <= 1 {
            // Only 1 item -> disable infinite scroll
            isInfiniteScroll = false
            activeIndex = 0
            isAnimatedOffset = false
        } else {
            // If infinite, offset the "real" index by +1 to skip the clone at start
            let upperBound = isInfiniteScroll ? viewCount - 3 : viewCount - 1
            let clampedIndex = min(index, upperBound)
            activeIndex = isInfiniteScroll ? clampedIndex + 1 : clampedIndex
            isAnimatedOffset = false
        }
    }
    
    private func updateIndex() {
        // Synchronize with external binding
        if isInfiniteScroll {
            // If we're at the clone edges, we handle the wrap in `changeOffset()`
            if activeIndex == 0 || activeIndex >= viewCount - 1 { return }
            index = activeIndex - 1
        } else {
            index = activeIndex
        }
    }
    
    // MARK: - Changing the Offset
    
    private func changeOffset() {
        isAnimatedOffset = true
        guard isInfiniteScroll, viewSize != .zero else { return }
        
        let minOffset = spacing + peek
        let maxOffset = minOffset - CGFloat(viewCount - 1) * itemActualDimension
        
        // Did we scroll to the "fake first" clone (front)?
        let scrolledToFrontClone = currentOffset == minOffset
        // Did we scroll to the "fake last" clone (back)?
        let scrolledToLastClone  = currentOffset == maxOffset
        
        // If at front clone, jump to last "real" item
        if scrolledToFrontClone {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeIndex = self.viewCount - 2
                self.isAnimatedOffset = false
            }
        }
        // If at last clone, jump to first "real" item
        else if scrolledToLastClone {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeIndex = 1
                self.isAnimatedOffset = false
            }
        }
    }
    
    // MARK: - Drag Gesture
    
    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged(dragChanged)
            .onEnded(dragEnded)
    }
    
    private func dragChanged(_ value: DragGesture.Value) {
        isAnimatedOffset = true
        
        let translation = axes == .horizontal ? value.translation.width : value.translation.height
        // Limit offset to ±1 item dimension so we only move one item per drag
        var offset = itemActualDimension
        
        if translation > 0 {
            offset = min(offset, translation)
        } else {
            offset = max(-offset, translation)
        }
        
        dragOffset = offset
    }
    
    private func dragEnded(_ value: DragGesture.Value) {
        // Reset the real-time offset
        dragOffset = .zero
        
        // 1. Check velocity-based movement
        let nextIndexVelocity = nextActiveIndexByVelocity(value)
        if nextIndexVelocity != activeIndex {
            activeIndex = clampIndex(nextIndexVelocity)
            return
        }
        
        // 2. Check distance-based movement
        let nextIndexTranslation = nextActiveIndexByTranslation(value)
        if nextIndexTranslation != activeIndex {
            activeIndex = clampIndex(nextIndexTranslation)
        }
    }
    
    private func clampIndex(_ newIndex: Int) -> Int {
        max(0, min(newIndex, viewCount - 1))
    }
    
    // MARK: - Velocity / Translation Logic
    
    private func nextActiveIndexByVelocity(_ value: DragGesture.Value) -> Int {
        let dragThreshold: CGFloat = 500
        let velocity = axes == .horizontal ? value.velocity.width : value.velocity.height
        
        if velocity > dragThreshold {
            return activeIndex - 1
        } else if velocity < -dragThreshold {
            return activeIndex + 1
        } else {
            return activeIndex
        }
    }
    
    private func nextActiveIndexByTranslation(_ value: DragGesture.Value) -> Int {
        let dragThreshold = itemDimension / 3
        let translation = axes == .horizontal ? value.translation.width : value.translation.height
        
        if translation > dragThreshold {
            return activeIndex - 1
        } else if translation < -dragThreshold {
            return activeIndex + 1
        } else {
            return activeIndex
        }
    }
}

// MARK: - Single Carousel Layout (Horizontal/Vertical)

fileprivate struct CarouselLayout: _VariadicView_UnaryViewRoot {
    let axis: Axis.Set
    let itemDimension: CGFloat
    let spacing: CGFloat
    let isInfinite: Bool
    
    @Binding var viewCount: Int
    
    func body(children: _VariadicView.Children) -> some View {
        Group {
            if axis == .horizontal {
                HStack(spacing: spacing) {
                    if let lastChild = children.last, isInfinite {
                        lastChild.carouselFrame(axis, itemDimension)
                    }
                    
                    ForEach(children.indices, id: \.self) { i in
                        children[i].carouselFrame(axis, itemDimension)
                    }
                    
                    if let firstChild = children.first, isInfinite {
                        firstChild.carouselFrame(axis, itemDimension)
                    }
                }
            } else {
                VStack(spacing: spacing) {
                    if let lastChild = children.last, isInfinite {
                        lastChild.carouselFrame(axis, itemDimension)
                    }
                    
                    ForEach(children.indices, id: \.self) { i in
                        children[i].carouselFrame(axis, itemDimension)
                    }
                    
                    if let firstChild = children.first, isInfinite {
                        firstChild.carouselFrame(axis, itemDimension)
                    }
                }
            }
        }
        .onAppear {
            // If more than 1 child, we clone 2 for infinite
            viewCount = children.count > 1
                ? children.count + (isInfinite ? 2 : 0)
                : 1
        }
    }
}

// MARK: - Item Frame Helper

fileprivate extension View {
    func carouselFrame(_ axis: Axis.Set, _ dimension: CGFloat) -> some View {
        if axis == .horizontal {
            return AnyView(self.frame(width: dimension))
        } else {
            return AnyView(self.frame(height: dimension))
        }
    }
}


#Preview("Single view") {
    Carousel(selection: .constant(0)) {
        Color.red
    }
}

#Preview("Multiple views") {
    Carousel(selection: .constant(0)) {
        Color.red
        Color.blue
        Color.yellow
        Color.green
    }
}

#Preview("Finite multiple views") {
    Carousel(selection: .constant(0), isInfinite: false) {
        Color.red
        Color.blue
        Color.yellow
        Color.green
    }
}

#Preview("Multiple views with spacing") {
    Carousel(selection: .constant(0), spacing: 25) {
        Color.red
        Color.blue
        Color.yellow
        Color.green
    }
}

#Preview("Multiple views with spacing & peek") {
    Carousel(selection: .constant(0), spacing: 20, peek: 30) {
        Color.red
        Color.blue
        Color.yellow
        Color.green
    }
}

#Preview("Multiple views - vertical with spacing") {
    Carousel(.vertical, selection: .constant(0), spacing: 50) {
        Color.red
        Color.blue
        Color.yellow
        Color.green
    }
}

#Preview("Multiple views - vertical with spacing & peek") {
    Carousel(.vertical, selection: .constant(0), spacing: 20, peek: 30) {
        Color.red
        Color.blue
        Color.yellow
        Color.green
    }
}

struct CarouselBasicPreview: View {
    @State private var selection: Int = 0

    var body: some View {
        ScrollView {
            VStack {
                Text("currentIndex: \(selection)")

                Text("This is an infinite carousel")

                Carousel(selection: $selection, isInfinite: true) {
                    Color.red
                    Color.blue
                    Color.yellow
                    Color.green
                }
                .frame(height: 200)

                Text("This is an infinite carousel with **25** spacing")

                Carousel(selection: $selection, spacing: 25) {
                    Color.red
                    Color.blue
                    Color.yellow
                    Color.green
                }
                .frame(height: 200)

                Text("This is a finite carousel with **50** spacing")

                Carousel(selection: $selection, spacing: 50, isInfinite: false) {
                    Color.red
                    Color.blue
                    Color.yellow
                    Color.green
                }
                .frame(height: 200)
                
                Text("This is a finite carousel with **30** spacing & **20** peek width")
                    .multilineTextAlignment(.center)

                Carousel(selection: $selection, spacing: 30, peek: 20, isInfinite: false) {
                    Color.red
                    Color.blue
                    Color.yellow
                    Color.green
                }
                .frame(height: 200)
            }
        }
    }
}

#Preview("Basic") {
    CarouselBasicPreview()
}

