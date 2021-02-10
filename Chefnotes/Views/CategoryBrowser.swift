//
//  CategoryBrowser.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase
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
                let title = data["title"] as? String ?? ""
                let steps = data["steps"] as? [Step] ?? []
                let ingredients = data["ingredients"] as? [Ingredient] ?? []
                let serves = data["serves"] as? Int ?? 0
                let author = data["author"] as? String ?? ""
                let authorId = data["authorId"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                
                return RecipePost(title: title, steps: steps, ingredients: ingredients, serves: serves, author: author, authorId: authorId, category: category, image: image)
                
            }
        }
    }
}

struct CategoryBrowser_Previews: PreviewProvider {
    static var pCategory = Category(id: 0, title: "Pizza", imageName: "pizza")
    static var previews: some View {
        Group {
            CategoryBrowser(category: pCategory)
            CategoryBrowser(category: pCategory)
        }
    }
}
