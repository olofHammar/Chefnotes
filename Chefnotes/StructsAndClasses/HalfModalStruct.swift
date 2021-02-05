//
//  HalfModalStruct.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-05.
//

import Foundation
import SwiftUI
import Combine

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

/*
 Mark -------------------> HalfModalHeight
 Denna funktion tar emot ett övre och undre värde som anger vart i proccessen vi är när vi drar våran modal upp och ner
 */
func fractionProgress(lowerLimit: Double = 0, upperLimit: Double, current: Double, inverted: Bool = false) -> Double {
    var val: Double = 0
    if current >= upperLimit {
        val = 1
    }
    else if current <= lowerLimit {
        val = 0
    }
    else {
        val = (current - lowerLimit)/(upperLimit - lowerLimit)
    }
    
    if inverted {
        return (1 - val)
    }
    else {
        return val
    }
}

enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
            
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}


