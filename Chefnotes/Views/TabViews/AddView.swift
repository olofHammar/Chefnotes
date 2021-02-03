//
//  AddView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct AddView: View {
    
    @State private var isPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                
                VStack{
                    Text("This is AddView")
                    Button(action: {
                        isPresented.toggle()
                    }){
                        Text("Open")
                    }.fullScreenCover(isPresented: $isPresented) {
                        NewPostView()
                    }
                }
            }
            .navigationTitle("Add View")
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
