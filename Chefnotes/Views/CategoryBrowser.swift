//
//  CategoryBrowser.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CategoryBrowser: View {
    
    @State  var recipes = [RecipePost]()
    @State  var ingredients = [Ingredient]()
    private let db = Firestore.firestore()
    let category: Category
    
    var body: some View {
        
    let thisCategory = category.title
        
        ZStack{
            grayBlue
                .ignoresSafeArea(edges: .all)
            ScrollView{
                VStack{
                    ForEach(recipes) { recipe in
                        if recipe.category == thisCategory {
                            NavigationLink(destination: RecipeDetailView(thisRecipe: recipe)) {
                            RecipeBrowseView(recipe: recipe)
                                .padding()
                            }.buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                    }
                }
            }
            .background(grayBlue)
            Spacer()
            
             //   .navigationBarHidden(false)
                .navigationTitle(category.title)
                .navigationBarTitleDisplayMode(.inline)
        }.onAppear() {
            listenForRecipes()
        }
    
    }
    private func listenForRecipes() {
        
        db.collection("recipe").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.recipes = documents.map { queryDocumentSnapshot -> RecipePost in
                
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
/*
 (data["ingredients"] as? [[String:Any]]).map { item -> Ingredient in
 return Ingredient(name: item["name"] as? String ?? "", amount: item["amount"] as? Double ?? 0.0, amountUnit: item["amountUnit"] as? String ?? "", orderNumber: item["orederNumber"] as? Int ?? 0)
 */
