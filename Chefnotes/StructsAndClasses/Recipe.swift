//
//  Recipe.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-05.
//

import Foundation
import SwiftUI
import Combine


struct RecipePost: Identifiable {
    
    var id = UUID()
    var steps: [Step]
    var ingredients: [Ingredient]
    var serves: Int
    var author: String
    var description: String
    var category: String
    var image: Image
    
    var dictionary: [String: Any] {
        return [
            "id" : id.uuidString,
            "steps" : steps.formatForFirebase(),
            "ingredients" : ingredients.formatForFirebase(),
            "serves" : serves,
            "author" : author,
            "description" : description,
            "category" : category
        ]
    }
}

enum IngredientUnit: String, CaseIterable {
    case g = "g"
    case kg = "kg"
    case ml = "ml"
    case L = "l"
    case tsp = "tsp"
    case tbs = "tbs"
    case pcs = "pcs"
    case sprigs = "sprigs"
}

struct Ingredient: Identifiable {
    
    var id = UUID()
    var name: String
    var amount: Double
    var amountUnit: String
        //IngredientUnit
    var orderNumber: Int
    
    var dictionary: [String: Any] {
        return [
            "id" : id.uuidString,
            "name" : name,
            "amount" : amount,
            "amountUnit" : amountUnit,
            "orderNumber" : orderNumber
        ]
    }
}

struct Step: Identifiable {
    
    var id = UUID()
    var description: String
    var orderNumber: Int
    
    var dictionary: [String: Any] {
        [
            "id" : id.uuidString,
            "description" : description,
            "orderNumber" : orderNumber
        ]
    }
}

enum newStepOrIngredient {
    case Step, Ingredient
}
