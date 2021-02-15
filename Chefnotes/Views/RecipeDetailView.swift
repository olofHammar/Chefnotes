//
//  RecipeDetailView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-11.
//

import SwiftUI
import Firebase

struct RecipeDetailView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    let thisRecipe: RecipePost
    var db = Firestore.firestore()
    @State var isFavorite = false
    @State private var ingredients = [Ingredient]()
    @State private var steps = [Step]()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                
                ImageView(withURL: thisRecipe.image)
                    .frame(width: UIScreen.main.bounds.width, height: 400)
                    .clipped()
                //                Image("pasta")
                //                    .resizable()
                //                    .scaledToFill()
                //                    .frame(width: UIScreen.main.bounds.width, height: 400)
                //                    .clipped()
                HStack {
                    Text(thisRecipe.title)
                        .subtitleFontStyle()
                    FavoriteButton(isSet: $isFavorite, recipe: thisRecipe)
                    Spacer()
                }
                .padding(.leading)
                HStack {
                    Image(systemName: "book")
                    Text("Author:")
                    Text(thisRecipe.author)
                    
                    Spacer()
                    
                    Image(systemName: "person.2")
                    Text("Serves: ")
                    Text("\(thisRecipe.serves)")
                }
                .padding()
                
                Text("Ingredients")
                    .subtitleFontStyle()
                    .padding()
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(ingredients) { ingredient in
                        VStack(alignment: .leading, spacing: 5) {
                            Text("\(ingredient.amount.stringWithoutZeroFractions) \(ingredient.amountUnit) \(ingredient.name)")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                            Divider()
                        }
                    }
                }.padding(.leading)
                
                Text("Instructions")
                    .subtitleFontStyle()
                    .padding()
                let sortedSteps = steps.sorted(by: { $0.orderNumber > $1.orderNumber })
                ForEach(sortedSteps.reversed()) {step in
                    VStack(alignment: .center, spacing: 5) {
                        if step.orderNumber != 0 {
                            Image(systemName: "chevron.down.circle")
                                .resizable()
                                .frame(width: 42, height: 42, alignment: .center)
                                .imageScale(.large)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(step.description)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .font(.subheadline)
                            .frame(minHeight: 100)
                    }
                }
            }
        }
        .background(grayBlue)
        .navigationTitle(thisRecipe.title)
        .navigationBarItems(trailing:
                                Button(action: {
                                }) {
                                    NavigationLink(destination: SettingsView()) {
                                        Text("Edit")
                                    }
                                })
        .onAppear() {
            checkIsFavorite()
            listenForIngredients()
            listenForSteps()
        }
    }
    
    func checkIsFavorite() {
        for i in 0...env.favoriteRecipes.count-1 {
            if env.favoriteRecipes[i].refId == thisRecipe.refId {
                isFavorite = true
                return
            }
            else {
                isFavorite = false
            }
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
        RecipeDetailView(thisRecipe: RecipePost(refId: "", title: "Pasta and sauce", serves: 4, author: "Olof Hammar", authorId: "", category: "", image: ""))
    }
}
