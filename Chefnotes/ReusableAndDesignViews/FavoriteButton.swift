//
//  FavoriteButton.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-15.
//

import SwiftUI
import Firebase
import SPAlert

/*
 This view contains the favorite button. I use a binding bool to pass the bool from recipe detail view. When clicked I add or delete the recipe from the users favorite recipes list and update the star image to be filled or not depending on bool value.
 */

struct FavoriteButton: View {
    
    @Binding var isSet: Bool
    let recipe: RecipePost
    private let db = Firestore.firestore()
    
    var body: some View {
        
        Button(action: {
            isSet.toggle()
            if isSet == true {
                addFavorite(completion: { _ in
                    
                    let alertView = SPAlertView(title: "Recipe added!", message: "The recipe has been saved to your favorite recipes.", preset: SPAlertIconPreset.done)
                    alertView.present(duration: 2)
                    
                })
            }
            else if isSet == false {
                deleteFavorite(completion: { _ in
                    let alertView = SPAlertView(title: "Recipe removed!", message: "The recipe has been removed from your favorite recipes.", preset: SPAlertIconPreset.done)
                    alertView.present(duration: 2)
                    
                })
            }
        }) {
            Image(systemName: isSet ? "star.fill" : "star")
                .foregroundColor(isSet ? Color.yellow : Color.gray)
        }
    }
    func addFavorite(completion: @escaping (Any) -> Void) {
        let db = Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")")
        let docRef = db.collection("favoriteRecipes").document(recipe.refId)
        docRef.setData(recipe.dictionary) { error in
            if let err = error {
                print("error \(err)")
            }
            else {
                completion(true)
                print("Recipe added to favorites: \(recipe.dictionary)")
                
            }
            
        }
    }
    private func deleteFavorite(completion: @escaping (Any) -> Void) {
        let db = Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")")
        let docRef = db.collection("favoriteRecipes").document(recipe.refId)
        docRef.delete() { error in
            if let err = error {
                print("error \(err)")
            }
            else {
                completion(true)
                print("Recipe deleted from favorites: \(recipe.dictionary)")
            }
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true), recipe: RecipePost(refId: "", title: "", serves: 1, author: "", authorId: "", category: "", image: "")).environmentObject(GlobalEnviroment())
    }
}
