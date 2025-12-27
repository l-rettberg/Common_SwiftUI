//
//  BlurView.swift
//  CommonSwiftUI
//
//  Created by James Thang on 28/03/2024.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
        
    var effect: UIBlurEffect.Style
    var onChange: (UIVisualEffectView) -> ()
    
    func makeUIView(context: Context) -> some UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: effect))
        return view
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.async {
            onChange(uiView)
        }
    }

}
