//
//  SearchView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct SearchView: View {
    
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Text("This is SearchView")
                    Button(action: {
                        session.signOut()
                    }){
                        Text("Sign Out")
                    }
                }
            }
            .navigationBarTitle("Search View")
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView().environmentObject(SessionStore())
    }
}
