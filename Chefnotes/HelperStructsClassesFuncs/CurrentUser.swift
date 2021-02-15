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
    
    init(id: String, firstName: String, lastName: String, password: String, email: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.password = password
        self.email = email
    }
}

class GlobalEnviroment: ObservableObject {
    
    @Published var currentUser: CurrentUser = CurrentUser.init(id: "", firstName: "", lastName: "", password: "", email: "")
    
    @Published var favoriteRecipes = [RecipePost]()
    
    func getFavoriteRecipes() {
        
        let db = Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")")
        let docRef = db.collection("favoriteRecipes")
            docRef.addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
                self.favoriteRecipes = documents.map { queryDocumentSnapshot -> RecipePost in
                
                let data = queryDocumentSnapshot.data()
                let refId = data["refId"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let serves = data["serves"] as? Int ?? 0
                let author = data["author"] as? String ?? ""
                let authorId = data["authorId"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                
                return RecipePost(refId: refId, title: title, serves: serves, author: author, authorId: authorId, category: category, image: image)
            }
        }
    }
}


