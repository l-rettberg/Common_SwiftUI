//
//  HambugSlideMenu.swift
//  CommonSwiftUI
//
//  Created by James Thang on 24/08/2024.
//

import SwiftUI

/// A customizable slide menu in SwiftUI that can be expanded from the side of the screen.
///
/// This component provides a flexible and dynamic slide menu implementation that can toggle visibility with an animated transition. It supports customizable interactions, animations, and dimensions for the slide menu and its content.
///
/// - Parameters:
///   - showMenu: A binding to a Boolean that controls the visibility of the menu.
///   - rotatesWhenExpand: A Boolean value that determines if the content view should rotate when the menu expands.
///   - enableInteraction: A Boolean that enables interaction with the background content when the menu is expanded.
///   - sideMenuWidth: The width of the side menu.
///   - cornerRadius: The corner radius applied to the content view when the menu is expanded.
///   - background: The background style of the menu.
///   - overlay: The overlay style applied over the content when the menu is visible.
///   - content: A closure returning the content view, taking the current safe area insets as a parameter.
///   - menuView: A closure returning the menu view, taking the current safe area insets as a parameter.
///
/// ## Example:
/// ```swift
/// struct ContentView: View {
///     @State private var showMenu = false
///
///     var body: some View {
///         HambugSlideMenu(showMenu: $showMenu,
///                         rotatesWhenExpand: true,
///                         enableInteraction: true,
///                         sideMenuWidth: 250,
///                         cornerRadius: 20,
///                         background: Color.black.opacity(0.5),
///                         overlay: Color.gray.opacity(0.2)) { safeArea in
///             MainContentView()
///         } menuView: { safeArea in
///             SideMenuView()
///         }
///     }
/// }
/// ```
/// This example creates a slide menu that can be toggled by updating the `showMenu` state variable.
public struct HambugSlideMenu<Content: View, MenuView: View, Background: ShapeStyle, Overlay: ShapeStyle>: View {
    
    // Customization Options
    @Binding var showMenu: Bool
    private var rotatesWhenExpand: Bool
    private var enableInteraction: Bool
    private var sideMenuWidth: CGFloat
    private var cornerRadius: CGFloat
    private var background: Background
    private var overlay: Overlay
    @ViewBuilder var content: (UIEdgeInsets) -> Content
    @ViewBuilder var menuView: (UIEdgeInsets) -> MenuView
    // View Properties
    @GestureState private var isDragging: Bool = false
    @State private var offsetX: CGFloat = 0
    @State private var lastOffsetX: CGFloat = 0
    // Use to dim content view when side bar is being dragged
    @State private var progress: CGFloat = 0
    
    public init(showMenu: Binding<Bool>, rotatesWhenExpand: Bool = true, enableInteraction: Bool = true, sideMenuWidth: CGFloat = 200, cornerRadius: CGFloat = 25, background: Background = .black.opacity(0.85), overlay: Overlay = .black.opacity(0.2), @ViewBuilder content: @escaping (UIEdgeInsets) -> Content, @ViewBuilder menuView: @escaping (UIEdgeInsets) -> MenuView) {
        self._showMenu = showMenu
        self.rotatesWhenExpand = rotatesWhenExpand
        self.enableInteraction = enableInteraction
        self.sideMenuWidth = sideMenuWidth
        self.cornerRadius = cornerRadius
        self.background = background
        self.overlay = overlay
        self.content = content
        self.menuView = menuView
    }
    
    public var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0) {
                GeometryReader { _ in
                    menuView(safeArea)
                }
                .frame(width: sideMenuWidth)
                // Clipping Menu Interaction beyond its width
                .contentShape(.rect)
                
                GeometryReader { _ in
                    content(safeArea)
                }
                .frame(width: size.width)
                .overlay {
                    if enableInteraction && progress > 0 {
                        Rectangle()
                            .fill(overlay)
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    reset()
                                }
                            }
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: progress * cornerRadius)
                }
                .scaleEffect(rotatesWhenExpand ? 1 - (progress * 0.1) : 1, anchor: .trailing)
                .rotation3DEffect(.init(degrees: rotatesWhenExpand ? (progress * -15) : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
            }
            .frame(width: size.width + sideMenuWidth, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            .simultaneousGesture(dragGesture)
        }
        .background(background)
        .ignoresSafeArea()
        .customChange(value: showMenu) { newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue {
                    showSlideBar()
                } else {
                    reset()
                }
            }
        }
    }
    
    private var dragGesture: some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                out = true
            }.onChanged { value in
                guard value.startLocation.x > 10 else { return }
                
                let translationX = isDragging ? max(min(value.translation.width + lastOffsetX, sideMenuWidth), 0) : 0
                offsetX = translationX
                calculateProgress()
            }.onEnded { value in
                guard value.startLocation.x > 10 else { return }

                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    let velocityX = value.velocity.width / 8
                    let total = velocityX + offsetX
                    
                    if total > (sideMenuWidth * 0.5) {
                        showSlideBar()
                    } else {
                        reset()
                    }
                }
            }
    }
    
    private func showSlideBar() {
        offsetX = sideMenuWidth
        lastOffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    private func reset() {
        offsetX = 0
        lastOffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    private func calculateProgress() {
        progress = max(min(offsetX / sideMenuWidth, 1), 0)
    }
    
}
