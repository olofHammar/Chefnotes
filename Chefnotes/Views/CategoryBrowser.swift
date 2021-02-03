//
//  CategoryBrowser.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

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
    
    let category: Category

    var body: some View {
        ZStack{
            Color.init(red: 242/255, green: 242/255, blue: 247/255)
                .ignoresSafeArea(edges: .all)
            ScrollView{
                VStack{
                    ForEach(favoritesList) { recipe in
                        RecipeBrowseView(favorite: recipe)
                            .padding()
                        Spacer()
                    }
                }
            }.background(grayBlue)
            Spacer()
                .navigationBarHidden(false)
                .navigationTitle(category.title)
                .navigationBarTitleDisplayMode(.inline)
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
