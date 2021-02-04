//
//  Extensions.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-04.
//

import Foundation
import SwiftUI


//MARK ---------------------------> Buttons
extension Button {
    
    func blueButtonStyle() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.size.width/1.5, height: UIScreen.main.bounds.size.height/16)
            .background(Color.blue)
            .cornerRadius(8)
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
            .frame(height: UIScreen.main.bounds.size.height/3)
            .cornerRadius(4)
    }
    
    func newRecipePlusButtonImageStyle() -> some View {
        self
            .resizable()
            .scaledToFit()
            .frame(width: UIScreen.main.bounds.size.width/8.5)
            .foregroundColor(.white)
            .shadow(radius: 2)
            .padding(.leading, 165)
            .padding(.bottom, 165)
    }
}

//MARK ---------------------------> Image

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
