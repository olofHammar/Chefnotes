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
//            Image("soup")
//                .resizable()
//                .scaledToFill()
//                .frame(width: UIScreen.main.bounds.width, height: 320)
//                .clipped()
//                .background(Color.init(red: 0.9, green: 0.9, blue: 0.9))
            LinearGradient(gradient: Gradient(colors: [Color.clear, Color.clear, Color.black]), startPoint: .top, endPoint: .bottom)
            
            HStack {
                Text(recipe.title)
                    .subtitleFontStyle()
//                    .font(.system(.title2 , design: .serif))
//                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .padding(.leading)
                    .padding(.trailing)
                
                Spacer()
                
                Image(systemName: "bookmark")
                    .font(Font.title.weight(.light))
                    .imageScale(.small)
                    .padding(.trailing)
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
                      
                            Spacer()
                            
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
                
                return Ingredient(name: name, amount: amount, amountUnit: amountUnit, orderNumber: orderNumber)
            }
        }
    }
}
struct RecipeBrowseView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeBrowseView(recipe: RecipePost(refId: "", title: "Pumpkin soup with bread", serves: 1, author: "Olof Hammar", authorId: "", category: "", image: ""))
    }
}
