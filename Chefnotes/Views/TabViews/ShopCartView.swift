//
//  ShopCartView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-25.
//

import SwiftUI

struct ShopCartView: View {

    @State private var showHalfModal = false

    @State private var halfModalTitle = ""
    @State private var halfModalPlaceHolder = ""
    @State private var halfModalHeight: CGFloat = 300
    @State private var halfModalTextFieldOneVal = ""

    @State private var items = [Item]()
    @State private var isChecked = false
    
    var body: some View {
        
        ZStack {
            NavigationView {
                Form {
                        Section {
                            List {
                            if items.count > 0 {
                                ForEach(items) { index in
                                    CheckView(isChecked: $isChecked, title: "\(index.title)")
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
                                            clearShoppingList()
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
        }
    }
    private func addNewItem() {
        self.items.append(Item(title: halfModalTextFieldOneVal, isChecked: false))
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
    private func clearShoppingList() {
        self.items.removeAll()
    }
}

struct ShopCartView_Previews: PreviewProvider {
    static var previews: some View {
        ShopCartView()
    }
}

struct Item: Identifiable {
    var id = UUID()
    var title: String
    var isChecked: Bool
    
    var dictionary: [String: Any] {
        return [
            "id" : id.uuidString,
            "title" : title,
            "isChecked" : isChecked
        ]
    }
}
