//
//  SettingsView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var env : GlobalEnviroment
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack{
            Text("Current user: \(env.currentUser.firstName) \(env.currentUser.lastName)")
            
            Button(action: {
               
                session.signOut()
                session.unbind()
                print(self.session.session ?? "nil")
            
            }){
                Text("Sign Out")
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(GlobalEnviroment()).environmentObject(SessionStore())
    }
}
