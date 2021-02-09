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

