//
//  RecipeView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import URLImage

/*
 This is the view for the favorite recipes diplayed in myBook view. I use URLImage to load the image into the view, while loading I display a progressView. Below the image I display the recipe title and author.
 */
struct RecipeView: View {
    
    var favorite: RecipePost
    
    var body: some View {
        
        let url = URL(string: favorite.image)!
        
        VStack {
            URLImage(url: url,
                     empty: {
                        Image("default_image")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                     },
                     inProgress: { progress in
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .secondary))
                            .scaleEffect(1)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150, alignment: .center)
                        
                     },
                     failure: { error, retry in
                        Text("Failed loading image")
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 150, alignment: .center)
                        
                     },
                     content: { image, info in
                        image
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 150)
                            .clipped()
                     })
            
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
        }
        .frame(width: 150, height: 230)
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
