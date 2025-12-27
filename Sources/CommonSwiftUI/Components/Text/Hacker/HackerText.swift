//
//  HackerText.swift
//  CommonSwiftUI
//
//  Created by James Thang on 01/06/2024.
//

import SwiftUI

/// Provides an animated text effect that mimics hacking by changing characters randomly before revealing the final text.
///
/// - Parameters:
///   - text: The final text to display after animation.
///   - trigger: A Boolean that starts the animation when toggled.
///   - transition: The style of animation — either `hyper` for all hacker style or `numeric` for wheeling style only.
///   - duration: Total animation duration.
///   - speed: Time interval for character changes. Default is case .flash for 0.1 second.
///
/// ## Example Usage:
/// ```swift
/// HackerText(text: "Hello, world!", trigger: true, transition: .hyper, duration: 1.0, speed: 0.1)
/// ```
///
/// This view is particularly effective for creating engaging and eye-catching textual displays in apps that require a dramatic presentation.
public struct HackerText: View {
    
    public enum Style {
        case hyper, numeric
    }
    
    private var text: String
    private var trigger: Bool
    private var transition: HackerText.Style
    private var duration: CGFloat
    private var speed: CGFloat
    // View Properties
    @State private var animatedText: String = ""
    @State private var randomCharacters: [Character] = {
        let string = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*()-_=+[]{}|;:',.<>?/~`"
        return Array(string)
    }()
    @State private var animationID: String = UUID().uuidString
    
    public init(text: String, trigger: Bool, transition: HackerText.Style = .hyper, duration: CGFloat = 1.0, speed: Speed = .flash) {
        self.text = text
        self.trigger = trigger
        self.transition = transition
        self.duration = duration
        self.speed = speed.timeInterval
    }
    
    public var body: some View {
        Text(animatedText)
            .apply {
                if #available(iOS 16.1, *) {
                    switch transition {
                    case .hyper:
                        $0.fontDesign(.monospaced).contentTransition(.interpolate)
                    case .numeric:
                        $0.fontDesign(.monospaced).contentTransition(.numericText())
                    }
                } else if #available(iOS 16.0, *) {
                    switch transition {
                    case .hyper:
                        $0.contentTransition(.interpolate)
                    case .numeric:
                        $0.contentTransition(.numericText())
                    }
                } else {
                    $0.transition(.identity)
                }
            }
            .truncationMode(.tail)
            .animation(.easeInOut(duration: 0.1), value: animatedText)
            .onAppear {
                guard animatedText.isEmpty else { return }
                setRandomCharacters()
                animateText()
            }
            .customChange(value: trigger) { newValue in
                animateText()
            }
            .customChange(value: text) { newValue in
                animatedText = newValue
                animationID = UUID().uuidString
                setRandomCharacters()
                animateText()
            }
    }
    
    private func animateText() {
        let currentID = animationID
        for index in text.indices {
            let delay = CGFloat.random(in: 0...duration)
            var timerDuration: CGFloat = 0
            let timer = Timer.scheduledTimer(withTimeInterval: speed, repeats: true) { timer in
                if currentID != animationID {
                    timer.invalidate()
                } else {
                    timerDuration += speed
                    if timerDuration >= delay {
                        if text.indices.contains(index) {
                            let actualCharacter = text[index]
                            replaceCharacter(at: index, character: actualCharacter)
                        }
                        
                        timer.invalidate()
                    } else {
                        guard let randomCharacter = randomCharacters.randomElement() else { return }
                        replaceCharacter(at: index, character: randomCharacter)
                    }
                }
            }
            timer.fire()
        }
    }
    
    private func setRandomCharacters() {
        animatedText = text
        for index in animatedText.indices {
            guard let randomCharacter = randomCharacters.randomElement() else { return }
            replaceCharacter(at: index, character: randomCharacter)
        }
    }
    
    // Change Character at given Index
    private func replaceCharacter(at index: String.Index, character: Character) {
        guard animatedText.indices.contains(index) else { return }
        let indexCharacter = String(animatedText[index])
        
        if indexCharacter.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            animatedText.replaceSubrange(index...index, with: String(character))
        }
    }
    
}
