//
//  CategoryListView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

//This view contains the row view for the category list in my book view.

struct CategoryListView: View {
    
    var category: Category

    var body: some View {
        HStack{
            Image(category.imageName)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .shadow(radius: 3)
                    .overlay(
                        Circle().stroke(Color.white))
            Text(category.title)
                    .font(.headline)
                    .padding()
                
                Spacer()
        }
        .padding()
    }
}

struct CategoryListView_Previews: PreviewProvider {
    static var category = Category(id: 0, title: "pizza", imageName: "pizza")

    static var previews: some View {
        CategoryListView(category: category)
    }
}
