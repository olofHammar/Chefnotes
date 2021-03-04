//
//  MyBookView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase

/*
 This is the first view presented. This view contains one horizontal scroll with users favorite recipes and one vertical scroll where user can select a category of recipes.
 */
struct MyBookView: View {
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(Color("ColorBackground"))
    }
    
    @EnvironmentObject var env: GlobalEnviroment
    private let db = Firestore.firestore()
    
    var body: some View {
        NavigationView {
            ScrollView {
                Spacer().frame(height: 30)
                HStack {
                    Text("Favorites")
                        .subtitleFontStyle()
                    Button(action: {})
                    {
                        NavigationLink (destination: CategoryBrowser(category: favoriteCat)) {
                            Text("See all")
                        }
                    }.smallTextButtonStyle()
                }
                .padding(.top, 50)
                .padding(.leading)
                .background(Color("ColorBackground"))
                
                ScrollView([.horizontal], showsIndicators: false) {
                    HStack (spacing: 50){
                        ForEach(env.favoriteRecipes) { recipe in
                            //I use geometryReader to "zoom in" on item at center of view
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
                .background(Color("ColorWhiteBlack"))
                .padding(.bottom, 30)
                
                HStack {
                    Text("Categories")
                        .subtitleFontStyle()
                    Button(action: {})
                    {
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
                                    Button(action: {})
                                    {
                                        NavigationLink(destination: SettingsView()) {
                                            Image(systemName: "person.circle")
                                                .personSettingsImageStyle()
                                        }
                                    })
            .navigationBarTitle("My Book")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("ColorBackground"))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            env.getFavoriteRecipes()
        }
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        
        let x = proxy.frame(in: .global).minX
        
        let newX = (x - (UIScreen.main.bounds.size.width/3))
        //abs = absolute value
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
