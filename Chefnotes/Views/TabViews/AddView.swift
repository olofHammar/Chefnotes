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
                grayBlue
                
                VStack {
                    HStack {
                        Text("Write recipe")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.leading)

                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        HStack {
                            CircleImageView(image: Image("phone_color"))
                                .frame(width: UIScreen.main.bounds.size.width/3)
                                .padding()
                        }.frame(width: UIScreen.main.bounds.size.width/1.1)
                        .background(Color(.white))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                        
                    }.fullScreenCover(isPresented: $isPresented) {
                        NewPostView()}
                    
                    Text("Use our simple templates to create your own recipes")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.size.width/1.1)
                        .foregroundColor(costumDarkGray)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    
                    
                    HStack {
                        Text("Scan recipe")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }.padding(.leading)
                    Button(action: {
                        self.isPresented.toggle()
                    }) {
                        HStack {
                            CircleImageView(image: Image("vintage_camera"))
                                .frame(width: UIScreen.main.bounds.size.width/3)
                                .padding()
                        }.frame(width: UIScreen.main.bounds.size.width/1.1)
                        .background(Color(.white))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                    }.fullScreenCover(isPresented: $isPresented) {
                        NewPostView()}
                    
                    Text("Take a picture of a recipe and scan it in to your book")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.size.width/1.1)
                        .foregroundColor(costumDarkGray)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        
                        .background(grayBlue)
                }
                .padding(.top, 35)
                .frame(width: UIScreen.main.bounds.size.width)
                .background(grayBlue)
                .navigationTitle("Add new recipe")
                .navigationBarTitleDisplayMode(.inline)
            }.background(grayBlue)
        }//.padding(.bottom, 40).background(grayBlue)
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
