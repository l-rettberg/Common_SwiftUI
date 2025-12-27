//
//  SegmentControl.swift
//  CommonSwiftUI
//
//  Created by James Thang on 31/03/2024.
//

import SwiftUI

/// A customizable segment control view in SwiftUI.
///
/// `SegmentControl` provides a customizable segmented control interface, allowing for the selection among multiple options. It features customizable active/inactive tint colors, an adjustable height, and a dynamic or static indicator for the active tab. Additionally, it offers a configuration for the indicator's appearance and position based on the selected segment.
///
/// - Parameters:
///   - tabs: An array of `Item`, representing each segment option.
///   - activeTab: A binding to the currently active segment.
///   - height: The height of the segment control.
///   - activeTint: Color for the active segment.
///   - inActiveTint: Color for inactive segments.
///   - indicatorConfiguration: Configuration for the segment indicator, including color and corner radius.
///   - displayItem: A closure that provides a view for displaying each segment option.
///
/// ## Usage Example:
/// ```swift
///enum SegmentedTab: String, CaseIterable {
///    case home = "Home"
///    case favorite = "Love"
///    case profile = "Profile"
///
///    var imageName: String {
///        switch self {
///        case .home:
///            return "house.fill"
///       case .favorite:
///            return "heart.fill"
///        case .profile:
///            return "person.crop.circle"
///        }
///    }
///}
///
/// @State private var activeTab: SegmentedTab = .home
///
/// var body: some View {
///     SegmentControl(tabs: SegmentedTab.allCases, activeTab: $activeTab, height: 40, activeTint: .primary, inActiveTint: .gray.opacity(0.5), indicatorConfiguration: .init(tint: .blue, cornerRadius: 0, style: .bottom)) { item in
///         HStack {
///             Image(systemName: item.imageName)
///             Text(item.rawValue)
///         }
///         .font(.title3)
///     }
/// }
/// ```
/// This example demonstrates a `SegmentControl` with custom tab items, including icons and text, showcasing how to integrate it into a SwiftUI view.
public struct SegmentControl<Content: View, Item: Hashable>: View {
    
    private var tabs: [Item]
    @Binding var activeTab: Item
    private var height: CGFloat
    // Customization Properties
    private var activeTint: Color
    private var inActiveTint: Color
    private var indicatorConfiguration: IndicatorConfig
    // View Properties
    @State private var excessTabWidth: CGFloat = .zero
    @State private var minX: CGFloat = .zero
    // Display View
    @ViewBuilder var displayItem: (Item) -> Content
    
    public init(tabs: [Item], activeTab: Binding<Item>, height: CGFloat = 45, activeTint: Color = .primary, inActiveTint: Color = .gray.opacity(0.5), indicatorConfiguration: IndicatorConfig, displayItem: @escaping (Item) -> Content) {
        self.tabs = tabs
        self._activeTab = activeTab
        self.height = height
        self.activeTint = activeTint
        self.inActiveTint = inActiveTint
        self.indicatorConfiguration = indicatorConfiguration
        self.displayItem = displayItem
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            let containerWidthForEachTab = size.width / CGFloat(tabs.count)
            
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    displayItem(tab)
                        .foregroundStyle(activeTab == tab ? activeTint : inActiveTint)
                        .animation(.snappy, value: activeTab)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                        .onTapGesture {
                            if let index = tabs.firstIndex(of: tab), let activeIndex = tabs.firstIndex(of: activeTab) {
                                activeTab = tab
                                
                                if #available(iOS 17.0, *) {
                                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                        excessTabWidth = containerWidthForEachTab * CGFloat(index - activeIndex)
                                    } completion: {
                                        withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                            minX = containerWidthForEachTab * CGFloat(index)
                                            excessTabWidth = 0
                                        }
                                    }
                                } else {
                                    withAnimation(.snappy(duration: 0.25, extraBounce: 0)) {
                                        excessTabWidth = containerWidthForEachTab * CGFloat(index - activeIndex)
                                    }
                                    withAnimation(.snappy(duration: 0.25, extraBounce: 0).delay(0.25)) {
                                        minX = containerWidthForEachTab * CGFloat(index)
                                        excessTabWidth = 0
                                    }
                                }
                            }
                        }
                        .background(alignment: .leading) {
                            if tabs.first == tab {
                                GeometryReader {
                                    let size = $0.size
                                    
                                    RoundedRectangle(cornerRadius: indicatorConfiguration.cornerRadius)
                                        .fill(indicatorConfiguration.tint)
                                        .frame(height: indicatorConfiguration.style == .bottom ? 4 : size.height)
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                        .frame(width: size.width + (excessTabWidth < 0 ? -excessTabWidth : excessTabWidth), height: size.height)
                                        .frame(width: size.width, alignment: excessTabWidth < 0 ? .trailing : .leading)
                                        .offset(x: minX)
                                }
                            }
                        }
                }
            }
            .preference(key: SegmentControlSizeKey.self, value: size)
            .onPreferenceChange(SegmentControlSizeKey.self) { value in
                if let index = tabs.firstIndex(of: activeTab) {
                    minX = containerWidthForEachTab * CGFloat(index)
                    excessTabWidth = 0
                }
            }
        }
        .frame(height: height)
    }
}

fileprivate struct SegmentControlSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
