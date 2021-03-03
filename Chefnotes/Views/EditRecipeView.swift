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

/*
 This view lets the user edit or delete their own recipePosts. I pass the recipe from detail view. When updating or deleting a recipe I also load all users from firestore and update or delete their list of favorite recipes if the user has this specific recipe in its list.
 */

struct EditRecipeView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    
    @State var thisRecipe: RecipePost
    @State var ingredients: [Ingredient]
    @State var steps: [Step]
    @State var oldImageUrl = ""
    @State var users = [String]()
    
    @State var showImagePicker = false
    @State var showSheet = false
    @State var isLoading = false
    @State var showHalfModal = false
    @State private var showingDeleteAlert = false
    
    @State var halfModalTitle = ""
    @State var halfModalPlaceHolder = ""
    @State var halfModalHeight: CGFloat = 400
    @State var halfModalTextFieldOneVal = ""
    @State var halfModalTextFieldTwoVal = ""
    
    @State var newItemType: newStepOrIngredient = .Step
    @State var ingredientUnitIndex = 0
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var image: UIImage?
    @State var newImageAdded = false
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
                                             content: { oldImage, info in
                                                oldImage
                                                    .newRecipeImageStyle()
                                             })
                                }
                                
                            }
                            .actionSheet(isPresented: $showSheet) {
                                ActionSheet(title: Text("Change picture of your post"), message: nil, buttons: [
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
                        TextField("Add title", text: $thisRecipe.title)
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
                                .overlay(Text("Edit steps"), alignment: .leading)) {
                        
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
                        Button(action: { checkRecipeStatus() }) {
                            Text("Update Recipe")
                        }
                        .blueButtonStyle()
                    }
                    .listRowBackground(Color("ColorBackgroundButton"))
                    .background(Color("ColorBackgroundButton"))
                    Section {
                        Button(action: { showDeleteRecipeAlert() }) {
                            HStack{
                                Spacer()
                            Text("Delete Recipe")
                                .foregroundColor(.red)
                                Spacer()
                            }
                        }
                        .background(Color.clear)
                        .padding(.bottom)
                    }
                    .listRowBackground(Color("ColorBackgroundButton"))
                }
            }
            .alert(isPresented: $showingDeleteAlert) {
                Alert(
                    title: Text("Are you sure you want to delete this recipe?"),
                    message: Text("There is no undo"),
                    primaryButton: .destructive(Text("Delete")) {
                        deleteRecipePost()
                    },
                    secondaryButton: .cancel()
                )
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
                            .listRowBackground(Color("ColorBackgroundButton"))
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
            oldImageUrl = thisRecipe.image
        }
    }
    //When deleting or moving ingredient/step I update the ordernumber.
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
    private func showActionSheet() {
        showSheet.toggle()
    }
    private func showDeleteRecipeAlert() {
        showingDeleteAlert.toggle()
    }
    private func getCategory(recipe: RecipePost) {
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
    private func hideModal() {
        
        UIApplication.shared.endEditing()
        showHalfModal = false
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
    //I use enum newStepOrIngredient from recipe class to determend what and how to save item
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
    //Before updating I check if image has been changed and that everything is filled in.
    private func checkRecipeStatus() {
        if image == nil {
            updateRecipePost(imageUrl: "") 
        }
        else if ingredients.isEmpty || steps.isEmpty || thisRecipe.title == "" {
            let alertView = SPAlertView(title: "Couldn't save recipe", message: "Check that no fields are left blank", preset: SPAlertIconPreset.error)
            alertView.present(duration: 3)
        }
        else {
            isLoading = true
            uploadImage()
        }
    }
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
                        //if url isn't nil new image has been added
                        self.newImageAdded = true
                        self.updateRecipePost(imageUrl: (url?.absoluteString)!)
                    }
                    else {
                        print("Error")
                    }
                })
            }
        }
    }
    //I delete old image if new image has been selected
    private func deleteOldImage() {
        if newImageAdded {
            
            let storage = Storage.storage()
            let url = oldImageUrl
            let storageRef = storage.reference(forURL: url)
            
            storageRef.delete { error in
                if let error = error {
                    print("\(error)")
                } else {
                    print("deleted old image")
                }
            }
        }
        else {
            print("no new image added")
            return
        }
    }
    private func updateRecipePost(imageUrl: String) {
        isLoading = true
        
        var updatedRecipePost = RecipePost(id: thisRecipe.id, refId: thisRecipe.refId, title: thisRecipe.title, serves: thisRecipe.serves, author: "\(self.env.currentUser.firstName) \(self.env.currentUser.lastName)", authorId: Auth.auth().currentUser?.uid ?? "", category: categoryOptions[categoryOptionTag], image: thisRecipe.image)
        
        if image != nil {
            updatedRecipePost.image = imageUrl
        }
        
        fireStoreUpdateData(docRefString: "recipe/\(thisRecipe.refId)", dataToUpdate: updatedRecipePost.dictionary, completion: { _ in
            deleteOldImage()
            deleteIngredients(refId: thisRecipe.refId, completion: { _ in
                for i in 0...ingredients.count-1 {
                    let ingredient = ingredients[i].dictionary
                    fireStoreSubmitIngredients(docRefString: "recipe/\(thisRecipe.refId)", dataToSave: ingredient) { _ in
                    }
                }
            })
            deleteSteps(refId: thisRecipe.refId, completion: { _ in
                for i in 0...steps.count-1 {
                    let step = steps[i].dictionary
                    fireStoreSubmitSteps(docRefString: "recipe/\(thisRecipe.refId)", dataToSave: step){ _ in }
                }
            })
            getUsers(completion: {_ in
                print("\(self.users.count)")
                updateOtherUsersFavorites(userIds: self.users, refString: thisRecipe.refId, dataToUpdate: updatedRecipePost.dictionary, completion: { _ in })
            })
            
            self.isLoading = false
            showUpdateAlert()            
        })
    }
    private func deleteRecipePost() {
        let db = Firestore.firestore()
        isLoading = true
        newImageAdded = true
        getUsers(completion: {_ in
            deleteOtherUsersFavoriteRecipe(userIds: self.users, refString: thisRecipe.refId)
        })
        deleteIngredients(refId: thisRecipe.refId, completion: {_ in})
        deleteSteps(refId: thisRecipe.refId, completion: {_ in})
        deleteOldImage()
        db.collection("recipe").document(thisRecipe.refId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                isLoading = false
                showDeleteAlert()
            }
        }
    }
    private func getUsers(completion: @escaping (Any) -> Void) {
        
        let db = Firestore.firestore()
        db.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    self.users.append(document.documentID)
                }
                completion(true)
            }
        }
    }
    private func showUpdateAlert() {
        let alertView = SPAlertView(title: "Recipe updated!", message: "The recipe has been updated in your book.", preset: SPAlertIconPreset.done)
        alertView.present(duration: 2)
    }
    private func showDeleteAlert() {
        isLoading = false
        let alertView = SPAlertView(title: "Recipe deleted!", message: "The recipe has been deleted from your book.", preset: SPAlertIconPreset.done)
        alertView.present(duration: 2)
    }
}

//struct EditRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditRecipeView()
//    }
//}
