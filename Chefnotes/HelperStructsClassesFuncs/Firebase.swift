//
//  Firebase.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-08.
//

import Foundation
import SwiftUI
import Firebase

func fireStoreSubmitData(docRefString: String, dataToSave: [String:Any], completion: @escaping (Any) -> Void, showDetails: Bool = false) {
    
    let docRef = Firestore.firestore().document(docRefString)
    print("Setting data")
    docRef.setData(dataToSave) { error in
        if let err = error {
            print("error \(err)")
        }
        else {
            print("Data uploaded succefully")
            completion(true)
            if showDetails {
                print("Data uploaded \(dataToSave)")
            }
        }
        
    }
}
func fireStoreSubmitIngredients(docRefString: String, dataToSave: [String:Any], completion: @escaping (Any) -> Void, showDetails: Bool = false) {
    let db = Firestore.firestore().document(docRefString)
    let docRef = db.collection("ingredients").document()
    print("Setting data")
    docRef.setData(dataToSave) { error in
        if let err = error {
            print("error \(err)")
        }
        else {
            print("Ingredients uploaded succefully")
            completion(true)
            if showDetails {
                print("Data uploaded \(dataToSave)")
            }
        }
        
    }
}
func fireStoreSubmitSteps(docRefString: String, dataToSave: [String:Any], completion: @escaping (Any) -> Void, showDetails: Bool = false) {
    let db = Firestore.firestore().document(docRefString)
    let docRef = db.collection("steps").document()
    print("Setting data")
    docRef.setData(dataToSave) { error in
        if let err = error {
            print("error \(err)")
        }
        else {
            print("Steps uploaded succefully")
            completion(true)
            if showDetails {
                print("Data uploaded \(dataToSave)")
            }
        }
        
    }
}
func deleteSteps(refId: String, completion: @escaping (Any) -> Void) {
    let db = Firestore.firestore().collection("recipe")
    let docRef = db.document(refId).collection("steps")
    docRef.getDocuments(completion: { querySnapshot, error in
        if let err = error {
            print("error: \(err.localizedDescription)")
            return
        }
        guard let docs = querySnapshot?.documents else {
            return }
        for doc in docs {
            docRef.document(doc.documentID).delete()
        }
    })
    completion(true)
}
func deleteIngredients(refId: String, completion: @escaping (Any) -> Void) {
    let db = Firestore.firestore().collection("recipe")
    let docRef = db.document(refId).collection("ingredients")
    docRef.getDocuments(completion: { querySnapshot, error in
        if let err = error {
            print("error: \(err.localizedDescription)")
            return
        }
        guard let docs = querySnapshot?.documents else {
            return }
        for doc in docs {
            docRef.document(doc.documentID).delete()
        }
    })
    completion(true)
}
func fireStoreUpdateData(docRefString: String, dataToUpdate: [String:Any], completion: @escaping (Any) -> Void, showDetails: Bool = false) {
    
    let docRef = Firestore.firestore().document(docRefString)
    print("Updating data")
    docRef.setData(dataToUpdate, merge: false) { error in
        if let err = error {
            print("error \(err)")
        }
        else {
            print("Data uploaded succefully")
            if showDetails {
                print("Data uploaded \(dataToUpdate)")
            }
            completion(true)
        }
        
    }
}
func updateOtherUsersFavorites(userIds: [String], refString: String, dataToUpdate: [String:Any], completion: @escaping (Any) -> Void) {
    
    let db = Firestore.firestore()
    if userIds.count >  0 {
        for i in 0..<userIds.count {
            print("\(userIds.count)")
            let ref = db.collection("users").document(userIds[i])
            let docRef = ref.collection("favoriteRecipes").document(refString)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    docRef.setData(dataToUpdate, merge: false) { error in
                        if let err = error {
                            print("error \(err)")
                        }
                        else {
                            print("All favorites are now updated")
                        }
                    }
                }
                else {
                    print("Document does not exist")
                }
            }
            completion(true)
        }
    }
    else {
        print("no users")
    }
}


