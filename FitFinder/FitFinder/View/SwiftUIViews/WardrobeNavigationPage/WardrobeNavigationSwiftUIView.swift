//
//  WardrobeNavigationSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct WardrobeNavigationSwiftUIView: View {
    let locationmanager = LocationManager()
    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    
    var body: some View {
        
        // initialize custom colors
        // let yellowColor = Color(red: 221/255, green: 184/255, blue: 106/255)
        let peachColor = Color(red: 228/255, green: 169/255, blue: 135/255)
        let blueColor = Color(red: 155/255, green: 174/255, blue: 191/255)
        let creamColor = Color(red: 233/255, green: 215/255, blue: 195/255)
        
        
        
        NavigationView {
            VStack {
                // HStack to get width
                HStack {
                    // title
                    Text("WARDROBE")
                        .font(.custom("Sunday Morning", size: 38))
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .foregroundColor(creamColor)
                }
                .padding(8)
                .padding(.top, -30)
                
                // title doesn't scroll, but page does
                ScrollView(.vertical, showsIndicators: false) {
                    
                    // shirts title
                    HStack {
                        Text("   Shirts")
                            .font(.custom("Sunday Morning", size: 30))
                            .font(.title)
                            .foregroundColor(creamColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(peachColor)
                                .frame(width: 1000)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    } // HStack
                    // shirts images are scrollable horizontally
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.shirt {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            ZStack() {
                                                Rectangle()
                                                    .frame(width: 250, height: 280)
                                                    .shadow(radius: 5)
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 220.0, height: 220.0)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Rectangle())
                                                    //.cornerRadius(15)
                                                    .shadow(radius: 5)
                                                    .onTapGesture(count: 2) {
                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                    }
                                            } // ZStack

                                        } // NavigationLink
                                        .isDetailLink(false)
                                    }
                                }
                                
                            } // ForEach
                        } // HStack
                        .padding(10)
                        .padding(.bottom, 30)
                    } // ScrollView
                    
 
                    // long sleeve shirts title
                    HStack {
                        Text("   Long Sleeve Shirts")
                            .font(.custom("Sunday Morning", size: 30))
                            .font(.title)
                            .foregroundColor(creamColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(peachColor)
                                .frame(width: 1000)
                            )
                            .offset(x: -6, y: 0)
                        
                        Spacer()
                    } // HStack
                    // long sleeve shirts images are scrollable horizonatally
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.longSleeveShirt {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            ZStack() {
                                                Rectangle()
                                                    .frame(width: 250, height: 280)
                                                    .shadow(radius: 5)
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 220.0, height: 220.0)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Rectangle())
                                                    //.cornerRadius(15)
                                                    .shadow(radius: 5)
                                                    .onTapGesture(count: 2) {
                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                    }
                                            } // ZStack
                                            // Old Way
