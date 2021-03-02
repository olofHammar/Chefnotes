//
//  FormRowUserView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-24.
//

import SwiftUI

//This view contains the row view for user information in settings

struct FormRowUserView: View {
    
    var icon: String
    var color: Color
    var firstText: String
    var secondText: String
    
    var body: some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: icon)
                    .imageScale(.large)
                    .foregroundColor(Color.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
            
            Text(firstText)
                .foregroundColor(Color.gray)
            Spacer()
            Text(secondText)
        }
    }
}

struct FormRowUserView_Previews: PreviewProvider {
    static var previews: some View {
        FormRowUserView(icon: "globe", color: Color.pink, firstText: "Website", secondText: "https://github.com")
    }
}
