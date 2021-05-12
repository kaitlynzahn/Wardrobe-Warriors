//
//  ContentView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI

//struct ContentView: View {
//        var body: some View {
//            WardrobeNavigationSwiftUIView()
//        }
//}
    
struct ContentView: View {
    @State var selectedView = 2
    
    let creamColor = Color(red: 233/255, green: 215/255, blue: 195/255)
    let peachColor = Color(red: 228/255, green: 169/255, blue: 135/255)
    
    init() {
        UITabBar.appearance().barTintColor = UIColor(peachColor)
        UITabBar.appearance().selectedImageTintColor = UIColor(creamColor)
        //qqUITabBar.appearance().unselectedItemTintColor = UIColor.red
    }

    var body: some View {
        TabView(selection: $selectedView) {
            
            // page content
            NavigationView {
                OutfitSubmissionSwiftUIView()
            }
            // explains what tab item it is
            .tabItem {
                Label("Today's Picks", systemImage: "calendar")
            }
            // sets the tag
            .tag(1)

            
//            Button("Show First View") {
//                selectedView = 1
//            }
//            .padding()
            NavigationView {
                WardrobeNavigationSwiftUIView()
            }
            .tabItem {
                Label("My Closet", systemImage: "bag")
            }
            .tag(2)
            
            
//            Button("Show First View") {
//                selectedView = 1
//            }
//            .padding()
            NavigationView {
                ClothingSubmissionSwiftUIView()
            }
            .tabItem {
                Label("Add Clothes", systemImage: "plus.circle")
            }
            .tag(3)
        } // TabView
        .accentColor(creamColor)
    } // end body
} // end view



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
