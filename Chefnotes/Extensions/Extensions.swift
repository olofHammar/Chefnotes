//
//  Extensions.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-04.
//

import Foundation
import SwiftUI
import Combine
import URLImage

//MARK ---------------------------> Buttons
extension Button {
    
    func blueButtonStyle() -> some View {
        self
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            .padding()
            .font(.headline)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(12)
    }
    
    func smallTextButtonStyle() -> some View {
        self
            .padding(.horizontal)
            .font(.subheadline)
    }
}

//MARK ---------------------------> Text

extension Text {
    
    func subtitleFontStyle() -> some View {
        self
            .font(.title2)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    func cardViewTopSub() -> some View {
        self
            .font(Font.system(.body).smallCaps())
            .fontWeight(.bold)
            .foregroundColor(.init(white: 0.8)).opacity(0.8)
    }
    func cardViewTitle() -> some View {
        self
            .font(.system(size: 36, weight: .bold, design: .default))
            .lineLimit(2)
    }
    func cardViewBottomSub() -> some View {
        self
            .font(.system(size: 18, weight: .bold, design: .default))
            .foregroundColor(.init(white: 0.8)).opacity(0.8)
            .lineLimit(2)
    }
}

//MARK ---------------------------> Image

extension Image {
    
    func personSettingsImageStyle() -> some View {
        self
            .resizable()
            .frame(width: UIScreen.main.bounds.size.width/15, height: UIScreen.main.bounds.size.width/15)
            .padding(.top, 5)
            .scaledToFit()
    }
    
    func newRecipeImageStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .clipped()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200, alignment: .center)
    }
}


//MARK ---------------------------> List

extension List {
    
    func categoryListPadding() -> some View {
        self
            .frame(height: UIScreen.main.bounds.size.height/1.89)
            .overlay(RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 0.5))
            .cornerRadius(12)
            .shadow(radius: 5)
            .padding()
    }
}

//MARK ---------------------------> Keyboard
struct KeyboardAwareModifier: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    
    private var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        Publishers.Merge(
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillShowNotification)
                .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
                .map { $0.cgRectValue.height },
            NotificationCenter.default
                .publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        ).eraseToAnyPublisher()
    }
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, keyboardHeight)
            .onReceive(keyboardHeightPublisher) { self.keyboardHeight = $0 }
    }
}

extension View {
    func KeyboardAwarePadding() -> some View {
        ModifiedContent(content: self, modifier: KeyboardAwareModifier())
    }
}

//MARK ---------------------------> Double
extension Double {
    var stringWithoutZeroFractions: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) :String(self)
    }
}

//MARK ---------------------------> Array
extension Array where Element == Step {
    func formatForFirebase() -> [[String:Any]] {
        var returnVal: [[String:Any]] = []
        for element in self {
            returnVal.append(element.dictionary)
        }
        
        return returnVal
    }
}

extension Array where Element == Ingredient {
    func formatForFirebase() -> [[String:Any]] {
        var returnVal: [[String:Any]] = []
        for element in self {
            returnVal.append(element.dictionary)
        }
        
        return returnVal
    }
}

