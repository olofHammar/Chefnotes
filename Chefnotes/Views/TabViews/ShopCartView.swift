//
//  ShopCartView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-25.
//

import SwiftUI
import Firebase

/*
 This view contains the users shopping list. The list is sorted by bool isChecked, so all checked items is at bottom of list and unchecked at top. When item is clicked I check current bool value and update to the oppsite in firebase. 
 */

struct ShopCartView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    @State private var showHalfModal = false
    @State private var halfModalTitle = ""
    @State private var halfModalPlaceHolder = ""
    @State private var halfModalHeight: CGFloat = 300
    @State private var halfModalTextFieldOneVal = ""
    @State private var items = [Item]()
    @State var boolToUpdate = false
    let db = Firestore.firestore()
    
    var body: some View {
        
        ZStack {
            NavigationView {
                Form {
                    Section(header: Text("My shoppinglist")) {
                        List {
                            if items.count > 0 {
                                ForEach(items.sorted(by:{!$0.isChecked && $1.isChecked})) { item in
                                    HStack {
                                        let filteredText = item.title.replacingOccurrences(of: "0 -", with: "")
                                        Button(action: { checkItemStatus(item: item)})
                                        {
                                            Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                                                .font(.system(size: 21, weight: .medium))
                                                .foregroundColor(.blue)
                                        }.buttonStyle(PlainButtonStyle())
                                        Text(filteredText)
                                        Spacer()
                                    }
                                }
                            }
                            else {
                                Text("List is empty")
                            }
                        }
                        .foregroundColor(Color("BlackAndWhite"))
                    }
                    Section {
                        Button(action: {
                            self.updateHalfModal(height: halfModalHeight)
                            self.showHalfModal.toggle()
                        }){
                            Text("Add item")
                        }
                        .blueButtonStyle()
                        .listRowBackground(Color("ColorBackgroundButton"))
                    }
                }
                .padding()
                .background(Color("ColorBackgroundButton"))
                .navigationTitle("Shopping list")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            clearShoppingList(completion: {_ in
                                                withAnimation {
                                                    self.items.removeAll()
                                                }
                                            })
                                        }){
                                            Text("Clear")
                                        })
            }.padding(.top)
            HalfModalView(isShown: $showHalfModal) {
                VStack {
                    Form {
                        TextField("Add new item", text: $halfModalTextFieldOneVal)
                        
                        Button(action: {self.addNewItem()})
                        {
                            Text("Add item")
                        }
                        Section {
                            Button (action: {self.hideModal()})
                            {
                                Text("Done")
                            }
                            .blueButtonStyle()
                            .listRowBackground(Color("ColorBackgroundButton"))
                        }
                    }
                }
            }
        }.onAppear() {
            getShoppingList()
        }
    }
    private func getShoppingList() {
        let db = Firestore.firestore()
        let itemRef = db.collection("users").document("\(env.currentUser.id)")
        itemRef.collection("shoppingList").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            self.items = documents.map { queryDocumentSnapshot -> Item in
                
                let data = queryDocumentSnapshot.data()
                let refId = data["refId"] as? String ?? ""
                let title = data["title"] as? String ?? ""
                let isChecked = data["isChecked"] as? Bool ?? false
                
                return Item(refId: refId, title: title, isChecked: isChecked)
            }
        }
    }
    func clearShoppingList(completion: @escaping (Any) -> Void) {
        let db = Firestore.firestore().collection("users")
        let docRef = db.document(env.currentUser.id).collection("shoppingList")
        docRef.getDocuments(completion: { querySnapshot, error in
            if let err = error {
                print("error: \(err.localizedDescription)")
                return
            }
            guard let docs = querySnapshot?.documents else {
                return }
            for doc in docs {
                docRef.document(doc.documentID).delete()
            }
        })
        completion(true)
    }
    private func checkItemStatus(item: Item) {
        if item.isChecked == false {
            boolToUpdate = true
        }
        else {
            boolToUpdate = false
        }
        let ref = db.collection("users").document(env.currentUser.id)
        ref.collection("shoppingList").document(item.refId)
            .updateData(["isChecked" : boolToUpdate])
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
    }
    private func addNewItem() {
        let refId = UUID().uuidString
        let item = Item(refId: refId, title: halfModalTextFieldOneVal, isChecked: false)
        
        addToShoppingList(refId: "\(item.refId)", dataToSave: item.dictionary)
        self.items.append(item)
        halfModalTextFieldOneVal = ""
    }
    private func addToShoppingList(refId: String, dataToSave: [String:Any]) {
        
        let ref = db.collection("users").document(env.currentUser.id)
        let docRef = ref.collection("shoppingList").document(refId)
        print("Setting data")
        docRef.setData(dataToSave) { error in
            if let err = error {
                print("error \(err)")
            }
            else {
                print("Item uploaded succefully")
            }
        }
    }
    private func hideModal() {
        
        UIApplication.shared.endEditing()
        showHalfModal = false
    }
    private func updateHalfModal(height: CGFloat) {
        
        halfModalTextFieldOneVal = ""
        halfModalHeight = height
    }
}

struct ShopCartView_Previews: PreviewProvider {
    static var previews: some View {
        ShopCartView()
    }
}

