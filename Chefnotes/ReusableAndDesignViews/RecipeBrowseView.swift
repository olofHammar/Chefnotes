//
//  RecipeBrowseView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase
import URLImage

/*
 This view contains the recipe browse view used in category browser and search view.
 I use a ZStack in which I put a gradient blsck fade from top and bottom to center below the recipe image to make sure the text is more or less visable no matter how bright the image is. I then put the text on top of this.
 */

struct RecipeBrowseView: View {
    
    var recipe: RecipePost
    var postHeight: CGFloat = 400
    
    var body: some View {
        
        let url = URL(string: recipe.image)!
        
        ZStack {
            GeometryReader { geo in
            URLImage(url: url,
                     empty: {
                        Image("default_image")
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                            .clipped()
                     },
                     inProgress: { progress in
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                            .scaleEffect(3)
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                     },
                     failure: { error, retry in
                        Text("Failed loading image")
                            .frame(width: UIScreen.main.bounds.width, height: 400)
                     },
                     content: { image, info in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: geo.size.width)
                     })
            }
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.black.opacity(0.5)]), startPoint: .bottom, endPoint: .top)
                .frame(width: UIScreen.main.bounds.width-40, height: postHeight)
            
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .frame(width: UIScreen.main.bounds.width-40, height: postHeight)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(recipe.category) recipe")
                            .cardViewTopSub()
                        Text("\(recipe.title)")
                            .cardViewTitle()
                        Text("by: \(recipe.author)")
                            .cardViewBottomSub()
                    }
                    .padding(.leading)
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top)
                Spacer()
            }
            VStack {
                Spacer()
                HStack{
                    VStack(alignment: .leading){
                        HStack {
                            Image(systemName: "person.2")
                            Text("Serves: ")
                            Text("\(recipe.serves)")
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    Spacer()
                }
                .font(.system(size: 15, weight: .bold))
            }
        }
        .frame(width: UIScreen.main.bounds.width-40, height: postHeight)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 0.5))
        .cornerRadius(12)
        .shadow(radius: 8)
    }
}
struct RecipeBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeBrowseView(recipe: RecipePost(refId: "", title: "Pumpkin soup with bread", serves: 1, author: "Olof Hammar", authorId: "", category: "", image: ""))
    }
}

