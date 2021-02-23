//
//  EditRecipeView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-19.
//

import SwiftUI
import URLImage
import Firebase
import SPAlert

struct EditRecipeView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var thisRecipe: RecipePost
    @State var ingredients: [Ingredient]
    @State var steps: [Step]
    
    @State private var showImagePicker = false
    @State var showSheet = false
    @State var isLoading = false
    @State var showHalfModal = false

    @State var halfModalTitle = ""
    @State var halfModalPlaceHolder = ""
    @State var halfModalHeight: CGFloat = 400
    @State var halfModalTextFieldOneVal = ""
    @State var halfModalTextFieldTwoVal = ""
    @State var newItemType: newStepOrIngredient = .Step
    @State var ingredientUnitIndex = 0

    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var image: UIImage?
    @State var categoryOptionTag: Int = 0
    var categoryOptions = ["Basics", "Starters", "Snacks", "Vegetarian", "Meat", "Fish & Seafood", "Pasta", "Baking", "Deserts"]
    var amountUnit = ["g", "kg", "ml", "l", "tsp", "tbs", "psc", "sprigs"]

    
    var body: some View {
        
        let url = URL(string: thisRecipe.image)!
        
        ZStack {
            VStack {
                Form {
                    Section(header: Text("Edit image"), footer: Text("Click image to select new")) {
                        ZStack {
                            Button(action: { showActionSheet() }) {
                                if image != nil {
                                    Image(uiImage: image!)
                                        .newRecipeImageStyle()
                                }
                                else {
                                    URLImage(url: url,
                                             empty: {
                                                Image("default_image")
                                                    .newRecipeImageStyle()
                                             },
                                             inProgress: { progress in
                                                ProgressView()
                                                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                                                    .scaleEffect(3)
                                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200, alignment: .center)
                                                
                                             },
                                             failure: { error, retry in
                                                Text("Failed loading image")
                                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 200, alignment: .center)
                                                
                                             },
                                             content: { image, info in
                                                image
                                                    .newRecipeImageStyle()
                                             })
                                }
                                
                            }
                            .actionSheet(isPresented: $showSheet) {
                                ActionSheet(title: Text("Add a picture to your post"), message: nil, buttons: [
                                    .default(Text("Camera"), action: {
                                        self.showImagePicker = true
                                        self.sourceType = .camera
                                    }),
                                    .default(Text("Library"), action: {
                                        self.showImagePicker = true
                                        self.sourceType = .photoLibrary
                                    }),
                                    .cancel()
                                ])
                            }
                        }
                        .padding(.vertical)
                        .padding(.bottom)
                    }
                    .padding(.top)
                    Section(header: Text("Edit title")) {
                        TextField("Add title", text: $thisRecipe.title).KeyboardAwarePadding()
                    }
                    Section(header: Text("Edit category")) {
                        HStack {
                            Picker("Category", selection: $categoryOptionTag) {
                                Text("Basics").tag(0)
                                Text("Starters").tag(1)
                                Text("Snacks").tag(2)
                                Text("Vegetarian").tag(3)
                                Text("Meat").tag(4)
                                Text("Fish & Seafood").tag(5)
                                Text("Pasta").tag(6)
                                Text("Baking").tag(7)
                                Text("Deserts").tag(8)
                            }
                            .pickerStyle(MenuPickerStyle())
                            Spacer()
                            Text(categoryOptions[categoryOptionTag])
                        }
                    }
                    Section(header: Text("Edit number of servings")) {
                        Stepper(value: $thisRecipe.serves, in: 1...50) {
                            Text("Serves: \(thisRecipe.serves)")
                        }
                    }
                    Section(header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
                                .overlay(Text("Edit ingredients"), alignment: .leading)) {
                        List {
                            if ingredients.count > 0 {
                                ForEach(ingredients, id: \.id) { ingredient in
                                    if ingredient.amountUnit == "-" {
                                        Text("\(ingredient.name)")
                                    }
                                    else {
                                    Text("\(ingredient.amount.stringWithoutZeroFractions) \(ingredient.amountUnit) \(ingredient.name)")
                                    }
                                }.onDelete(perform: {indexSet in
                                    ingredients.remove(atOffsets: indexSet)
                                 })
                                .onMove(perform: moveIngredient)
                            }
                            else {
                                Text("List is empty")
                            }
                        }
                    }
                    Button(action: {
                            self.updateHalfModal(placeHolder: "Ingredient", itemType: .Ingredient, height: halfModalHeight)
                            self.showHalfModal.toggle()}) {
                        Text("Add ingredients")
                    }
                    Section(header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
                                .overlay(Text("Added instructions"), alignment: .leading)) {
                        
                            if steps.count > 0 {
                                ForEach(steps, id: \.id) { thisStep in
                                    Text("\(thisStep.orderNumber+1) " + thisStep.description)
                                }.onDelete(perform: {indexSet in
                                    steps.remove(atOffsets: indexSet)
                                 })
                                .onMove(perform: moveInstruction)
                            }
                            else {
                                Text("List is empty")
                            }
                    }
                    Section {
                        Button (action: {
                                    //checkRecipeStatus()
                        }) {
                            Text("Save Recipe")
                        }
                        .blueButtonStyle()
                        .listRowBackground(grayBlue)
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                        .padding(.bottom)
                    }
                    
                }
            }
            .sheet(isPresented: $showImagePicker) {
                VStack{
                    imagePicker(image: self.$image, isPresented: $showImagePicker, sourceType: self.sourceType)
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
                }
            }
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                    .scaleEffect(3)
            }
        }
        .navigationTitle("Edit recipe")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear() {
            getCategory(recipe: thisRecipe)
        }
    }
    private func moveIngredient(from source: IndexSet, to destination: Int) {
        ingredients.move(fromOffsets: source, toOffset: destination)
        var count = 0
        for i in 0..<ingredients.count {
            ingredients[i].orderNumber = count
            count += 1
        }
    }
    private func moveInstruction(from source: IndexSet, to destination: Int) {
        steps.move(fromOffsets: source, toOffset: destination)
        var count = 0
        for i in 0..<steps.count {
            steps[i].orderNumber = count
            count += 1
        }
    }
    private func showActionSheet() {
        showSheet.toggle()
    }
    func getCategory(recipe: RecipePost) {
        if thisRecipe.category == "Basics" {
            categoryOptionTag = 0
        }
        else if thisRecipe.category == "Starters" {
            categoryOptionTag = 1
        }
        else if thisRecipe.category == "Snacks" {
            categoryOptionTag = 2
        }
        else if thisRecipe.category == "Vegetarian" {
            categoryOptionTag = 3
        }
        else if thisRecipe.category == "Meat" {
            categoryOptionTag = 4
        }
        else if thisRecipe.category == "Fish & Seafood" {
            categoryOptionTag = 5
        }
        else if thisRecipe.category == "Pasta" {
            categoryOptionTag = 6
        }
        else if thisRecipe.category == "Baking" {
            categoryOptionTag = 7
        }
        else if thisRecipe.category == "Deserts" {
            categoryOptionTag = 8
        }
    }
    func hideModal() {
        
        UIApplication.shared.endEditing()
        showHalfModal = false
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
    private func possibleStringToDouble(_ stringToValidate: String) -> Double? {
        
        let val = Double(stringToValidate) ?? nil
        
        if let val = val {
            return val
        }
        else {
            return nil
        }
    }
    func addNewItem() {
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
    
    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
    func saveNewSteps(refId: String) {
        if steps.count > 0 {
            for i in 0...steps.count-1 {
                let step = steps[i].dictionary
                fireStoreSubmitSteps(docRefString: "recipe/\(refId)", dataToSave: step) { _ in}
            }
        }
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
