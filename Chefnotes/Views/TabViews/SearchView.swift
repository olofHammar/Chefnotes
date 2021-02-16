//
//  SearchView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase
import URLImage

struct SearchView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    
    @State var recipes = [RecipePost]()
    @State var searchText = ""
    @State var isSearching = false
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView{
                    
                    VStack{
                        SearchBar(searchText: $searchText, isSearching: $isSearching)
                        Spacer()
                            .frame(height: 20)
                        ForEach(recipes.filter { $0.title.contains(searchText) || $0.category.contains(searchText) || $0.author.contains(searchText) || searchText.isEmpty }) { recipe in
                            NavigationLink(destination: RecipeDetailView(thisRecipe: recipe)) {
                                RecipeBrowseView(recipe: recipe)
                                    .padding()
                            }.buttonStyle(PlainButtonStyle())
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle("Search View")
            .navigationBarTitleDisplayMode(.inline)
            
        }.onAppear() {
            listenForRecipes()
        }
    }
    private func listenForRecipes() {
        
        db.collection("recipe")
            .addSnapshotListener { (querySnapshot, error) in
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(GlobalEnviroment())
    }
}
