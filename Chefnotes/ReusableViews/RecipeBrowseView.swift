//
//  RecipeBrowseView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase

struct RecipeBrowseView: View {
    
    @State var recipe: RecipePost
    var postHeight: CGFloat = 400
    
    var body: some View {
        ZStack {
            ImageView(withURL: recipe.image)
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .clipped()
            //            Image("soup")
            //                .resizable()
            //                .scaledToFill()
            //                .frame(width: UIScreen.main.bounds.width, height: 400)
            //                .clipped()
            
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.black.opacity(0.5)]), startPoint: .bottom, endPoint: .top)
                .frame(width: UIScreen.main.bounds.width-40, height: postHeight)
            
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)
                .frame(width: UIScreen.main.bounds.width-40, height: postHeight)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("A recipe by: \(recipe.author)"
                        )
                        .font(.system(size: 18, weight: .bold, design: .default))
                        .foregroundColor(.init(white: 0.8)).opacity(0.6)
                        .lineLimit(2)
                        Text("\(recipe.title)")
                            .font(.system(size: 36, weight: .bold, design: .default))
                    }
                    .padding(.leading)
                    .foregroundColor(.white)
                    Spacer()
                }
                .padding(.top)
                .padding(.leading)
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
            }.padding(.horizontal)
        }
        .frame(width: UIScreen.main.bounds.width-40, height: postHeight)
        .cornerRadius(12)
        .shadow(radius: 15)
        
    }
}
struct RecipeBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeBrowseView(recipe: RecipePost(refId: "", title: "Pumpkin soup with bread", serves: 1, author: "Olof Hammar", authorId: "", category: "", image: ""))
    }
}
