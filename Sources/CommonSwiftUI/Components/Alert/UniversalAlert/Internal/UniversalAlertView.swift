//
//  UniversalAlertView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 17/06/2024.
//

import SwiftUI

struct UniversalAlertView<Content: View>: View {
    
    @Binding var config: UniversalAlertConfig
    // View Tag
    private(set) var tag: Int
    @ViewBuilder var content: () -> Content
    // View Properties
    @State private var showView: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack {
                if config.enableBackgroundBlur {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                } else {
                    Rectangle()
                        .fill(.clear)
                }
            }
            .ignoresSafeArea()
            .contentShape(.rect)
            .onTapGesture {
                if !config.disableOutsideTap {
                    config.dismiss()
                }
            }
            .opacity(showView ? 1 : 0)
            
            if showView && config.transitionType == .slide {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.move(edge: config.slideEdge))
            } else {
                content()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(showView ? 1 : 0)
            }
        })
        .onAppear {
            config.showView = true
        }
        .onChange(of: config.showView) { newValue in
            withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                showView = newValue
            }
        }
    }
    
}
