//
//  AuthTextField.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//
//
//import SwiftUI
//
//struct AuthTextField: View {
//    
//    var placeHolder: String = "placeholder"
//    @Binding var text: String
//    
//    var body: some View {
//        
//        VStack{
//            
//            TextField(placeHolder, text: $text)
//                .font(.title2)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .background(RoundedRectangle(cornerRadius: 10))
//                .foregroundColor(.secondary)
//                .padding(.horizontal)
//                .shadow(radius: 2)
//        }.padding(.horizontal)
//    }
//}
//
//struct AuthTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        AuthTextField(text: .constant(""))
//    }
//}
