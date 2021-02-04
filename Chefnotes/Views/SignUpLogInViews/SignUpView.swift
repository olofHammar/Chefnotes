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
    
    @EnvironmentObject var session: SessionStore
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State private var docRef: DocumentReference!
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                grayBlue
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
                    }
                    Button(action: {saveUserInAuth(email: email, password: password)})
                        {Text("Sign up")}
                        .blueButtonStyle()
                        .padding(.bottom, 40)
                }
            }
            .navigationBarTitle("Create Account")
        }
        
    }
    func saveUserInAuth(email: String, password: String) {
        
        session.unbind()
        print(self.session.session ?? "empty")
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            
            if let err = error{
                
                let alertView = SPAlertView(title: "Error ", message: "\(err.localizedDescription)", preset: SPAlertIconPreset.error)
                
                alertView.present(duration: 3)
                return
            }
            else {
                saveUserToFirestore()
                print(self.session.session ?? "empty")
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
