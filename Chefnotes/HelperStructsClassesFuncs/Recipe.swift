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
    
    @EnvironmentObject var env: GlobalEnviroment
    
    var id = UUID()
    var title : String
    var steps: [Step]
    var ingredients: [Ingredient]
    var serves: Int
    var author: String
    var authorId : String
    var category: String
    var image: String
    
    var dictionary: [String: Any] {
        return [
            "id" : id.uuidString,
            "title" : title,
            "steps" : steps.formatForFirebase(),
            "ingredients" : ingredients.formatForFirebase(),
            "serves" : serves,
            "author" : author,
            "authorId" : authorId,
            "category" : category,
            "image" : image
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
