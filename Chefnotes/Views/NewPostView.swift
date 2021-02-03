//
//  NewPostView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

var mockData : [String] = ["200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt", "200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt", "200 g Tomater", "70 g Potatis", "12 g Persilja", "10 g Salt"]
var mockDataCooking : [String] = ["Koka potatis", "Stek tomater", "Krydda med salt och persilja"]

struct NewPostView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ZStack{
                ScrollView{
                    VStack{
                        Spacer()
                        HStack {

                            CircleImageView(image: Image("camera_blue"))
                                .frame(width: 80)
                            Text("Add image")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
        
                        }
                        .background(Color.white)
                        .shadow(radius: 2)
                        
                        ZStack {
                            Image("default_image")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            Button(action:{}) {
                                Image(systemName: "plus.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: UIScreen.main.bounds.size.width/7)
                                    .background(Color.white)
                                    .cornerRadius(40)
                                    .padding(.leading, 290)
                                    .padding(.top, 290)
                            }
                        }
                        .padding(.bottom)
                        .frame(width: UIScreen.main.bounds.size.width/1.1)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 0.5))
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                        Spacer()
                        HStack {
                            CircleImageView(image: Image("beetroot"))
                                .frame(width: 70)
                            Text("Add ingredients")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Button(action: {
                                //self.halfModalShown.toggle()
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding()
                            }
                            //Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.size.width)
                        .background(Color.white)
                        .shadow(radius: 2)
                        .padding(.top, 50)
                        
                        Spacer()
                        
                        VStack{
                            
                        VStack{
                            ScrollView{
                                 
                                ForEach(mockData, id: \.self) { item in
                                    HStack{
                                        Image(systemName: "circle.fill")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                        Text(item)
                                        Spacer()
                                    }
                                    .padding(.leading, 50)
                                }.frame(width: UIScreen.main.bounds.size.width-45)
                            }
                            .frame(height: UIScreen.main.bounds.size.height/4)
                            .padding()
                        }
                        .frame(width: UIScreen.main.bounds.size.width/1.1)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 0.5))
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                        
                        }.padding(.top)
                        
                        HStack {
                            CircleImageView(image: Image("cooking"))
                                .frame(width: 80)
                            Text("Add steps")
                                .font(.title2)
                                .fontWeight(.bold)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                            Button(action: {
                                //self.halfModalShown.toggle()
                            }) {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding()
                            }
                        }
                        .frame(width: UIScreen.main.bounds.size.width)
                        .background(Color.white)
                        .shadow(radius: 2)
                        .padding(.top, 50)

                        VStack{
                            
                        VStack{
                            Group{
                                 
                                ForEach(mockDataCooking, id: \.self) { item in
                                    Text(item)
                                }
                            }.padding()
                        }
                        .frame(width: UIScreen.main.bounds.size.width/1.1)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray, lineWidth: 0.5))
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                            
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                HStack{
                                Text("Save Recipe")
                                    .fontWeight(.semibold)
                                    .padding()
                                }
                                .frame(width: UIScreen.main.bounds.size.width/1.1,
                                       height: 50)
                                .background(costumOrange)
                                .foregroundColor(.white)
                                .cornerRadius(5)
                            }.padding(.top)
                            .padding(.bottom)
                        }.padding(.top)

                        Spacer()
                        
                    }.padding(.top, 12)
                    
                }
                VStack{
                    Button(action: { dismissModal() }) {
                        
                        ZStack{
                            Image(systemName: "x.circle")
                                .foregroundColor(costumDarkGray)
                                .font(.system(size: 40))
                            
                            Image(systemName: "x.circle.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 41))
                                .shadow(radius: 4)
                        }
                        .padding()
                        
                    }.padding(.leading, UIScreen.main.bounds.size.width/1.2)
                    .padding(.bottom, UIScreen.main.bounds.size.height/1.15)
                }
            }
        }
        .background(grayBlue)
        .padding(.top, 1)
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
