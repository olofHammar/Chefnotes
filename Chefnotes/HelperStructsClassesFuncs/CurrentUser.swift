//
//  User.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import Foundation
import SwiftUI
import Combine
import Firebase

class CurrentUser: Identifiable {
    
    
    var id : String
    var firstName: String
    var lastName: String
    var password: String
    var email: String
    var favoriteRecipes: [String] = []
    
    init(id: String, firstName: String, lastName: String, password: String, email: String, favoriteRecipes: [String]) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
        self.favoriteRecipes = favoriteRecipes
    }
}

class GlobalEnviroment: ObservableObject {
    
    @Published var currentUser: CurrentUser = CurrentUser.init(id: "", firstName: "", lastName: "", password: "", email: "", favoriteRecipes: [])
}

