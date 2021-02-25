//
//  TabView.swift
//  Chefnotes
//
//  Created by Olof Hammar on 2021-02-03.
//

import SwiftUI

struct HomeNavigationView: View {
    
    @State private var selectedIndex = 0
    
    var body: some View {
        ZStack{
            TabView(selection: $selectedIndex) {
                MyBookView()
                    .tabItem {
                        Image(systemName: "book")
                        Text("My Book")
                        
                    }
                    .tag(0)
                AddView()
                    .tabItem {
                        Image(systemName: "plus.circle")
                        Text("Add recipe")
                        
                    }
                    .tag(1)
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search")
                        
                    }
                    .tag(2)
                ShopCartView()
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Shopping list")
                    }
                    .tag(3)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeNavigationView()
    }
}
