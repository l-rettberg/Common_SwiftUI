//
//  UniversalAlertModifier.swift
//  CommonSwiftUI
//
//  Created by James Thang on 17/06/2024.
//

import SwiftUI

struct UniversalAlertModifier<AlertContent: View>: ViewModifier {
    
    @Binding var config: UniversalAlertConfig
    @ViewBuilder var alertContent: () -> AlertContent
    @EnvironmentObject var rootViewModel: RootViewModel
    @State private var viewTag: Int = 0
    
    func body(content: Content) -> some View {
        content
            .onChange(of: config.show) { newValue in
                if newValue {
                    rootViewModel.alert(config: $config, content: alertContent) { tag in
                        viewTag = tag
                    }
                } else {
                    guard let alertWindow = rootViewModel.alertWindow else { return }
                    if config.showView {
                        withAnimation(.smooth(duration: 0.35, extraBounce: 0)) {
                            config.showView = false
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            alertWindow.rootViewController = nil
                            alertWindow.isHidden = true
                            alertWindow.isUserInteractionEnabled = false
                        }
                    } else {
                        print("View is Disappeared")
                    }
                }
            }
    }
    
}
