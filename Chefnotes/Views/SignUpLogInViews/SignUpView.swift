//
//  SignUpView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-02.
//

import SwiftUI
import Firebase
import SPAlert

/*
 In this view the user can create a new account. I first create an account in firebase auth and then I use that authId to create a new user in firestore. The userId and documentId are set to be the same as the authId
 */

struct SignUpView: View {
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(Color("ColorBackground"))
    }
    
    @EnvironmentObject var session: SessionStore
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var docRef: DocumentReference!
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("ColorBackground")
                VStack{
                    Form {
                        Section {
                            TextField("First name", text: $firstName)
                            TextField("Last name", text: $lastName)
                        }
                        Section {
                            TextField("E-mail", text: $email)
                        }
                        Section(footer: Text("Your password must be at least six figures long")) {
                            SecureField("Create password", text: $password)
                        }
                    
                    Section {
                    Button(action: {saveUserInAuth(email: email, password: password)})
                        {
                        Text("Sign up")}
                        .blueButtonStyle()
                        .listRowBackground(Color("ColorBackground"))
                    }
                    }
                }
            }
            .navigationBarTitle("Create Account")
        }.modifier(DarkModeViewModifier())
    }
    func saveUserInAuth(email: String, password: String) {
        
        session.unbind()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let err = error{
                let alertView = SPAlertView(title: "Error ", message: "\(err.localizedDescription)", preset: SPAlertIconPreset.error)
                alertView.present(duration: 3)
                return
            }
            else {
                saveUserToFirestore()
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
        self.docRef =
            Firestore.firestore().document("users/\(Auth.auth().currentUser?.uid ?? "")")
        
        print("Setting data")
        
        self.docRef.setData(dataToSave) { (error) in
            if let error = error {
                print("error = \(error)")
            }
            else {
                let alertView = SPAlertView(title: "Account created succefully", message: "Go to back to login to enter your account", preset: SPAlertIconPreset.done)
                
                alertView.present(duration: 3)
                print("no error")
                firstName = ""
                lastName = ""
                password = ""
                email = ""
            }
        }
    }
}
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
