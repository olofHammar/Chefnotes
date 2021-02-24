//
//  RecipeDetailView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-11.
//

import SwiftUI
import Firebase
import URLImage

struct RecipeDetailView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    @State var isPresented = false
    var thisRecipe: RecipePost
    var db = Firestore.firestore()
    @State var isFavorite = false
    @State private var ingredients = [Ingredient]()
    @State private var steps = [Step]()
    
    var body: some View {
        
        let url = URL(string: thisRecipe.image)!
        
        ScrollView(showsIndicators: false) {
            VStack {
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
                                .scaledToFill()
                                .frame(width: UIScreen.main.bounds.width, height: 400)
                                .clipped()
                         })
                //                                recipeImage
                //                                    .resizable()
                //                                    .scaledToFill()
                //                                    .frame(width: UIScreen.main.bounds.width, height: 400)
                //                                    .clipped()
                HStack {
                    Text(thisRecipe.title)
                        .subtitleFontStyle()
                    Spacer()
                    FavoriteButton(isSet: $isFavorite, recipe: thisRecipe)
                    
                }
                .padding(.horizontal)
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
                            if ingredient.amountUnit == "-" {
                                Text("\(ingredient.name)")
                            }
                            else {
                                Text("\(ingredient.amount.stringWithoutZeroFractions) \(ingredient.amountUnit) \(ingredient.name)")
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                            }
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
        .background(Color("ColorBackground"))
        .navigationBarItems(trailing:
                                NavigationLink(destination: EditRecipeView(thisRecipe: thisRecipe, ingredients: ingredients, steps: steps.sorted(by: {$0.orderNumber < $1.orderNumber}))) {
                                    if thisRecipe.authorId == env.currentUser.id {
                                        Text("Edit")
                                    }
                                }
        )
        .onAppear() {
            checkIsFavorite()
            listenForIngredients()
            listenForSteps()
            //URLImageService.shared.cleanup()
        }
    }
    
    func showEditView() {
        isPresented.toggle()
    }
    func checkIsFavorite() {
        if env.favoriteRecipes.count > 0 {
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
