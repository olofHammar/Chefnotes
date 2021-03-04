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

let categoryList: [Category] = [
    Category(id: 0, title: "Basics", imageName: "pickles"),
    Category(id: 1, title: "Starters", imageName: "carrot"),
    Category(id: 2, title: "Snacks", imageName: "fries"),
    Category(id: 3, title: "Vegetarian", imageName: "aubergine"),
    Category(id: 4, title: "Meat", imageName: "steak"),
    Category(id: 5, title: "Fish & Seafood", imageName: "fish"),
    Category(id: 6, title: "Pasta", imageName: "spaguetti"),
    Category(id: 7, title: "Baking", imageName: "loaf"),
    Category(id: 8, title: "Deserts", imageName: "birthday-cake")]
let favoriteCat = Category(id: 7, title: "Favorites", imageName: "loaf")
let showAllMyRecipes = Category(id: 8, title: "My recipes", imageName: "loaf")
