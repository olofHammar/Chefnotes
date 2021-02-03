//
//  NewPostView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct NewPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            Color.red
            VStack{
                Button("Close", action: dismissModal)
                    .padding()
                    .background(Color.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func dismissModal() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewPostView_Previews: PreviewProvider {
    static var previews: some View {
        NewPostView()
    }
}
