//
//  RecipeView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct RecipeView: View {
    
    var favorite: FavoriteRecipe
    
    var body: some View {
        
        VStack {
            favorite.image
                .resizable()
                .frame(height: 125)
                .scaledToFit()

                
            Text(favorite.title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(height: 75)
                .padding(.leading)
                .padding(.trailing)
            
            Text("by: Olle Hammar")
                .font(.caption2)
                .foregroundColor(Color.init(red: 136/255, green: 136/255, blue: 140/255))
                .frame(height: 50)
                .padding(.leading)
                .padding(.trailing)

        }.frame(width: 150, height: 250, alignment: .center)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.5))
        .clipped()
        .cornerRadius(5)
        .shadow(radius: 5)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(favorite: FavoriteRecipe(image: Image("steak-1"), title: "Steak with butter and rosemary"))
    }
}
