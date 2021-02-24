//
//  SettingsView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @EnvironmentObject var env : GlobalEnviroment
    @EnvironmentObject var session: SessionStore
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
                        Button(action: {
                            changeEmail = true
                        }) {
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
                            Button(action: {
                                print("\(newEmail)")
                            }){
                                Text("Update e-mail")
                            }
                        }
                        Button(action: {
                            changePassword = true
                        }) {
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
                            TextField("New password", text: $newPassword)
                            Button(action: {
                                print("\(newPassword)")
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
                        Button(action: {
                            session.signOut()
                            session.unbind()
                        }) {
                            FormRowUserView(icon: "figure.walk", color: Color.orange, firstText: "Sign Out", secondText: "")
                        }
                    }
                }
                .padding(.top, 20)
//                Text("Created by: Olof Hammar ✌️")
//                    .font(.footnote)
//                    .padding(.top, 6)
//                    .padding(.bottom, 8)
//                    .foregroundColor(.secondary)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color("ColorBackgroundButton"))
        }
        .modifier(DarkModeViewModifier())
    }
}
    
    struct SettingsView_Previews: PreviewProvider {
        static var previews: some View {
            SettingsView().environmentObject(GlobalEnviroment()).environmentObject(SessionStore())
        }
    }
