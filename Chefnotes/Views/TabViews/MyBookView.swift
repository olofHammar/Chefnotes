//
//  MyBookView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase

let categoryList: [Category] = [
    Category(id: 0, title: "Basics", imageName: "pickles"),
    Category(id: 1, title: "Vegetarian", imageName: "aubergine"),
    Category(id: 2, title: "Meat", imageName: "steak"),
    Category(id: 3, title: "Fish & Seafood", imageName: "fish"),
    Category(id: 4, title: "Pasta", imageName: "spaguetti"),
    Category(id: 5, title: "Baking", imageName: "loaf"),
    Category(id: 6, title: "Deserts", imageName: "birthday-cake")]
let favoriteCat = Category(id: 7, title: "Favorites", imageName: "loaf")
let showAllMyRecipes = Category(id: 8, title: "My recipes", imageName: "loaf")

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
                            print("\(env.favoriteRecipes.count)")
                        }) {
                            NavigationLink (destination: CategoryBrowser(category: favoriteCat)) {
                            Text("See all")
                            }
                        }.smallTextButtonStyle()
                    
                }
                .padding(.top, 50)
                .padding(.leading)
                .background(grayBlue)
                
                ScrollView([.horizontal], showsIndicators: false) {
                    HStack (spacing: 50){
                        ForEach(env.favoriteRecipes) { recipe in
                            GeometryReader { proxy in
                                VStack {
                                    let scale = getScale(proxy: proxy)
                                    NavigationLink(
                                        destination: RecipeDetailView(thisRecipe: recipe)) {
                                        RecipeView(favorite: recipe)
                                            .scaleEffect(CGSize(width: scale, height: scale))
                                    }.ignoresSafeArea(.all)
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .frame(width: 125, height: 300)
                        }
                    }
                    .padding(.top, 50)
                }
                .frame(height: 300)
                .background(Color.white)
                .padding(.bottom, 30)
                
                HStack {
                    Text("Categories")
                        .subtitleFontStyle()
                    Button(action: {
                        //TODO
                    }) {
                        NavigationLink (destination: CategoryBrowser(category: showAllMyRecipes)) {
                        Text("See all")
                        }
                        
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
            .navigationBarTitleDisplayMode(.inline)
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
}

struct MyBookView_Previews: PreviewProvider {
    static var previews: some View {
        MyBookView().environmentObject(GlobalEnviroment())
    }
}
