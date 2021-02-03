//
//  SettingsView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var env : GlobalEnviroment
    
    var body: some View {
        VStack{
            Text("Current user: \(env.currentUser.firstName) \(env.currentUser.lastName)")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView().environmentObject(GlobalEnviroment())
    }
}
