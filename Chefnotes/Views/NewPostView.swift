//
//  NewPostView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct NewPostView: View {
    
    //@Binding var showModally: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.red
            VStack{
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
                .padding()
                .background(Color.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