//                                                .gesture(
//                                                                LongPressGesture(minimumDuration: 1)
//                                                                    .onEnded { _ in
//                                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
//                                                                    }
//                                                            )
                                        } // NavigationLink
                                        .isDetailLink(false)

                                    }
                                }
                                
                            } // ForEach
                        } // HStack
                        .padding(10)
                        .padding(.bottom, 30)
                    } // ScrollView
                    
                    
                    // pants title
                    HStack {
                        Text("   Pants")
                            .font(.custom("Sunday Morning", size: 30))
                            .font(.title)
                            .foregroundColor(creamColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(peachColor)
                                .frame(width: 1000)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    } // HStack
                    // pants images are horizontally scrollable
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.pants {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            ZStack() {
                                                Rectangle()
                                                    .frame(width: 250, height: 280)
                                                    .shadow(radius: 5)
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 220.0, height: 220.0)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Rectangle())
                                                    //.cornerRadius(15)
                                                    .shadow(radius: 5)
                                                    .onTapGesture(count: 2) {
                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                    }
                                            } // ZStack

                                        } // NavigationLink
                                        .isDetailLink(false)
                                    }
                                }
                                
                            } // ForEach
                        } //HStack
                        .padding(10)
                        .padding(.bottom, 30)
                    } // ScrollView
                    
                    
                    // title for shorts
                    HStack {
                        Text("   Shorts")
                            .font(.custom("Sunday Morning", size: 30))
                            .font(.title)
                            .foregroundColor(creamColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(peachColor)
                                .frame(width: 1000)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    } // HStack
                    // shorts are scrollable horizontally
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.shorts {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            ZStack() {
                                                Rectangle()
                                                    .fill(creamColor)
                                                    .frame(width: 250, height: 280)
                                                    .shadow(radius: 5)
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 220.0, height: 220.0)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Rectangle())
                                                    //.cornerRadius(15)
                                                    .shadow(radius: 5)
                                                    .onTapGesture(count: 2) {
                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                    }
                                            } // ZStack

                                        } // NavigationLink
                                        .isDetailLink(false)
                                    }
                                }
                                
                            } // ForEach
                        } // HStack
                        .padding(10)
                        .padding(.bottom, 30)
                    } // ScrollView
                    
                    
                    // title for skirts
                    HStack {
                        Text("   Skirts")
                            .font(.custom("Sunday Morning", size: 30))
                            .font(.title)
                            .foregroundColor(creamColor)
                            .padding(3)
                            .background(
                                RoundedRectangle(
                                    cornerRadius: 10,
                                    style: .continuous
                                )
                                .fill(peachColor)
                                .frame(width: 1000)
                            )
                            .offset(x: -6, y: 0)
                        Spacer()
                    } // HStack
                    // skirts are scrollable horizontally
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(alignment: .top, spacing: 18) {
                            ForEach(articlesOfClothing, id: \.id) { articleOfClothing in
                                if articleOfClothing.typeOfClothing == TypeOfClothing.skirt {
                                    if let image = articleOfClothing.image {
                                        NavigationLink(destination: ClothingSubmissionSwiftUIView(articleOfClothing: articleOfClothing)) {
                                            ZStack() {
                                                Rectangle()
                                                    .frame(width: 250, height: 280)
                                                    .shadow(radius: 5)
                                                Image(uiImage: image)
                                                    .resizable()
                                                    .frame(width: 220.0, height: 220.0)
                                                    .aspectRatio(contentMode: .fit)
                                                    .clipShape(Rectangle())
                                                    //.cornerRadius(15)
                                                    .shadow(radius: 5)
                                                    .onTapGesture(count: 2) {
                                                        deleteArticleOfClothing(selectedArticleOfClothing: articleOfClothing)
                                                    }
                                            } // ZStack

                                        } // NavigationLink
                                        .isDetailLink(false)
                                    }
                                }
                                
                            } // ForEach
                        } // HStack
                        .padding(10)
                        .padding(.bottom, 30)
                    } // ScrollView
                    
                    
                } // ScrollView for all clothing items
                Spacer()
            } // VStack (entire page)
            .padding(.top, -30)
            .background(blueColor.ignoresSafeArea(.all))
//            .onAppear { clearMatchedOutfits() }
//            .navigationBarItems(leading:
//                                    NavigationLink(destination: OutfitSubmissionSwiftUIView()) {
//                                        Image(systemName: "calendar").imageScale(.medium)
//                                    }
//                                    .isDetailLink(false),
//                                trailing:
//                                    NavigationLink(destination: ClothingSubmissionSwiftUIView()) {
//                                        Image(systemName: "plus").imageScale(.medium)
//                                    }
//                                    .isDetailLink(false)
//            )
            
        } // NavigationView (entire page)
        
    } // end view
    
    
    
    // function to delete article of clothing
    func deleteArticleOfClothing(selectedArticleOfClothing: ArticleOfClothing) {
        guard let managedContext = selectedArticleOfClothing.managedObjectContext else {
            return
        }
        
        managedContext.delete(selectedArticleOfClothing)
        
        do {
            try managedContext.save()
            
        } catch {
            print("Delete failed")
        }
    }
    
    
    
//    func clearMatchedOutfits() {
//        for articleOfClothing in articlesOfClothing {
//            articleOfClothing.picked = 0
//            do {
//                try articleOfClothing.managedObjectContext?.save()
//            } catch {
//                print(error)
//            }
//        }
//    }
}



struct WardrobeNavigationSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeNavigationSwiftUIView()
    }
}
