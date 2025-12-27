//
//  DropDown.swift
//  CommonSwiftUI
//
//  Created by James Thang on 09/09/2023.
//

import SwiftUI

/// A customizable dropdown view in SwiftUI for displaying selectable items. A flexible and customizable dropdown component for SwiftUI. This view allows for displaying a list of selectable items with customizable appearance and interactivity.
///
/// This component offers flexibility in appearance and behavior, supporting dynamic content adjustments based on user selections. It provides customization options for row height, and allows for an optional placeholder view.
///
/// - Parameters:
///   - options: An array of `Item`, representing the content of the dropdown.
///   - selection: A binding to the currently selected item of type `Item`.
///   - rowHeight: Height of each dropdown row.
///   - displayItem: A closure that provides a view for each item. It receives four parameters: `item`: The current item to display, `isSelected`: A Boolean that indicates if the item is currently selected, `isPlaceHolderShow`: A Boolean that indicates if the placeholder is currently shown, and `isExpand`: A Boolean that indicates if the dropdown is expanded..
///   - placeHolder: An optional closure that returns a view used as the dropdown's placeholder. It receives a Boolean parameter indicating if the dropdown is expanded.
///
/// ## Usage Example:
/// ```swift
/// enum DropDownOptions: String, CaseIterable {
///     case north = "North"
///     case south = "South"
///     case east = "East"
///     case west = "West"
/// }
///
/// @State private var selectedOption: DropDownOptions = .east
///
/// var body: some View {
///     VStack {
///         DropDown(options: DropDownOptions.allCases, selection: $selectedOption, rowHeight: 60) { item, isSelected, isPlaceHolderShow in
///             Text(item.rawValue)
///                 .foregroundStyle(isSelected && !isPlaceHolderShow ? .blue : .gray)
///                 .font(.title3)
///         } placeHolder: { _ in
///             Text("Select an option")
///                 .foregroundStyle(.gray)
///                 .font(.title3)
///         }
///     }
/// }
/// ```
/// This example demonstrates a `DropDown` menu utilizing an enumeration for options, showcasing custom text styling and a placeholder.
///
public struct DropDown<Content: View, PlaceHolder: View, Item: Hashable>: View {
    // DropDown Properties
    private var options: [Item]
    @Binding var selection: Item
    private var rowHeight: CGFloat
    // View Properties
    @State private var expandView: Bool = false
    @State private var showPlaceHolder: Bool = true
    private var isPlaceHolderExist: Bool = false
    // Display closure
    private var displayItem: (Item, Bool, Bool, Bool) -> Content
    private var placeHolder: (Bool) -> PlaceHolder
    
    public init(options: [Item], selection: Binding<Item>, rowHeight: CGFloat = 55, @ViewBuilder displayItem: @escaping (Item, Bool, Bool, Bool) -> Content, @ViewBuilder placeHolder: @escaping (Bool) -> PlaceHolder = { _ in EmptyView() }) {
        self.options = options
        self._selection = selection
        self.rowHeight = rowHeight
        self.displayItem = displayItem
        self.placeHolder = placeHolder
        self.isPlaceHolderExist = !(placeHolder(false) is EmptyView)
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
                
            VStack(alignment: .leading, spacing: 0) {
                if showPlaceHolder && isPlaceHolderExist {
                    PlaceHolderView(size)
                }
                
                RowView(selection, size)
                
                ForEach(options.filter({ $0 != selection }), id: \.self) { title in
                    RowView(title, size)
                }
            }
        }
        .frame(height: rowHeight)
        .mask(alignment: .top) {
            Rectangle()
                .frame(height: expandView ? getTotalExpandedHeight() : rowHeight)
        }
        // Overlap or Expand
        .zIndex(expandView ? Double(Date().timeIntervalSince1970) : -1)
        .frame(height: expandView ? getTotalExpandedHeight() : rowHeight, alignment: .top)
    }
    
    private func getTotalExpandedHeight() -> CGFloat {
        if showPlaceHolder && isPlaceHolderExist {
            return CGFloat(options.count + 1) * rowHeight
        } else {
            return CGFloat(options.count) * rowHeight
        }
    }

    @ViewBuilder
    private func RowView(_ item: Item, _ size: CGSize) -> some View {
        Button(action: {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                if expandView {
                    expandView = false
                    // Disabling Animation for Non-Dynamic Contents
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                        selection = item
                        showPlaceHolder = false
                    }
                } else {
                    if selection == item {
                        expandView = true
                    }
                }
            }
        }, label: {
            displayItem(item, selection == item, showPlaceHolder, expandView)
                .frame(width: size.width, height: size.height, alignment: .leading)
                .contentShape(Rectangle())
                .transition(.identity)
        })
    }
    
    @ViewBuilder
    private func PlaceHolderView(_ size: CGSize) -> some View {
        Button(action: {
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                expandView.toggle()
            }
        }, label: {
            placeHolder(expandView)
                .frame(width: size.width, height: size.height, alignment: .leading)
                .contentShape(Rectangle())
                .transition(.identity)
        })
    }
}
