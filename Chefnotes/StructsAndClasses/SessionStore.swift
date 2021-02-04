//
//  SessionStore.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import Foundation
import Firebase
import Combine

class SessionStore: ObservableObject {
    
    @Published var session: AuthUser? { didSet { self.didChange.send(self) }}
    var didChange = PassthroughSubject<SessionStore, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    func listen () {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = AuthUser(id: user.uid)
                print(self.session?.id ?? "")
            } else {
                self.session = nil
            }
        }
    }
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            self.session = nil
            return true
        } catch {
            return false
        }
    }

    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
            print("unbound")
        }
    }
    
}

class AuthUser {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}
