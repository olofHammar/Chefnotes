//
//  RecipeDetailView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-11.
//

import SwiftUI
import Firebase

struct RecipeDetailView: View {
    
    let thisRecipe: RecipePost
    var db = Firestore.firestore()
    @State private var ingredients = [Ingredient]()
    @State private var steps = [Step]()
    
    var body: some View {
        
        
        Form {
            Section {
                Text("Author: \(thisRecipe.author)")
            }
            Section(header: Text("Recipe ingredients")) {
                
                ScrollView() {
                    ForEach(ingredients.reversed(), id: \.id) { ingredient in
                        Text("\(ingredient.amount.stringWithoutZeroFractions) \(ingredient.amountUnit) \(ingredient.name)")
                            .padding()
                        
                    }.frame(width: 340)
                }.frame(height: 200)
            }
            Section(header: Text("Recipe steps")) {
                
                ScrollView() {
                    let sortedSteps = steps.sorted(by: { $0.orderNumber > $1.orderNumber })
                    ForEach(sortedSteps.reversed(), id: \.id) { thisStep in
                        Text("\(thisStep.orderNumber+1) " + thisStep.description)
                            .padding()
                        
                    }.frame(width: 340)
                }.frame(height: 200)
            }
        }.onAppear() {
            listenForIngredients()
            listenForSteps()
        }
    }
    func listenForSteps() {
        let itemRef = db.collection("recipe").document("\(thisRecipe.refId)")
        itemRef.collection("steps").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.steps = documents.map { queryDocumentSnapshot -> Step in
                
                let data = queryDocumentSnapshot.data()
                let description = data["description"] as? String ?? ""
                let orderNumber = data["orderNumber"] as? Int ?? 0
                
                return Step(description: description, orderNumber: orderNumber)
            }
        }
    }
    func listenForIngredients() {
        let itemRef = db.collection("recipe").document("\(thisRecipe.refId)")
        itemRef.collection("ingredients").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.ingredients = documents.map { queryDocumentSnapshot -> Ingredient in
                
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let amount = data["amount"] as? Double ?? 0.0
                let amountUnit = data["amountUnit"] as? String ?? ""
                let orderNumber = data["orderNumber"] as? Int ?? 0
                //print("\(ingredients)")
                
                return Ingredient(name: name, amount: amount, amountUnit: amountUnit, orderNumber: orderNumber)
                
            }
        }
    }
}

struct RecipeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeDetailView(thisRecipe: RecipePost(refId: "", title: "Pasta", serves: 2, author: "Olle", authorId: "", category: "", image: ""))
    }
}
