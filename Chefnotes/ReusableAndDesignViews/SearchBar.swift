//
//  SearchBar.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-16.
//

import SwiftUI

//This file contains the searchbar used in searchView

struct SearchBar: View {
    
    @Binding var searchText: String
    @Binding var isSearching: Bool
    
    var body: some View {
        HStack {
            HStack {
                TextField("Search recipe", text: $searchText)
                    .padding(.leading, 24)
            }
            .padding(12)
            .background(Color(.systemGray5))
            .cornerRadius(6)
            .padding(.horizontal)
            .onTapGesture {
                isSearching = true
            }
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                    Spacer()
                    if isSearching {
                        Button(action: {
                            searchText = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .padding(.vertical)
                        })
                    }
                }
                .padding(.horizontal, 32)
                .foregroundColor(.gray)
            )
            if isSearching {
                Button(action: {
                    isSearching = false
                    searchText = ""
                    UIApplication.shared.endEditing()
                    
                }, label: {
                    Text("Cancel")
                        .padding(.trailing)
                        .padding(.leading, -12)
                })
                .transition(.move(edge: .trailing))
                .animation(.spring())
            }
            
        }
        .padding(.top)
    }
}

struct SearchBar_Previews: PreviewProvider {
    
    @State static var value = "false"
    
    static var previews: some View {
        SearchBar(searchText: $value, isSearching: .constant(false))
    }
}
