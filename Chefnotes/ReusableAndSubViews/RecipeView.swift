//
//  RecipeView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct RecipeView: View {
    
    var favorite: RecipePost
    
    var body: some View {
        
        VStack {
            ImageView(withURL: favorite.image)
                .frame(height: 150)
                .clipped()
//            Image("pasta")
//                .resizable()
//                .scaledToFill()
//                .frame(height: 150)
//                .clipped()
                
            Spacer()
            Group {
            Text(favorite.title)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.leading)
                .padding(.trailing)

                Text("Author: \(favorite.author)")
                .font(.caption2)
            }.padding(.bottom)
        }.frame(width: 150, height: 230)
        .overlay(RoundedRectangle(cornerRadius: 5).stroke(lineWidth: 0.5))
        .clipped()
        .cornerRadius(5)
        .shadow(radius: 5)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(favorite: RecipePost(refId: "", title: "Pasta", serves: 4, author: "Olle Hammar", authorId: "", category: "", image: ""))
    }
}
