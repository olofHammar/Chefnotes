//
//  FavoriteButton.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-15.
//

import SwiftUI
import Firebase
import SPAlert

struct FavoriteButton: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    @Binding var isSet: Bool
    let recipe: RecipePost
    private let db = Firestore.firestore()

    var body: some View {
        
        Button(action: {
            isSet.toggle()
            if isSet == true {
                print("Added to favorites")
                addFavorite(completion: { _ in
                    let alertView = SPAlertView(title: "Recipe added!", message: "The recipe has been saved to your favorite recipes.", preset: SPAlertIconPreset.done)
                    alertView.present(duration: 2)
                    
                })
            }
            else if isSet == false {
                print("Removed from favorites")
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
    func addFavorite(completion: @escaping (Any) -> Void, showDetails: Bool = false) {
        let db = Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")")
        let docRef = db.collection("favoriteRecipes").document(recipe.refId)
        print("Setting data")
        docRef.setData(recipe.dictionary) { error in
            if let err = error {
                print("error \(err)")
            }
            else {
                print("Steps uploaded succefully")
                completion(true)
                if showDetails {
                    print("Data uploaded \(recipe.dictionary)")
                }
            }
            
        }
    }
    private func deleteFavorite(completion: @escaping (Any) -> Void, showDetails: Bool = false) {
        let db = Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")")
        let docRef = db.collection("favoriteRecipes").document(recipe.refId)
        docRef.delete() { error in
            if let err = error {
                print("error \(err)")
            }
            else {
                print("Steps uploaded succefully")
                completion(true)
                if showDetails {
                    print("Data uploaded \(recipe.dictionary)")
                }
            }
        }
    }
}

struct FavoriteButton_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteButton(isSet: .constant(true), recipe: RecipePost(refId: "", title: "", serves: 1, author: "", authorId: "", category: "", image: "")).environmentObject(GlobalEnviroment())
    }
}
