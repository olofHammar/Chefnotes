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
    @State var preferredColorScheme: ColorScheme? = nil
    
    @State var colorSc: ColorScheme = .light
    @EnvironmentObject var session: SessionStore
    
    var body: some View {

        ZStack {
            Color("ColorBackgroundButton")
            VStack(alignment: .center, spacing: 0) {
                Picker("Mode", selection: $isDarkMode) {
                    Text("Light")
                        .tag(false)
                    Text("Dark")
                        .tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .padding(.top, 40)
                .background(Color("ColorBackgroundButton"))

                Form {
                    Section(header: Text("About User")) {
                        FormRowUserView(icon: "person", color: Color.pink, firstText: "User", secondText: "\(env.currentUser.firstName) \(env.currentUser.lastName)")
                        FormRowUserView(icon: "envelope", color: Color.blue, firstText: "E-mail", secondText: "\(env.currentUser.email)")
                        FormRowUserView(icon: "key", color: Color.green, firstText: "Password", secondText: "******")
                        Button(action: {
                            session.signOut()
                            session.unbind()
                        }) {
                            FormRowUserView(icon: "figure.walk", color: Color.orange, firstText: "Sign Out", secondText: "")}
                    }
//                    Section(header: Text("Light/Dark mode")) {
//                        //Toggle("Darkmode", isOn: $DarkModeIsOn)
//
//                    }
                    Section(header: Text("About the apllication")) {
                        FormRowStaticView(icon: "checkmark.seal", firstText: "Compatibility", secondText: "iPhone")
                        FormRowStaticView(icon: "keyboard", firstText: "Developer", secondText: "Olof Hammar")
                        FormRowStaticView(icon: "flag", firstText: "Version", secondText: "1.0.0")
                    }
                    .padding(.vertical, 3)
                }
                .padding(.top, 20)
                Text("Created by: Olof Hammar ✌️")
                    .font(.footnote)
                    .padding(.top, 6)
                    .padding(.bottom, 8)
                    .foregroundColor(.secondary)
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
