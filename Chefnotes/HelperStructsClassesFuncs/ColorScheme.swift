//
//  ColorScheme.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-24.
//

import Foundation
import SwiftUI

/*
 This struct handles light/dark-mode. I use AppStorage to save the latest selected colorScheme,
 so that when the app restarts it starts up in the last selected colorScheme
 */
public struct DarkModeViewModifier: ViewModifier {

    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    public func body(content: Content) -> some View {
        content
            .environment(\.colorScheme, isDarkMode ? .dark : .light)
            .preferredColorScheme(isDarkMode ? .dark : .light)
    }
}
