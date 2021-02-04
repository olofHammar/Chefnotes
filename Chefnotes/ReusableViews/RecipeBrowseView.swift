//
//  RecipeBrowseView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct RecipeBrowseView: View {
    
    var favorite: FavoriteRecipe

    var body: some View {
        VStack {
            ZStack{
            favorite.image
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.size.width-50, height: 270)
                .cornerRadius(5)
            Text(favorite.title)
                
                .font(.title3)
                .fontWeight(.semibold)
                .frame(width: UIScreen.main.bounds.size.width-50, height: 60)
                .background(Color.white).opacity(0.9)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.top, 210)
                .padding(.horizontal, 12)
            }
            
            HStack{
            VStack {
                HStack{
                    Image(systemName: "timer")
                        .resizable()
                        .frame(height: 18)
                        .scaledToFit()
            Text("Cookingtime: 30 min")
                .font(.subheadline)
                }
                HStack{
                    Image(systemName: "book")
                        .resizable()
                        .frame(height: 18)
                        .scaledToFit()
            Text("Author: Olle Hammar")
                .font(.subheadline)
            }
            }.padding(.bottom)
                Spacer()
            }.padding(.leading)
            .padding(.top, 10)
            
        }.frame(width: UIScreen.main.bounds.size.width-50, height: 353)
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(lineWidth: 0.5))
        .background(Color.white)
    }
}

struct RecipeBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeBrowseView(favorite: FavoriteRecipe(image: Image("steak-1"), title: "Steak with butter and rosemary"))
    }
}
