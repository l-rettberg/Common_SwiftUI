//
//  ToastGroup.swift
//  CommonSwiftUI
//
//  Created by James Thang on 22/03/2024.
//

import SwiftUI

struct ToastGroup: View {

    @StateObject private var model = Toast.shared

    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            let safeArea = geometry.safeAreaInsets

            ZStack {
                // Top-down toasts (default)
                toastStack(size: size, safeArea: safeArea, style: .topDown)

                // Bottom-up toasts
                toastStack(size: size, safeArea: safeArea, style: .bottomUp)
            }
        }
    }

    @ViewBuilder
    private func toastStack(size: CGSize, safeArea: EdgeInsets, style: ToastPresentationStyle) -> some View {
        let items = model.toasts.filter { $0.presentationStyle == style }
        ZStack {
            ForEach(items) { toast in
                ToastView(size: size, item: toast)
                    .scaleEffect(scale(toast, in: items))
                    .offset(y: offsetY(toast, in: items, style: style))
                    .zIndex(Double(items.firstIndex(where: { $0.id == toast.id }) ?? 0))
            }
        }
        .padding(style == .topDown ? .top : .bottom, style == .topDown ? (safeArea.top == .zero ? 15 : 10) : (safeArea.bottom == .zero ? 15 : 10))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: style == .topDown ? .top : .bottom)
        .animation(.snappy, value: items.map(\.id))
    }

    private func offsetY(_ item: ToastItem, in items: [ToastItem], style: ToastPresentationStyle) -> CGFloat {
        let index = CGFloat(items.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(items.count) - 1
        switch style {
        case .topDown:
            // Newest at top; older stack downward (positive offset)
            return (totalCount - index) >= 2 ? 20 : ((totalCount - index) * 10)
        case .bottomUp:
            // Newest at bottom; older stack upward (negative offset)
            return (totalCount - index) >= 2 ? -20 : ((totalCount - index) * -10)
        }
    }

    private func scale(_ item: ToastItem, in items: [ToastItem]) -> CGFloat {
        let index = CGFloat(items.firstIndex(where: { $0.id == item.id }) ?? 0)
        let totalCount = CGFloat(items.count) - 1
        return 1.0 - ((totalCount - index) >= 2 ? 0.2 : ((totalCount - index) * 0.1))
    }
}
