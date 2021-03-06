//
//  Recipe.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-05.
//

import Foundation
import SwiftUI
import Combine
import FirebaseFirestoreSwift


/*
 This file contains all structs used to create recipes. When a recipe is created I use the recipePosts refId as the documentId and in this document I save the recipePost and two subcollections containing ingredients and steps.
 This way I can load just the needed data. In for example search view I dont need ingredients and steps so I load only the recipePost.
 I use dictionary to save everything in firestore.
 */

struct RecipePost: Identifiable {
    
    @EnvironmentObject var env: GlobalEnviroment
    
    var id = UUID()
    var refId : String
    var title : String
    var serves: Int
    var author: String
    var authorId : String
    var category: String
    var image: String
    
    var dictionary: [String: Any] {
        return [
            "id" : id.uuidString,
            "refId" : refId,
            "title" : title,
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
