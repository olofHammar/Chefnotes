//
//  RecipeCategories.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import Foundation
import SwiftUI

//This file contains the struct for categories

struct Category: Identifiable {
    var id : Int
    var title: String
    
    var imageName: String
    var image: Image {
        Image(imageName)
    }
    
}
