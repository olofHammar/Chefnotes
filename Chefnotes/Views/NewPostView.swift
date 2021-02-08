//
//  NewPostView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import SPAlert

var mockData : [String] = ["200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt", "200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt", "200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt"]
var mockDataCooking : [String] = ["Koka potatis", "Stek tomater", "Krydda med salt och persilja"]

struct NewPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var showSheet = false
    @State var showHalfModal = false
    @State var halfModalTitle = ""
    @State var halfModalPlaceHolder = ""
    @State var halfModalHeight: CGFloat = 400
    
    @State var title = ""
    @State var author = ""
    @State var category = ""
    @State var ingredients = [Ingredient]()
    @State var steps = [Step]()
    @State var serves = 1
    
    @State var categoryOptionTag: Int = 0
    var categoryOptions = ["Basics", "Starters", "Snacks", "Vegetarian", "Meat", "Fish & Seafood", "Pasta", "Baking", "Deserts"]
    var amountUnit = ["g", "kg", "ml", "l", "tsp", "tbs", "psc", "sprigs"]
    @State var halfModalTextFieldOneVal = ""
    @State var halfModalTextFieldTwoVal = ""
    @State var newItemType: newStepOrIngredient = .Step
    @State var ingredientUnitIndex = 0
    
    var body: some View {
        NavigationView{
            ZStack {
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
                        Section(header: Text("Select number of servings")) {
                            Stepper(value: $serves, in: 1...100) {
                                Text("Serves: \(serves)")
                            }
                        }
                        Section(header: Text("Add ingredients")) {
                            
                            ScrollView() {
                                if ingredients.count > 0 {
                                    ForEach(ingredients.reversed(), id: \.id) { ingredient in
                                        Text("\(ingredient.amount.stringWithoutZeroFractions) \(ingredient.amountUnit) \(ingredient.name)")
                                            .padding()
                                        
                                    };frame(width: 340)
                                }
                                else {
                                    Text("List is empty")
                                        .padding()
                                }
                            }.frame(height: 200)
                        }
                        Button(action: {
                                self.updateHalfModal(placeHolder: "Ingredient", itemType: .Ingredient, height: UIScreen.main.bounds.size.height)
                                self.showHalfModal.toggle()}) {
                            Text("Add ingredients")
                        }
                        Section(header: Text("Add steps")) {
                            
                            ScrollView() {
                                if steps.count > 0 {
                                ForEach(steps.reversed(), id: \.id) { thisStep in
                                    Text("\(thisStep.orderNumber+1) " + thisStep.description)
                                        .padding()
                                
                                };frame(width: 340)
                                }
                                else {
                                    Text("List is empty")
                                        .padding()
                                }
                            }.frame(height: 200)
                        }
                        Button(action: {
                            self.updateHalfModal(placeHolder: "Step", itemType: .Step, height: UIScreen.main.bounds.size.height)
                            self.showHalfModal.toggle()
                        }) {
                            Text("Add steps")
                        }
                        Section {
                            Button (action: {
                                category = categoryOptions[categoryOptionTag]
                                print(title)
                                print(category)
                                print(serves)
                                print(ingredients[0])
                                print(ingredients[1])
                                print(steps[0])
                                print(steps[1])
                                print(ingredients.count)
                            }) {
                                Text("Save Recipe")
                            }
                            .blueButtonStyle()
                            .listRowBackground(grayBlue)
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        }
                    }
                }
                HalfModalView(isShown: $showHalfModal) {
                    VStack {
                        Form {
                            if newItemType == .Ingredient {
                                Section(header: Text("Enter \(self.halfModalPlaceHolder)")) {
                                    HStack {
                                        TextField("Quantity", text: $halfModalTextFieldOneVal)
                                            .keyboardType(.decimalPad)
                                        
                                        Picker("Unit", selection: $ingredientUnitIndex) {
                                            Text("g").tag(0)
                                            Text("kg").tag(1)
                                            Text("ml").tag(2)
                                            Text("l").tag(3)
                                            Text("tsp").tag(4)
                                            Text("tbs").tag(5)
                                            Text("psc").tag(6)
                                            Text("sprigs").tag(7)
                                        }
                                        .pickerStyle(MenuPickerStyle())
                                        Spacer()
                                        Text(amountUnit[ingredientUnitIndex])
                                            .padding()
                                    }
                                    .pickerStyle(MenuPickerStyle())
                                    TextField("\(self.halfModalPlaceHolder)", text: $halfModalTextFieldTwoVal)
                                }
                            }
                            else if newItemType == .Step {
                                TextField("\(self.halfModalPlaceHolder)", text: $halfModalTextFieldTwoVal)
                                
                            }
                            Button(action: {self.addNewItem()}) {
                                if newItemType == .Ingredient {
                                    Text("Add ingredient")
                                }
                                else {
                                    Text("Add step")
                                }
                            }
                            Section {
                                Button (action: {
                                    self.hideModal()
                                }) {
                                    Text("Done")
                                }
                                .blueButtonStyle()
                                .listRowBackground(grayBlue)
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            }
                        }
                    }.edgesIgnoringSafeArea(.all)
                }
            }
            .navigationTitle("Write recipe")
            .navigationBarItems(trailing: Button(action: {dismissModal()}) {
                Image(systemName: "x.circle")
                    .personSettingsImageStyle()
                    .padding(.bottom, 2)
            })
        }
        
        
    }
    
    
    private func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
    private func showActionSheet() {
        showSheet.toggle()
    }
    func updateHalfModal(placeHolder: String, itemType: newStepOrIngredient, height: CGFloat) {
        
        halfModalTextFieldOneVal = ""
        halfModalTextFieldTwoVal = ""
        halfModalPlaceHolder = placeHolder
        newItemType = itemType
        halfModalHeight = height
    }
    func clearHalfModal() {
        halfModalTextFieldOneVal = ""
        halfModalTextFieldTwoVal = ""
    }
    func possibleStringToDouble(_ stringToValidate: String) -> Double? {
        
        let val = Double(stringToValidate) ?? nil
        
        if let val = val {
            return val
        }
        else {
            return nil
        }
    }
    func hideModal() {
        
        UIApplication.shared.endEditing()
        showHalfModal = false
    }
    private func addNewItem() {
        if halfModalTextFieldTwoVal == "" {
            let alertView = SPAlertView(title: newItemType == .Step ? "Please add a step" : "Please add a ingredient", message: "Check that no fields are left blank" , preset: SPAlertIconPreset.error)
            
            alertView.present(duration: 3)
        }
        else {
            if newItemType == .Step {
                steps.append(Step(description: halfModalTextFieldTwoVal, orderNumber: steps.count))
                clearHalfModal()
            }
            else if newItemType == .Ingredient {
                
                if let amount = possibleStringToDouble(halfModalTextFieldOneVal) {
                    /*
                     let thisIngredientUnit = IngredientUnit.allCases[ingredientUnitIndex]
                     */
                    ingredients.append(Ingredient(name: halfModalTextFieldTwoVal,
                                                  amount: amount,
                                                  amountUnit: amountUnit[ingredientUnitIndex],
                                                  orderNumber: ingredients.count))
                    clearHalfModal()
                }
                else {
                    let alertView = SPAlertView(title: "Check the amount", message: "Please enter a number", preset: SPAlertIconPreset.error)
                    alertView.present(duration: 3)
                }
            }
        }
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
