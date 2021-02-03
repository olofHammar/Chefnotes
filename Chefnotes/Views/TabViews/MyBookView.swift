//
//  MyBookView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct MyBookView: View {
    
    init() {
        UINavigationBar.appearance().backgroundColor = UIColor(.init(red: 0.95, green: 0.95, blue: 0.95, opacity: 1.0))
    }
    
    @EnvironmentObject var env: GlobalEnviroment
    
    var body: some View {
        NavigationView {
            VStack{
                Text("Login successful!")
                Text("Welcome \(self.env.currentUser.firstName) \(self.env.currentUser.lastName)")
                
            }
            .navigationBarTitle("My Book")
        }
    }
}

struct MyBookView_Previews: PreviewProvider {
    static var previews: some View {
        MyBookView()
    }
}
