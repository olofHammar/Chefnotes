//
//  RecipeBrowseView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase

struct RecipeBrowseView: View {
    
    @State var recipeImage: UIImage?
    var recipe: RecipePost
    var postHeight: CGFloat = 320
    
    var body: some View {
        ZStack {
                Image("default_image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: postHeight)
                    .clipped()
                    .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
            
            HStack {
                
                Spacer()
                
                Text(recipe.title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.leading)
                    .padding(.trailing)
                
                Spacer()
                
                Image(systemName: "ellipsis.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.trailing)
                    .foregroundColor(.blue)
                
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/11)
            .background(Color.white).opacity(0.9)
            .padding(.bottom, 253)

            VStack {
                Spacer()
                HStack{
                    VStack(alignment: .leading){
                        HStack {
                            Image(systemName: "book")
                            Text("Author:")
                            Text(recipe.author)
                        }
                        .padding(.bottom, 2)
                        HStack {
                            Image(systemName: "timer")
                            Text("Cookingtime: ")
                            Text("30 min")
                        }
                    }
                    .foregroundColor(.white)
                    .padding()
                    
                    Spacer()
                }
                .font(.system(size: 15, weight: .bold))
            }
        }.onAppear() {
            getImage()
        }
        .frame(width: UIScreen.main.bounds.width, height: postHeight)
    }
    
    private func getImage() {
        let Ref = Storage.storage().reference(forURL: recipe.image)
        Ref.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if error != nil {
                print("Error: Image could not download!")
            } else {
                self.recipeImage = UIImage(data: data!)!
            }
        }
    }
}

struct RecipeBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeBrowseView(recipe: RecipePost(title: "", steps: [], ingredients: [], serves: 1, author: "", authorId: "", category: "", image: ""))
    }
}
