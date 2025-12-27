//
//  RootViewModel.swift
//  CommonSwiftUI
//
//  Created by James Thang on 17/06/2024.
//

import SwiftUI
import Combine

class RootViewModel: ObservableObject {

    @Published private(set) var alertWindow: UIWindow?
    @Published private var toastWindow: UIWindow?
    @Published private var tag: Int = 0
    
    func alert<AlertContent: View>(config: Binding<UniversalAlertConfig>, @ViewBuilder content: @escaping () -> AlertContent, viewTag: @escaping (Int) -> ()) {
        guard let alertWindow else { return }
        
        let viewController = UIHostingController(rootView:
                                                    UniversalAlertView(config: config,
                                                                       tag: tag,
                                                                       content: {
            content()
        }))
        viewController.view.backgroundColor = .clear
        viewController.view.tag = tag
        viewTag(tag)
        tag += 1
        
        if alertWindow.rootViewController == nil {
            alertWindow.rootViewController = viewController
            alertWindow.isHidden = false
            alertWindow.isUserInteractionEnabled = true
        } else {
            print("Existing Alert is still present")
        }
    }
    
    func setupToastWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, toastWindow == nil else {
            return
        }
        
        let window = PassthroughWindow(windowScene: windowScene)
        window.backgroundColor = .clear
        
        let rootViewController = UIHostingController(rootView: ToastGroup())
        rootViewController.view.frame = windowScene.keyWindow?.frame ?? .zero
        rootViewController.view.backgroundColor = .clear
        window.rootViewController = rootViewController
        window.isHidden = false
        window.isUserInteractionEnabled = true
        window.tag = 1996
        
        self.toastWindow = window
    }
    
    func setupAlertWindow() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, alertWindow == nil else {
            return
        }
        
        let window = UIWindow(windowScene: windowScene)
        window.isHidden = true
        window.isUserInteractionEnabled = false
        self.alertWindow = window
    }
    
    func cleanupAlertWindow() {
        alertWindow?.isHidden = true
        alertWindow = nil
    }
    
    func cleanupToastWindow() {
        toastWindow?.isHidden = true
        toastWindow = nil
    }
    
}
