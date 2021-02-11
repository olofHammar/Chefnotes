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

var favoritesList: [FavoriteRecipe] = [
    
    FavoriteRecipe(image: Image("char"), title: "Smoked char with potatoes"),
    FavoriteRecipe(image: Image("milk"), title: "Milk and honey"),
    FavoriteRecipe(image: Image("steak-1"), title: "Steak and garlicbutter"),
    FavoriteRecipe(image: Image("eggplant"), title: "Grilled eggplant and condiments"),
    FavoriteRecipe(image: Image("greens"), title: "Lots of green stuff"),
    FavoriteRecipe(image: Image("pasta"), title: "Fettucini pasta with mushrooms"),
    FavoriteRecipe(image: Image("ravioli"), title: "Ricotta ravioli in tomato sauce"),
    FavoriteRecipe(image: Image("soup"), title: "Pumpkinsoup")]

struct CategoryBrowser: View {
    
    @State var recipes = [RecipePost]()
    @State var ingredients = [Ingredient]()
    var db = Firestore.firestore()
    let category: Category
    var body: some View {
        let thisCategory = category.title
        ZStack{
            Color.init(red: 242/255, green: 242/255, blue: 247/255)
                .ignoresSafeArea(edges: .all)
            ScrollView{
                VStack{
                    ForEach(recipes) { recipe in
                        if recipe.category == thisCategory {
                            RecipeBrowseView(recipe: recipe)
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
            .background(grayBlue)
            Spacer()
                .navigationBarHidden(false)
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
