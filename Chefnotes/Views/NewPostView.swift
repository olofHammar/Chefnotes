//
//  NewPostView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import SPAlert
import Firebase

/*
 In this view the user can create new recipes. I used Form to make the process easy to follow.
 I use keyboard extension keyboardAwarePadding so that all textfields get pushed up when keyboard is visible.
 */

struct NewPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var env: GlobalEnviroment
    @State private var isLoading = false
    @State private var showSheet = false
    @State private var showHalfModal = false
    @State private var showImagePicker = false
    @State private var halfModalTitle = ""
    @State private var halfModalPlaceHolder = ""
    @State private var halfModalHeight: CGFloat = 400
    @State private var halfModalTextFieldOneVal = ""
    @State private var halfModalTextFieldTwoVal = ""
    @State private var newItemType: newStepOrIngredient = .Step
    @State private var ingredientUnitIndex = 0
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var image: UIImage?
    @State private var title = ""
    @State private var author = ""
    @State private var category = ""
    @State private var ingredients = [Ingredient]()
    @State private var steps = [Step]()
    @State private var serves = 1
    @State private var categoryOptionTag: Int = 0
    private var categoryOptions = ["Basics", "Starters", "Snacks", "Vegetarian", "Meat", "Fish & Seafood", "Pasta", "Baking", "Deserts"]
    private var amountUnit = ["g", "kg", "ml", "l", "tsp", "tbs", "psc", "sprigs"]

    var body: some View {
        
            ZStack {
                VStack {
                    Form {
                        Section(header: Text("Add image"), footer: Text("Click the default-image to select a new image.")) {
                            ZStack {
                                Button(action: { showActionSheet() }) {
                                        if image != nil {
                                            Image(uiImage: image!)
                                                .newRecipeImageStyle()
                                        }
                                        else {
                                            Image("default_image")
                                                .newRecipeImageStyle()
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
                        Section(header: Text("Enter title")) {
                            TextField("Add title", text: $title)
                        }
                        Section(header: Text("Select category")) {
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
                        Section(header: Text("Select number of servings")) {
                            Stepper(value: $serves, in: 1...50) {
                                Text("Serves: \(serves)")
                            }
                        }
                        Section(header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
                                    .overlay(Text("Added ingredients"), alignment: .leading)) {
                            List {
                                if ingredients.count > 0 {
                                    ForEach(ingredients, id: \.id) { ingredient in
                                        Text("\(ingredient.amount.stringWithoutZeroFractions) \(ingredient.amountUnit) \(ingredient.name)")

                                    }.onDelete(perform: self.deleteIngredient)
                                    .onMove(perform: moveIngredient)
                                }
                                else {
                                    Text("List is empty")
                                }
                            }
                            Button(action: {
                                    self.updateHalfModal(placeHolder: "Ingredient", itemType: .Ingredient, height: halfModalHeight)
                                    self.showHalfModal.toggle()}) {
                                Text("Add ingredients")
                            }
                        }

                        Section(header: EditButton().frame(maxWidth: .infinity, alignment: .trailing)
                                    .overlay(Text("Added instructions"), alignment: .leading)) {
                            
                                if steps.count > 0 {
                                    ForEach(steps, id: \.id) { thisStep in
                                        Text("\(thisStep.orderNumber+1) " + thisStep.description)
                                    }.onDelete(perform: self.deleteStep)
                                    .onMove(perform: moveInstruction)
                                }
                                else {
                                    Text("List is empty")
                                }
                            Button(action: {
                                self.updateHalfModal(placeHolder: "Step", itemType: .Step, height: halfModalHeight)
                                self.showHalfModal.toggle()
                            }) {
                                Text("Add steps")
                            }
                        }
                        Section {
                            Button (action: {checkRecipeStatus()}) {
                                Text("Save Recipe")
                                    .blueButtonStyle()
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .listRowBackground(Color("ColorBackgroundButton"))
                        .background(Color("ColorBackgroundButton"))
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
                                        .blueButtonStyle()
                                }
                                .buttonStyle(PlainButtonStyle())
                                .listRowBackground(Color("ColorBackgroundButton"))
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                            }
                        }
                    }
                }
                //IsLoading is displayed while uploading recipe
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .scaleEffect(3)
                }
                
            }
            .navigationTitle("Write recipe")
    }
    private func deleteIngredient(at indexSet: IndexSet) {
        self.ingredients.remove(atOffsets: indexSet)
        var count = 0
        for i in 0..<ingredients.count {
            ingredients[i].orderNumber = count
            count += 1
        }
    }
    private func deleteStep(at indexSet: IndexSet) {
        self.steps.remove(atOffsets: indexSet)
        var count = 0
        for i in 0..<steps.count {
            steps[i].orderNumber = count
            count += 1
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
    private func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
    private func showActionSheet() {
        showSheet.toggle()
    }
    private func updateHalfModal(placeHolder: String, itemType: newStepOrIngredient, height: CGFloat) {
        
        halfModalTextFieldOneVal = ""
        halfModalTextFieldTwoVal = ""
        halfModalPlaceHolder = placeHolder
        newItemType = itemType
        halfModalHeight = height
    }
    private func clearHalfModal() {
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
    private func hideModal() {
        UIApplication.shared.endEditing()
        showHalfModal = false
    }
    //I use enum from recipe class to determend which item to save and how.
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
    
    private func clearPostView() {
        ingredients.removeAll()
        steps.removeAll()
        title = ""
        categoryOptionTag = 0
        ingredientUnitIndex = 0
        image = nil
        serves = 1
    }
    //Before user can load recipe every section must be filled out
    private func checkRecipeStatus() {
        if image == nil {
            let alertView = SPAlertView(title: "Couldn't save recipe", message: "Select an image for your recipe", preset: SPAlertIconPreset.error)
            alertView.present(duration: 3)
        }
        else if ingredients.isEmpty || steps.isEmpty || title == "" {
            let alertView = SPAlertView(title: "Couldn't save recipe", message: "Check that no fields are left blank", preset: SPAlertIconPreset.error)
            alertView.present(duration: 3)
        }
        else {
            isLoading = true
            uploadImage()
        }
    }
    //I start with uploading image and when finished I move on to save recipe
    private func uploadImage() {
        
        let storageRef = Storage.storage().reference()
        let imageUrl = UUID().uuidString
        var data = NSData()
        data = image!.jpegData(compressionQuality: 0.8)! as NSData
        let filePath = storageRef.child("/images/\(imageUrl)")
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        _ = filePath.putData(data as Data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            } else {
                filePath.downloadURL (completion: {(url, error) in
                    if url != nil {
                        self.saveRecipePost(imageUrl: (url?.absoluteString)!)
                    }
                    else {
                        print("Error")
                    }
                })
            }
        }
    }
    //When saving recipe I save the post with two subcollection in the same document.
    private func saveRecipePost(imageUrl: String) {
        let refId = UUID().uuidString
        
        let newRecipePost = RecipePost(refId: refId, title: title, serves: serves, author: "\(self.env.currentUser.firstName) \(self.env.currentUser.lastName)", authorId: Auth.auth().currentUser?.uid ?? "", category: categoryOptions[categoryOptionTag], image: imageUrl)
        
        for i in 0...ingredients.count-1 {
            let ingredient = ingredients[i].dictionary
            fireStoreSubmitIngredients(docRefString: "recipe/\(refId)", dataToSave: ingredient) { _ in}
        }
        for i in 0...steps.count-1 {
            let step = steps[i].dictionary
            fireStoreSubmitSteps(docRefString: "recipe/\(refId)", dataToSave: step) { _ in}
        }
        fireStoreSubmitData(docRefString: "recipe/\(refId)", dataToSave: newRecipePost.dictionary, completion: {_ in
            isLoading = false
            let alertView = SPAlertView(title: "Recipe added!", message: "The recipe has been saved to your book.", preset: SPAlertIconPreset.done)
            alertView.present(duration: 2)
            clearPostView()
            return
        })
        return
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
