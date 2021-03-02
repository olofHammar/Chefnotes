//
//  SettingsView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI
import Firebase
import SPAlert

/*
 This view conrains the user settings. Here I use a picker to swich between light/dark mode and user can update email and password.
 */

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var env : GlobalEnviroment
    @EnvironmentObject var session: SessionStore
    @State var showAlert = false
    @State var changePassword = false
    @State var changeEmail = false
    @State var colorSc: ColorScheme = .light
    @State var currentPassword = ""
    @State var newPassword = ""
    @State var currentEmail = ""
    @State var newEmail = ""
    
    var body: some View {
        
        ZStack {
            Color("ColorBackgroundButton")
            VStack(alignment: .center, spacing: 0) {
                
                Form {
                    Section {
                        Picker("Mode", selection: $isDarkMode) {
                            Text("Light")
                                .tag(false)
                            Text("Dark")
                                .tag(true)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .listRowBackground(Color("ColorBackgroundButton"))
                    }
                    Section(header: Text("About User")) {
                        FormRowUserView(icon: "person", color: Color.pink, firstText: "User", secondText: "\(env.currentUser.firstName) \(env.currentUser.lastName)")
                        Button(action: { changeEmail = true })
                        {
                            HStack {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.blue)
                                    Image(systemName: "envelope")
                                        .imageScale(.large)
                                        .foregroundColor(Color.white)
                                }
                                .frame(width: 36, height: 36, alignment: .center)
                                
                                Text("Change e-mail")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                Toggle(isOn: $changeEmail) {}
                            }
                        }
                        if changeEmail {
                            TextField("Current e-mail", text:$currentEmail )
                            TextField("New e-mail", text: $newEmail)
                            Button(action: { updateEmail() })
                            {
                                Text("Update e-mail")
                            }
                        }
                        Button(action: { changePassword = true })
                        {
                            HStack {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.green)
                                    Image(systemName: "key")
                                        .imageScale(.large)
                                        .foregroundColor(Color.white)
                                }
                                .frame(width: 36, height: 36, alignment: .center)
                                
                                Text("Change password")
                                    .foregroundColor(Color.gray)
                                Spacer()
                                Toggle(isOn: $changePassword) {}
                            }
                        }
                        if changePassword {
                            TextField("Current password", text: $currentPassword)
                                .autocapitalization(.none)
                            TextField("New password", text: $newPassword)
                                .autocapitalization(.none)
                            Button(action: {
                                updatePassword()
                            }){
                                Text("Update password")
                            }
                        }
                    }
                    Section(header: Text("About the application")) {
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Olof Hammar")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical, 3)
                    Section {
                        Button(action: { showSignOutAlert() })
                        {
                            FormRowUserView(icon: "figure.walk", color: Color.orange, firstText: "Sign Out", secondText: "")
                        }
                        .alert(isPresented: self.$showAlert, content: {
                            Alert(title: Text("Sign out"), message: Text("Are you sure you want to sign out?"), primaryButton: .default(Text("Yes"), action: {
                                session.signOut()
                                session.unbind()
                            }), secondaryButton: .cancel())
                        })
                    }
                }
                .padding(.top, 20)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("ColorBackgroundButton"))
        }
        .modifier(DarkModeViewModifier())
    }
    private func showSignOutAlert() {
        showAlert.toggle()
    }
    private func updatePassword() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(env.currentUser.id)
        let user = Auth.auth().currentUser
        
        if currentPassword == env.currentUser.password {
            //I have to get this credential if user has been signed in for long.
            let credential = EmailAuthProvider.credential(withEmail: env.currentUser.email, password: env.currentUser.password)
            
            user?.reauthenticate(with: credential, completion: { (result, error) in
                if let err = error {
                    print("error: \(err)")
                } else {
                    //.. go on
                    user?.updatePassword(to: newPassword, completion: { (error) in
                        if let err = error {
                            print("couldnt change password \(err)")
                        }
                        else {
                            docRef.updateData([
                                "password": newPassword
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                    let alertView = SPAlertView(title: "Password updated!", message: "Your password has been changed", preset: SPAlertIconPreset.done)
                                    alertView.present(duration: 3)
                                    currentPassword = ""
                                    newPassword = ""
                                    changePassword.toggle()
                                }
                            }
                        }
                    })
                }
            })
        }
        else {
            let alertView = SPAlertView(title: "Passwords doesn't match", message: "Check that you filled in your current password correctly" , preset: SPAlertIconPreset.error)
            
            alertView.present(duration: 3)
        }
        
    }
    private func updateEmail() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(env.currentUser.id)
        let user = Auth.auth().currentUser
        
        if currentEmail == env.currentUser.email {
            
            let credential = EmailAuthProvider.credential(withEmail: env.currentUser.email, password: env.currentUser.password)
            
            user?.reauthenticate(with: credential, completion: { (result, error) in
                if let err = error {
                    print("error: \(err)")
                } else {
                    //.. go on
                    user?.updateEmail(to: newEmail, completion: { (error) in
                        if let err = error {
                            print("couldnt change password \(err)")
                        }
                        else {
                            docRef.updateData([
                                "email": newEmail
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Email successfully updated")
                                    let alertView = SPAlertView(title: "E-mail updated!", message: "Your e-mail has been changed", preset: SPAlertIconPreset.done)
                                    alertView.present(duration: 3)
                                    currentEmail = ""
                                    newEmail = ""
                                    changeEmail.toggle()
                                }
                            }
                        }
                    })
                }
            })
        }
        else {
            let alertView = SPAlertView(title: "E-mail doesn't match", message: "Check that you filled in your current e-mail correctly" , preset: SPAlertIconPreset.error)
            
            alertView.present(duration: 3)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(GlobalEnviroment()).environmentObject(SessionStore())
    }
}
