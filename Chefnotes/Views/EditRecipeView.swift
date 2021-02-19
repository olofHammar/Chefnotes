//
//  EditRecipeView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-19.
//

import SwiftUI

struct EditRecipeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
//    @Binding var recipe: RecipePost
//    @Binding var ingredients: [Ingredient]
//    @Binding var instructions: [Step]
     var recipe = RecipePost(refId: "", title: "", serves: 1, author: "", authorId: "", category: "", image: "")
     var ingredients = [Ingredient]()
     var instructions = [Step]()
    
    var body: some View {
        NavigationView {
            ZStack {
                Form {
                    Text("This is edit view")
                }
                .navigationTitle("Edit recipe")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button(action: {dismissModal()}) {
                    Image(systemName: "x.circle")
                        .personSettingsImageStyle()
                        .padding(.bottom, 2)
                })
            }
        }
    }
    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        EditRecipeView()
    }
}
