//
//  LogInView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-02.
//

import SwiftUI
import Firebase
import SPAlert

/*
 In this view the user can sign in to account. I use firebase auth function signInWithEmailAndPassword and if sign in is success is check the password against the firestore user with the same email. If password match I set the user logging in to environment object current user.
 */

struct LogInView: View {
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(Color("ColorBackgroundButton"))
    }
    
    @EnvironmentObject var env: GlobalEnviroment
    @EnvironmentObject var session: SessionStore
    @State var email: String = ""
    @State var password: String = ""
    @State private var signUpVisible = false
    @State private var isLoggedIn = false
    
    
    var body: some View {
        
        NavigationView {
            // Color("ColorBackgroundButton")
            Form {
                Section {
                    ZStack {
                        CircleImageView(image: Image("aubergine"))
                            .frame(width: 200)
                        Image("chefnotes_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 250)
                    }
                }.listRowBackground(Color("ColorBackgroundButton"))
                Section {
                    TextField("Enter E-mail", text: $email)
                    SecureField("Enter password", text: $password)
                }
                Section {
                    Button(action: { signIn(email: email, password: password) })
                    {
                        Text("Log in")
                            .blueButtonStyle()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowBackground(Color("ColorBackgroundButton"))
                    
                    Button(action: { self.signUpVisible.toggle() })
                    {
                        HStack {
                            Spacer()
                            Text("Or click here to sign up").font(.footnote)
                            Spacer()
                        }
                    }
                    .background(Color.clear)
                    .foregroundColor(.blue)
                    .sheet(isPresented: $signUpVisible, content:{ SignUpView() })
                }
                .listRowBackground(Color("ColorBackgroundButton"))
            }.background(Color("ColorBackgroundButton"))
        }
    }
    
    func signIn(email: String, password: String) {
        session.listen(completion: {_ in })
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
                                    id: document.data()["id"] as? String ?? "",
                                    firstName: document.data()["firstName"] as? String ?? "",
                                    lastName: document.data()["lastName"] as? String ?? "",
                                    password: document.data()["password"] as? String ?? "",
                                    email: document.data()["email"] as? String ?? "" )
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
