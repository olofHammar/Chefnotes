//
//  ShopCartView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-25.
//

import SwiftUI
import Firebase

struct ShopCartView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    @State private var showHalfModal = false
    @State private var halfModalTitle = ""
    @State private var halfModalPlaceHolder = ""
    @State private var halfModalHeight: CGFloat = 300
    @State private var halfModalTextFieldOneVal = ""
    @State private var items = [Item]()
    @State private var isChecked = false
    let db = Firestore.firestore()
    @State var dataToUpdate = false
    
    var body: some View {
        
        ZStack {
            NavigationView {
                Form {
                    Section {
                        List {
                            if items.count > 0 {
                                ForEach(items) { item in
                                    HStack {
                                        Text(item.title)
                                        Spacer()
                                        Button(action: {
                                            if item.isChecked == false {
                                                dataToUpdate = true
                                            }
                                            else {
                                                dataToUpdate = false
                                            }
                                            let ref = db.collection("users").document(env.currentUser.id)
                                            ref.collection("shoppingList").document(item.refId)
                                                .updateData(["isChecked" : dataToUpdate])
                                                { err in
                                                    if let err = err {
                                                        print("Error updating document: \(err)")
                                                    } else {
                                                        print("Document successfully updated")
                                                    }
                                                }
                                        }, label: {
                                            Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                        })
                                    }
                                }
                                .onDelete(perform: {indexSet in
                                    items.remove(atOffsets: indexSet)
                                })
                            }
                            else {
                                Text("List is empty")
                            }
                        }.foregroundColor(.black)
                    }
                    Section {
                        Button(action: {
                            self.updateHalfModal(height: halfModalHeight)
                            self.showHalfModal.toggle()
                        }){
                            Text("Add item")
                        }
                        .blueButtonStyle()
                        .listRowBackground(Color("ColorBackground"))
                    }
                }
                .padding()
                .background(Color("ColorBackground"))
                .navigationTitle("Shopping list")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing:
                                        Button(action: {
                                            clearShoppingList(completion: {_ in
                                                self.items.removeAll()
                                            })
                                        }){
                                            Text("Clear")
                                        })
            }.padding(.top)
            HalfModalView(isShown: $showHalfModal) {
                VStack {
                    Form {
                        TextField("Add new item", text: $halfModalTextFieldOneVal)
                        
                        Button(action: {
                            self.addNewItem()
                            print("\(items.count)")
                        }) {
                            Text("Add item")
                        }
                        Section {
                            Button (action: {
                                self.hideModal()
                            }) {
                                Text("Done")
                            }
                            .blueButtonStyle()
                            .listRowBackground(Color("ColorBackgroundButton"))
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
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
    private func addNewItem() {
        let refId = UUID().uuidString
        self.items.append(Item(refId: refId, title: halfModalTextFieldOneVal, isChecked: false))
        halfModalTextFieldOneVal = ""
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

struct Item: Identifiable {
    
    var id = UUID().uuidString
    var refId: String
    var title: String
    var isChecked: Bool
    
    var dictionary: [String: Any] {
        return [
            "id" : id,
            "refId" : refId,
            "title" : title,
            "isChecked" : isChecked
        ]
    }
}
