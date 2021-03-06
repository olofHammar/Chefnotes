//
//  ContentView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-02.
//

import SwiftUI
import Firebase

/*
 In this view I call the session class onAppear to see if there is a logged in user. While this is loading I display a loading screen. When loading is completed I navigate the user to either the HomeNavigationView or LogInView depending on value returned from session class.
 */

struct ContentView: View {
    
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var env: GlobalEnviroment
    @State private var selectedIndex = 0
    @State private var showModally = false
    @State var userIsLoaded = false
    
    var body: some View {
        
        Group {
            if userIsLoaded {
                if (session.session == nil) {
                    LogInView()
                } else {
                    HomeNavigationView()
                }
            }
            else {
                ZStack {
                    Color("ColorBackground")
                    CircleImageView(image: Image("aubergine"))
                        .frame(width: 200)
                    
                    Image("chefnotes_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 250)
                }
            }
        }.onAppear {
            self.session.listen(completion: { _ in
                if session.session == nil {
                    self.userIsLoaded = true
                }
                else {
                    self.getFirestoreUser() { _ in
                        self.userIsLoaded = true
                    }
                }
            })
        }.modifier(DarkModeViewModifier())
    }
    
    func getFirestoreUser(completion: @escaping (Any) -> Void) {
        Firestore.firestore().collection("users").whereField("id", isEqualTo: Auth.auth().currentUser?.uid ?? "").getDocuments() { (QuerySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in QuerySnapshot!.documents {
                    
                    self.env.currentUser = CurrentUser(
                        id: document.data()["id"] as? String ?? "",
                        firstName: document.data()["firstName"] as? String ?? "",
                        lastName: document.data()["lastName"] as? String ?? "",
                        password: document.data()["password"] as? String ?? "",
                        email: document.data()["email"] as? String ?? "")
                    completion(true)
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
