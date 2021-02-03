//
//  SignUpView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-02.
//

import SwiftUI
import Firebase
import SPAlert

struct SignUpView: View {
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var docRef: DocumentReference!
    
    
    var body: some View {
        ZStack {
            VStack(spacing: 0){
                VStack(spacing: 20){
                        
                    AuthTextField(placeHolder: "First name", text: $firstName)
                        
                    AuthTextField(placeHolder: "Last name", text: $lastName)
                        
                    AuthTextField(placeHolder: "Password", text: $password)
                        
                    AuthTextField(placeHolder: "E-mail", text: $email)
                    
                    Button(action: {
                        saveUserInAuth(email: email, password: password)
                        //hideKeyboard()
                        print("Here")
                    }) {
                        
                        Text("Sign Up").foregroundColor(.white).padding(12)
                            
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            .shadow(radius: 5)
                    }
                }
            }
        }
    }
    func saveUserInAuth(email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let err = error{
                
                let alertView = SPAlertView(title: "Error ", message: "\(err.localizedDescription)", preset: SPAlertIconPreset.error)
                
                alertView.present(duration: 3)
                return
            }
            else {
                saveUserToFirestore()
                print("First step done")
            }
        }
    }
    
    func saveUserToFirestore() {
        
        let dataToSave: [String:Any] = [
            "id":Auth.auth().currentUser?.uid ?? "",
            "firstName":self.firstName,
            "lastName":self.lastName,
            "password":self.password,
            "email":self.email
        ]
        print("Setting ref")
        self.docRef = Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")")
        
        print("Setting data")
        
        self.docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("error = \(error)")
            }
            else {
                let alertView = SPAlertView(title: "Account created succefully", message: "Go to back to login to enter your account", preset: SPAlertIconPreset.done)
                
                alertView.present(duration: 3)
                print("no error")
            }
        }
    }
    
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
