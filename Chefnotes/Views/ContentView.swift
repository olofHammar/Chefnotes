//
//  ContentView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-02.
//

import SwiftUI
import Firebase


struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var env: GlobalEnviroment
    @State private var selectedIndex = 0
    @State private var showModally = false
    
    var body: some View {
            Group {
                if (session.session == nil) {
                    LogInView()
                } else {
                    HomeNavigationView()
                }
            }.onAppear {
                self.session.listen()
                self.getFirestoreUser()
            }
    }
    
    func getUser () {
        session.listen()
    }
    
    func getFirestoreUser() {
        Firestore.firestore().collection("users").whereField("id", isEqualTo: Auth.auth().currentUser?.uid ?? "").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                 
                        self.env.currentUser = CurrentUser(
                            firstName: document.data()["firstName"] as? String ?? "",
                            lastName: document.data()["lastName"] as? String ?? "",
                            password: document.data()["password"] as? String ?? "",
                            email: document.data()["email"] as? String ?? "")
                    
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(GlobalEnviroment()).environmentObject(SessionStore())
    }
}
