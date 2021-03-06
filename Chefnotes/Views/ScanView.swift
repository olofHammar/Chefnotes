//
//  ScanView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-17.
//

import SwiftUI
import Firebase
import SPAlert
import AVKit

/*
 In this view I use googles AVKit to let users scan images using camera or phone library.
 I save all items found in image in wordList and display the array in a list. The user can then select item and save as either title, ingredient or step. When selecting an item that item is passed into a texfield so that the user can edit the item upon saving it.
 */

struct ReadItem: Identifiable {
    var id = UUID().uuidString
    var title: String = ""
}

struct ScanView: View {
    
    @State var isPresented = false
    @State var showSheet = false
    @State var showSelectionSheet = false
    @State private var showImagePicker = false
    @State private var inProcess = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State var stringToEdit = ""
    @State var selectedItem: String?
    @State var stringId = 0
    @State var title = ""
    @State private var image: UIImage?
    @State var ingredients = [Ingredient]()
    @State var steps = [Step]()
    @State var wordList = [ReadItem]()
    @State private var count = 0
    var isTrue = false
    
    
    var body: some View {
        
        ZStack {
            VStack {
                Form {
                    Section(header: Text("Select image to scan"), footer: Text("Click the default-image to select a new image.")) {
                        Button(action: { showActionSheet() }) {
                            ZStack {
                                if image != nil {
                                    Image(uiImage: image!)
                                        .newRecipeImageStyle()
                                }
                                else {
                                    Image("default_image")
                                        .newRecipeImageStyle()
                                }
                                if inProcess {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .primary))
                                        .scaleEffect(2)
                                }
                            }
                            .padding(.vertical)
                            .padding(.bottom)
                        }
                    }
                    .padding(.top)
                    .actionSheet(isPresented: $showSheet) {
                        ActionSheet(title: Text("Select image to scan"), message: nil, buttons: [
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
                    Section {
                        Button(action: { scanImage()})
                        {
                            Text("Scan image")
                        }
                    }
                    Section(header: Text("Text found in image"), footer: Text("Click item to edit or save to recipe")) {
                        List {
                            if wordList.count > 0 {
                                ForEach(wordList) { item in
                                    Button(action: {setSelectedItemData(word: item)}) {
                                        Text(item.title)
                                            .foregroundColor(.black)
                                    }
                                    .listRowBackground(self.selectedItem == item.title ? Color(UIColor.systemGray4).opacity(0.6) : Color(UIColor.white))
                                }
                                .onDelete(perform: {indexSet in
                                    wordList.remove(atOffsets: indexSet)
                                })
                            }
                            else {
                                Text("List is empty")
                            }
                        }
                    }
                    Section {
                        TextField("This field can be edited", text: $stringToEdit)
                        Button(action: { showSelections() })
                        {
                            Text("Save item as...")
                        }
                    }
                    Section (footer: Text("Make sure to add and edit ingredients and instruction here. This can not be done in the next step.").multilineTextAlignment(.center)) {
                        Button (action: { showSaveView() })
                        {
                            Text("Next")
                                .blueButtonStyle()
                        }.buttonStyle(PlainButtonStyle())
                        .fullScreenCover(isPresented: $isPresented) {
                            ScanSaveView(title: $title, ingredients: $ingredients, steps: $steps, wordList: $wordList, passedImage: $image)
                        }
                    }
                    .padding(.bottom)
                    .listRowBackground(Color("ColorBackgroundButton"))
                    .background(Color("ColorBackgroundButton"))
                }
                
                .sheet(isPresented: $showImagePicker) {
                    VStack{
                        imagePicker(image: self.$image, isPresented: $showImagePicker, sourceType: self.sourceType)
                    }
                }
                .actionSheet(isPresented: $showSelectionSheet) {
                    ActionSheet(title: Text("Select item type"), message: nil, buttons: [
                        .default(Text("Title"), action: {
                                    saveTitle(completion: {_ in
                                                removeFromWordList()})}),
                        .default(Text("Ingredient"), action: { saveIngredient(completion: {_ in
                                                                                removeFromWordList()})}),
                        .default(Text("Instruction"), action: {saveInstruction(completion: {_ in
                                                                                removeFromWordList()})}),
                        .cancel()
                    ])
                }
            }
            .navigationTitle("Scan recipe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func showSaveView() {
        self.isPresented.toggle()
    }
    private func showSelections() {
        if !wordList.isEmpty && stringToEdit != "" {
            showSelectionSheet.toggle()
        }
        else {
            let alertView = SPAlertView(title: "Could't add item", message: "List of scanned items or selected text is empty", preset: SPAlertIconPreset.error)
            alertView.present(duration: 3)
        }
    }
    private func scanImage() {
        if image != nil {
            textRecognition(image: image, completion: {_ in
                inProcess = false
            })
        }
        else {
            let alertView = SPAlertView(title: "Could't scan image", message: "Please select image to scan", preset: SPAlertIconPreset.error)
            alertView.present(duration: 3)
        }
    }
    private func setSelectedItemData(word: ReadItem) {
        count = 0
        stringToEdit = word.title
        self.selectedItem = word.title
        for i in 0..<wordList.count {
            if wordList[i].title == word.title {
                stringId = count
            }
            else {
                count += 1
            }
        }
    }
    private func saveTitle(completion: @escaping (Any) -> Void) {
        title = stringToEdit
        completion(true)
    }
    private func saveIngredient(completion: @escaping (Any) -> Void) {
        /*
         Since I can't extract amount and unit from scan I save these ingredients as strings and set amount and amountUnit to "0 -" this will be unique for scanned ingredients. This way I can just remove "0 -" from the ingredient later when loading into lists.
         */
        let ingredient = Ingredient(name: stringToEdit, amount: 0, amountUnit: "-", orderNumber: ingredients.count)
        ingredients.append(ingredient)
        
        completion(true)
        print("\(ingredients.count) ingredients added")
    }
    private func saveInstruction(completion: @escaping (Any) -> Void) {
        let instruction = Step(description: stringToEdit, orderNumber: steps.count)
        steps.append(instruction)
        
        completion(true)
        print("\(steps.count) instruction added")
    }
    private func removeFromWordList() {
        if selectedItem != nil {
            wordList.remove(at: stringId)
        }
        count = 0
        stringToEdit = ""
        selectedItem = nil
    }
    
    private func showActionSheet() {
        showSheet.toggle()
    }
    
    private func textRecognition(image: UIImage?, completion: @escaping (Any) -> Void) {
        self.inProcess = true
        let vision = Vision.vision()
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["en", "sv"]
        let textRecognizer = vision.cloudTextRecognizer(options: options)
        
        let visionImage = VisionImage(image: image!)
        
        let cameraPosition = AVCaptureDevice.Position.back  
        let metadata = VisionImageMetadata()
        metadata.orientation = imageOrientation(
            deviceOrientation: UIDevice.current.orientation,
            cameraPosition: cameraPosition
        )
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                print("Error")
                return
            }
            let resultText = result.text
            print("result: \(result.text)")
            for block in result.blocks {
                let blockText = block.text
                let blockConfidence = block.confidence
                let blockLanguages = block.recognizedLanguages
                let blockCornerPoints = block.cornerPoints
                let blockFrame = block.frame
                for line in block.lines {
                    let lineText = line.text
                    let lineConfidence = line.confidence
                    let lineLanguages = line.recognizedLanguages
                    let lineCornerPoints = line.cornerPoints
                    let lineFrame = line.frame
                    //I choose to use lineText so every line of text found is saved as a string
                    self.wordList.append(ReadItem.init(title: lineText))
                    for element in line.elements {
                        let elementText = element.text
                        let elementConfidence = element.confidence
                        let elementLanguages = element.recognizedLanguages
                        let elementCornerPoints = element.cornerPoints
                        let elementFrame = element.frame
                    }
                }
            }
            completion(true)
        }
    }
    
    private func imageOrientation(
        deviceOrientation: UIDeviceOrientation,
        cameraPosition: AVCaptureDevice.Position
    ) -> VisionDetectorImageOrientation {
        switch deviceOrientation {
        case .portrait:
            return cameraPosition == .front ? .leftTop : .rightTop
        case .landscapeLeft:
            return cameraPosition == .front ? .bottomLeft : .topLeft
        case .portraitUpsideDown:
            return cameraPosition == .front ? .rightBottom : .leftBottom
        case .landscapeRight:
            return cameraPosition == .front ? .topRight : .bottomRight
        case .faceDown, .faceUp, .unknown:
            return .leftTop
        }
    }
}

struct ScanView_Previews: PreviewProvider {
    static var previews: some View {
        ScanView()
    }
}

