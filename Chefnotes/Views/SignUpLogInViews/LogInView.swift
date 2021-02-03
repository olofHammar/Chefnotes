//
//  LogInView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-02.
//

import SwiftUI
import Firebase
import SPAlert

struct LogInView: View {
    
    @EnvironmentObject var env: GlobalEnviroment
    @State var email: String = ""
    @State var password: String = ""
    @State private var isLoggedIn = false
    
    
    var body: some View {
        
        NavigationView{
            VStack{
                
                AuthTextField(placeHolder: "E-mail", text: $email)
                
                AuthTextField(placeHolder: "Password", text: $password)
                
                NavigationLink(
                    
                    destination: ContentView(),
                    isActive: $isLoggedIn) {
                    Button(action: {
                        signIn(email: email, password: password)
                    }) {
                        Text("Sign In")
                    }
                    }
            }
            
        }
    }
    
    func signIn(email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { user, error in
            
            if let err = error {
                
                let alertView = SPAlertView(title: "Error ", message: "\(err.localizedDescription)", preset: SPAlertIconPreset.error)
                
                alertView.present(duration: 3)
                
                return
            }
            else {
                Firestore.firestore().collection("users").whereField("email", isEqualTo: self.email).getDocuments() { (QuerySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in QuerySnapshot!.documents {
                            if document.data()["password"] as? String ?? "" == (self.password) {
                                self.env.currentUser = CurrentUser(
                                    firstName: document.data()["firstName"] as? String ?? "",
                                    lastName: document.data()["lastName"] as? String ?? "",
                                    password: document.data()["password"] as? String ?? "",
                                    email: document.data()["email"] as? String ?? "")
                            }
                            isLoggedIn = true
                        }
                    }
                }
            }
        
            
            
            guard user != nil else { return }
        }
        }
    }


struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
