//
//  ToastView.swift
//  Toasting
//
//  Created by James Thang on 17/12/2023.
//

import SwiftUI

struct ToastView: View {
    
    var size: CGSize
    var item: ToastItem
    // View Properties
    @State private var delayTask: DispatchWorkItem?

    var body: some View {
        HStack(spacing: 0) {
            if let symbol = item.symbol {
                Image(systemName: symbol)
                    .font(.title3)
                    .padding(.trailing, 10)
            }
            
            Text(item.title)
                .lineLimit(1)
        }
        .foregroundStyle(item.tint)
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .apply {
            if #available(iOS 16.0, *) {
                $0.background(
                        .background
                            .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: 5, y: 5))
                            .shadow(.drop(color: .primary.opacity(0.06), radius: 5, x: -5, y: -5)),
                        in: .capsule
                    )
            } else {
                $0.background(in: .capsule).neumorphism(color: .primary.opacity(0.06))
            }
        }
        .contentShape(.capsule)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onEnded({ value in
                    guard item.isUserInteractionEnabled else { return }
                    let endY = value.translation.height
                    let velocityY = value.velocity.height
                    let threshold: CGFloat = 100
                    switch item.presentationStyle {
                    case .topDown:
                        if (endY + velocityY) < -threshold { removeToast() }
                    case .bottomUp:
                        if (endY + velocityY) > threshold { removeToast() }
                    }
                })
        )
        .onAppear {
            guard delayTask == nil else { return }
            delayTask = .init(block: {
                removeToast()
            })
            
            if let delayTask {
                DispatchQueue.main.asyncAfter(deadline: .now() + item.timing.timeInterval, execute: delayTask)
            }
        }
        // Limiting Size
        .frame(maxWidth: size.width * 0.7)
        .transition(
            .asymmetric(
                insertion: item.presentationStyle == .topDown ? .offset(y: -150) : .offset(y: 150),
                removal: item.presentationStyle == .topDown ? .offset(y: -150) : .offset(y: 150)
            )
        )
    }
    
    private func removeToast() {
        if let delayTask {
            delayTask.cancel()
        }
        withAnimation(.snappy) {
            Toast.shared.remove(id: item.id)
        }
    }
    
}

