//
//  MyBookView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase

var categoryList: [Category] = [
    Category(id: 0, title: "Basics", imageName: "pickles"),
    Category(id: 1, title: "Vegetarian", imageName: "aubergine"),
    Category(id: 2, title: "Meat", imageName: "steak"),
    Category(id: 3, title: "Fish & seafood", imageName: "fish"),
    Category(id: 4, title: "Pasta", imageName: "spaguetti"),
    Category(id: 5, title: "Baking", imageName: "loaf"),
    Category(id: 6, title: "Deserts", imageName: "birthday-cake")]

var favoriteList: [FavoriteRecipe] = [
    
    FavoriteRecipe(image: Image("char"), title: "Smoked char with potatoes"),
    FavoriteRecipe(image: Image("milk"), title: "Milk and honey"),
    FavoriteRecipe(image: Image("steak-1"), title: "Steak and garlicbutter"),
    FavoriteRecipe(image: Image("eggplant"), title: "Grilled eggplant and condiments"),
    FavoriteRecipe(image: Image("greens"), title: "Lots of green stuff"),
    FavoriteRecipe(image: Image("pasta"), title: "Fettucini pasta with mushrooms"),
    FavoriteRecipe(image: Image("ravioli"), title: "Ricotta ravioli in tomato sauce"),
    FavoriteRecipe(image: Image("soup"), title: "Pumpkinsoup")
]

struct MyBookView: View {
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(grayBlue)
    }
    
    @EnvironmentObject var env: GlobalEnviroment
    @State var favoriteRecipeList = [RecipePost]()
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer()
                    .frame(height: 30)
                
                HStack {
                    Text("Favorites")
                        .subtitleFontStyle()
                    Button(action: {
                        //TODO
                        print("\(env.favoriteRecipes.count)")

                    }) {
                        Text("See all")
                        
                    }.smallTextButtonStyle()
                }
                .padding(.leading)
                .background(grayBlue)
                
                ScrollView(.horizontal) {
                    HStack (spacing: 50){
                        ForEach(env.favoriteRecipes) { recipe in
                            GeometryReader { proxy in
                                VStack {
                                    let scale = getScale(proxy: proxy)
                                    RecipeView(favorite: recipe)
                                        
                                        .scaleEffect(CGSize(width: scale, height: scale))
                                }
                            }
                            .frame(width: 125, height: 300)
                        }
                    }
                    .padding(.top, 50)
                }
                .background(Color.white)
                .padding(.bottom, 30)
                
                HStack {
                    Text("Categories")
                        .subtitleFontStyle()
                    Button(action: {
                        //TODO
                    }) {
                        Text("See all")
                        
                    }.smallTextButtonStyle()
                }.padding(.horizontal)
                
                List {
                    ForEach (categoryList) { cat in
                        NavigationLink (destination: CategoryBrowser(category: cat)) {
                            CategoryListView(category: cat)
                        }
                    }
                }.categoryListPadding()
                Spacer()
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                                    }) {
                                        NavigationLink(destination: SettingsView()) {
                                            Image(systemName: "person.circle")
                                                .personSettingsImageStyle()
                                        }
                                    })
            .navigationBarTitle("My Book")
            .background(grayBlue)
        }.onAppear() {
            env.getFavoriteRecipes()
        }
        
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        
        let x = proxy.frame(in: .global).minX
        
        let newX = (x - (UIScreen.main.bounds.size.width/3))
        //abs = absolut värde
        let difference = abs(newX)
        if difference < 100 {
            scale = 1 + (100 - difference) / 500
        }
        
        return scale
    }
    
    private func getFavoriteRecipes() {
        db.collection("recipe").whereField("id", isEqualTo: env.currentUser.favoriteRecipes)
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.favoriteRecipeList = documents.map { queryDocumentSnapshot -> RecipePost in
                
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

struct MyBookView_Previews: PreviewProvider {
    static var previews: some View {
        MyBookView().environmentObject(GlobalEnviroment())
    }
}
struct FavoriteRecipe: Identifiable {
    var id = UUID()
    var image: Image
    var title: String
}
