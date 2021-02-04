//
//  NewPostView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

var mockData : [String] = ["200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt", "200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt", "200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt"]
var mockDataCooking : [String] = ["Koka potatis", "Stek tomater", "Krydda med salt och persilja"]

struct NewPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showSheet = false
    @State var halfModalShown = false
    @State var title = ""
    @State var author = ""
    @State var category = ""
    @State var ingredients = [String]()
    @State var steps = [String]()
    @State var serves = 0
    @State var categoryOptionTag: Int = 0
    var categoryOptions = ["Basics", "Starters", "Snacks", "Vegetarian", "Meat", "Fish", "Seafood", "Baking", "Deserts"]
    
    var body: some View {
        
        
        NavigationView {
            ZStack {
                grayBlue
                VStack {
                    Form {
                        Section(header: Text("Enter title")) {
                            TextField("Add title", text: $title)
                        }
                        Section(header: Text("Add image")) {
                            ZStack {
                                Button(action: { showActionSheet() }) {
                                    ZStack {
                                        Image("default_image")
                                            .newRecipeImageStyle()
                                        Image(systemName: "plus.circle.fill")
                                            .newRecipePlusButtonImageStyle()
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .actionSheet(isPresented: $showSheet) {
                                    ActionSheet(title: Text("Add a picture to your post"), message: nil, buttons: [
                                        .default(Text("Camera"), action: {
                                            //self.showImagePicker = true
                                            //self.sourceType = .camera
                                        }),
                                        .default(Text("Library"), action: {
                                            //self.showImagePicker = true
                                            //self.sourceType = .photoLibrary
                                        }),
                                        .cancel()
                                    ])
                                }
                                
                            }
                            .padding(.leading,43)
                            .padding(.vertical)
                        }
                        Section(header: Text("Select category")) {
                            HStack {
                                Picker("Category", selection: $categoryOptionTag) {
                                    Text("Basics").tag(0)
                                    Text("Starters").tag(1)
                                    Text("Snacks").tag(2)
                                    Text("Vegetarian").tag(3)
                                    Text("Meat").tag(4)
                                    Text("Fish").tag(5)
                                    Text("Seafood").tag(6)
                                    Text("Baking").tag(7)
                                    Text("Deserts").tag(8)
                                }
                                .pickerStyle(MenuPickerStyle())
                                Spacer()
                                Text(categoryOptions[categoryOptionTag])
                            }
                        }
                        Section(header: Text("Add ingredients")) {
                            
                            ScrollView() {
                                
                                ForEach(categoryOptions, id: \.self) { item in
                                    Text("250 g \(item)")
                                        .padding()
                                    
                                };frame(width: 340)
                            }.frame(height: 250)
                        }
                        Button(action: { }) {
                            Text("Add ingredients")
                        }
                        Section(header: Text("Add steps")) {
                            
                            ScrollView() {
                                
                                ForEach(categoryOptions, id: \.self) { item in
                                    Text("250 g \(item)")
                                        .padding()
                                    
                                };frame(width: 340)
                            }.frame(height: 250)
                        }
                        Button(action: { }) {
                            Text("Add steps")
                        }
                        Section {
                            Button (action: {
                                        category = categoryOptions[categoryOptionTag]
                                        print(category) }) {
                                Text("Save Recipe")
                            }
                            .blueButtonStyle()
                            .listRowBackground(grayBlue)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        }
                    }
                    
                }
            }
            .navigationBarTitle("Write recipe")
            .navigationBarItems(trailing:
                                    Button(action: {dismissModal()}) {
                                        Image(systemName: "x.circle.fill")
                                            .personSettingsImageStyle()
                                    })
        }
    }
    
    private func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
    private func showActionSheet() {
        showSheet.toggle()
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
