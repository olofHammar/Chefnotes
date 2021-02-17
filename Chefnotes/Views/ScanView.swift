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

struct ReadItem: Identifiable {
    var id = UUID().uuidString
    var title: String = ""
}

struct ScanView: View {
    
    @State private var image: UIImage?
    @State var wordlists = [ReadItem]()
    @State var showSheet = false
    @State var showSelectionSheet = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State var stringToEdit = ""
    @State var stringId = 0
    @State var ingredients = [String]()
    @State var instrnctions = [String]()

    
    var body: some View {
        
        VStack {
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
                }
            }
            .padding()
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
            
            Button(action: {
                if image != nil {
                    textRecognition(image: image)
                }
                else {
                    let alertView = SPAlertView(title: "Could't scan image", message: "Please select image to scan", preset: SPAlertIconPreset.error)
                    alertView.present(duration: 3)
                }
            }){
                Text("Scan")
            }
            .blueButtonStyle()
            
            TextField("Selected text", text: $stringToEdit)
                //TextEditor(text: $stringToEdit)
                Button(action: {
                    print("\(ingredients.count)")
                    showSelectionSheet.toggle()
                }) {
                    Text("Save item as")
                }.actionSheet(isPresented: $showSelectionSheet) {
                    ActionSheet(title: Text("Select item type"), message: nil, buttons: [
                        .default(Text("Ingredient"), action: {
                            ingredients.append(stringToEdit)
                            stringToEdit = ""
                            print("\(ingredients.count) ingredients added")
                        }),
                        .default(Text("Instruction"), action: {
                            instrnctions.append(stringToEdit)
                            stringToEdit = ""
                            print("\(instrnctions.count) instructions added")
                        }),
                        .cancel()
                    ])
                }
            
            List {
                Section(header: Text("Text found")) {
                    ForEach(wordlists) { item in
                        Button(action: {
                            stringToEdit = item.title
                            print("Clicked: \(item.title)")
                        }) {
                            Text(item.title)
                        }
                        
                    }
                }
            }
            .sheet(isPresented: $showImagePicker) {
                VStack{
                    imagePicker(image: self.$image, isPresented: $showImagePicker, sourceType: self.sourceType)
                }
            }
        }
    }
    
    private func showActionSheet() {
        showSheet.toggle()
    }
    
    func textRecognition(image: UIImage?) {
        
        print("start scan")
        let vision = Vision.vision()
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["en", "hi"]
        let textRecognizer = vision.cloudTextRecognizer(options: options)
        
        let visionImage = VisionImage(image: image!)
        
        let cameraPosition = AVCaptureDevice.Position.back  // Set to the capture device you used.
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
                    
                    self.wordlists.append(ReadItem.init(title: lineText))
                    for element in line.elements {
                        let elementText = element.text
                        let elementConfidence = element.confidence
                        let elementLanguages = element.recognizedLanguages
                        let elementCornerPoints = element.cornerPoints
                        let elementFrame = element.frame
                    }
                }
            }
        }
        
        
        
        
        
        
        
    }
    func imageOrientation(
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

