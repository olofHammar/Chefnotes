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
    
    
    var id = UUID()
    var firstName: String
    var lastName: String
    var password: String
    var email: String
    
    init(firstName: String, lastName: String, password: String, email: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
    }
}

class GlobalEnviroment: ObservableObject {
    
    @Published var currentUser: CurrentUser = CurrentUser.init(firstName: "", lastName: "", password: "", email: "")
}

