//
//  AddView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

/*
 In this view the user can select to either create a recipe from the apps template or by using the apps photo scanner.
 */

struct AddView: View {
    
    @State private var isPresented = false
    @State var scanSelected = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color("ColorBackground")
                VStack {
                    HStack {
                        Text("Write recipe")
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                    }.padding(.leading)
                    Button(action: {})
                    {
                        NavigationLink(
                            destination: NewPostView(),
                            label: {
                                HStack {
                                    CircleImageView(image: Image("phone_color"))
                                        .frame(width: UIScreen.main.bounds.size.width/3)
                                        .padding()
                                }.frame(width: UIScreen.main.bounds.size.width/1.1)
                                .background(Color("ColorWhiteLightBlack"))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                            })
                    }
                    Text("Use our simple templates to create your own recipes")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.size.width/1.1)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                    HStack {
                        Text("Scan recipe")
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }.padding(.leading)
                    Button(action: {})
                    {
                        NavigationLink(
                            destination: ScanView(),
                            label: {
                                HStack {
                                    CircleImageView(image: Image("vintage_camera"))
                                        .frame(width: UIScreen.main.bounds.size.width/3)
                                        .padding()
                                }.frame(width: UIScreen.main.bounds.size.width/1.1)
                                .background(Color("ColorWhiteLightBlack"))
                                .cornerRadius(12)
                                .shadow(radius: 5)
                            })
                    }
                    Text("Take a picture of a recipe and scan it in to your book")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.size.width/1.1)
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                        .padding(.bottom, 5)
                        
                        .background(Color("ColorBackground"))
                }
                .padding(.top, 35)
                .frame(width: UIScreen.main.bounds.size.width)
                .background(Color("ColorBackground"))
                .navigationTitle("Add new recipe")
                .navigationBarTitleDisplayMode(.inline)
            }.background(Color("ColorBackground"))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
