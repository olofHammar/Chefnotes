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
    var postHeight: CGFloat = 320
    var db = Firestore.firestore()
    @State var ingredients = [Ingredient]()
    
    var body: some View {
        ZStack {
            ImageView(withURL: recipe.image)
            
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
        }.onAppear(){
            listenToFirestore()
            print("\(ingredients.count)")
            print("\(recipe.refId)")
        }
        .frame(width: UIScreen.main.bounds.width, height: postHeight)
    }

    func listenToFirestore() {
        let itemRef = db.collection("recipe").document("\(recipe.refId)")
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
//    func listenForIngredients() {
//        let itemRef = db.collection("recipe").document("\(recipe.id)")
//        itemRef.collection("ingredients").addSnapshotListener { (snapshot, err) in
//            if let err = err {
//                print("Error getting document \(err)")
//            } else {
//                //items.removeAll()
//                for document in snapshot!.documents {
//
//                    let result = Result {
//                        try document.data(as: Ingredient.self)
//                    }
//                    switch result {
//                    case .success(let item):
//                        if let item = item {
//                            //print("\(item)")
//                            ingredients.append(item)
//                        } else {
//                            print("Document does not exist")
//                        }
//                    case .failure(let error):
//                        print("Error decoding item: \(error)")
//                    }
//                }
//            }
//        }
//}
}
//struct RecipeBrowseView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeBrowseView(withURL: RecipePost(title: "", steps: [], ingredients: [], serves: 1, author: "", authorId: "", category: "", image: ""))
//    }
//}
