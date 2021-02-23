//
//  ScanSaveView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-18.
//

import SwiftUI
import Firebase
import SPAlert

struct ScanSaveView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var env: GlobalEnviroment
    @State var showSheet = false
    @State var showImagePicker = false
    @State var isLoading = false
    @State var sourceType: UIImagePickerController.SourceType = .camera
    @State var image: UIImage?
    @Binding var title: String
    @Binding var ingredients: [Ingredient]
    @Binding var steps: [Step]
    @Binding var wordList: [ReadItem]
    @Binding var passedImage: UIImage?
    @State var serves = 1
    @State var categoryOptionTag: Int = 0
    var categoryOptions = ["Basics", "Starters", "Snacks", "Vegetarian", "Meat", "Fish & Seafood", "Pasta", "Baking", "Deserts"]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        Section(header: Text("Add image for recipe"), footer: Text("Click the default-image to select a new image.")) {
                            ZStack {
                                Button(action: {showActionSheet()}) {
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
                            TextField("Add title", text: $title).KeyboardAwarePadding()
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
                                        Text("\(ingredient.name)")
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
                            Button (action: { checkRecipeStatus()}) {
                                Text("Save Recipe")
                            }
                            .blueButtonStyle()
                            .listRowBackground(grayBlue)
                            .padding(.bottom)
                        }
                    }
                    .navigationTitle("Save recipe")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing: Button(action: {dismissModal()}) {
                        Image(systemName: "x.circle")
                            .personSettingsImageStyle()
                            .padding(.bottom, 2)
                    })
                }
                .sheet(isPresented: $showImagePicker) {
                    VStack{
                        imagePicker(image: self.$image, isPresented: $showImagePicker, sourceType: self.sourceType)
                    }
                }
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                        .scaleEffect(3)
                }
            }
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
    func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
    private func showActionSheet() {
        showSheet.toggle()
    }
    private func clearPostViews() {
        ingredients.removeAll()
        steps.removeAll()
        title = ""
        categoryOptionTag = 0
        image = nil
        serves = 1
        passedImage = nil
        wordList.removeAll()
    }
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
                        print("Nu är vi här")
                        self.saveRecipePost(imageUrl: (url?.absoluteString)!)
                    }
                    else {
                        print("Error")
                    }
                })
            }
        }
    }
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
            savedRecipeAlert(completion: {_ in
                
                clearPostViews()
            })
        })
        return
    }
    private func savedRecipeAlert(completion: @escaping (Any) -> Void) {
        let alertView = SPAlertView(title: "Recipe added!", message: "The recipe has been saved to your book.", preset: SPAlertIconPreset.done)
        alertView.present(duration: 2)
        completion(true)
    }
}

//struct ScanSaveView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScanSaveView()
//    }
//}
