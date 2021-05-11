//
//  ClothingSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData
import CoreGraphics

struct ClothingSubmissionSwiftUIView: View {
    
    // initializing custom colors
    private static let yellowColor = Color(red: 221/255, green: 184/255, blue: 106/255)
    private static let peachColor = Color(red: 228/255, green: 169/255, blue: 135/255)
    private static let blueColor = Color(red: 155/255, green: 174/255, blue: 191/255)
    private static let creamColor = Color(red: 233/255, green: 215/255, blue: 195/255)
    
    var existingArticleOfClothing: ArticleOfClothing?
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: Type of Clothing Variables
    var typesOfClothing = [TypeOfClothing.shirt, TypeOfClothing.longSleeveShirt, TypeOfClothing.pants, TypeOfClothing.shorts, TypeOfClothing.skirt]
    @State private var selectedTypeOfClothing = 2
    
    // MARK: Formality Variables
    @State private var pickedFormality = 0
    var typeOfFormality = [Formality.casual, Formality.formal]
    
    // MARK: Camera Variables
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    @State var selectedTemperature: Int = 0

    // appropriate temperature variables
    private let appropriateTemperatures: [String] = [Temperature.veryCold.emoji, Temperature.cold.emoji, Temperature.mild.emoji, Temperature.hot.emoji, Temperature.veryHot.emoji]
    
    
    
    
    init() {
        existingArticleOfClothing = nil
        
        //this changes the "thumb" that selects between items
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(FitFinderColors.peachColor.color)
        //and this changes the color for the whole "bar" background
        UISegmentedControl.appearance().backgroundColor = UIColor(FitFinderColors.creamColor.color)

        //these lines change the text color for various states
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(FitFinderColors.creamColor.color)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor : UIColor(FitFinderColors.blueColor.color)], for: .normal)
    }
    
    
    
    init(articleOfClothing: ArticleOfClothing) {
        existingArticleOfClothing = articleOfClothing
    }
    
    
    
    // code for the view
    var body: some View {
        NavigationView {
            VStack {
                
//                VStack {
//                    Text("Save")
//                        .font(.largeTitle)
//                        .padding(100)
//                        .padding(.top, 0)
//                    NavigationLink(destination: OutfitSubmissionSwiftUIView() ) {
//                        Text("Save")
//                    }
//                }
                
                // HStack to get width
                HStack {
                    // title
                    Text("Add New Clothes")
                        .font(.custom("Sunday Morning", size: 38))
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .padding(.top, 100)
                        .foregroundColor(ClothingSubmissionSwiftUIView.creamColor)
                } // HStack
                
                
                ZStack() {
                    // cream border behind the picture
                    Rectangle()
                        .fill(ClothingSubmissionSwiftUIView.creamColor)
                        .frame(width: 280, height: 310)
                        .shadow(radius: 5)
                    // use the image that they selected/took
                    if selectedImage != nil {
                        Image(uiImage: selectedImage!)
                            .resizable()
                            .frame(width: 250.0, height: 250.0)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                            //.cornerRadius(25)
                            .shadow(radius: 5)
                    }
                    // otherwise use tshirt as the default image
                    else {
                        Image("tshirt")
                            .resizable()
                            .frame(width: 250.0, height: 250.0)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Rectangle())
                            //.cornerRadius(25)
                            .shadow(radius: 10)
                    }
                } // ZStack
                HStack {
                    // this code had text instead of the camera picture
//                    Button("                    Camera") {
//                        self.sourceType = .camera
//                        self.isImagePickerDisplay.toggle()
//                    }
                    // camera
                    Button(action: {
                        self.sourceType = .camera
                        self.isImagePickerDisplay.toggle()
                    }) {
                            Image(systemName: "camera")
                    }
                    .padding(.trailing, 105)
                    .padding(.top, 10)
                    
                    // this code had text instead of photo picture
//                    Button("Photo Library               ") {
//                        self.sourceType = .photoLibrary
//                        self.isImagePickerDisplay.toggle()
//                    }
                    // photo library
                    Button(action: {
                        self.sourceType = .photoLibrary
                        self.isImagePickerDisplay.toggle()
                    }) {
                            Image(systemName: "photo")
                    }
                    .padding(.leading, 105)
                    .padding(.top, 10)
                } // HStack
                
                
                // picker to select whether a shirt is casual or formal
                Picker(selection: $pickedFormality, label: Text("Choose the Formality")) {
                    ForEach(0..<typeOfFormality.count) {
                        switch self.typeOfFormality[$0] {
                            case .casual:
                                Text("Casual").tag($0)
                                    .font(.custom("Sunday Morning", size: 50))
//                                    .foregroundColor(ClothingSubmissionSwiftUIView.yellowColor)
                            case .formal:
                                Text("Formal").tag($0)
                                    .font(.custom("Sunday Morning", size: 20))
//                                    .foregroundColor(ClothingSubmissionSwiftUIView.peachColor)
                        } // switch
                    } // ForEach
                } // Picker
                .shadow(radius: 5)
                .pickerStyle(SegmentedPickerStyle())
                .padding(32)
                
                
                // Picker to select the appropriate weather
                TemperatureSegmentedPickerSwiftUIView(items: self.appropriateTemperatures, selection: self.$selectedTemperature)
                    .padding()
                    .padding(.top, -10)
                    .shadow(radius: 5)
                
                
                // picker to select the type of clothing
                Picker(selection: $selectedTypeOfClothing, label: Text("Please choose a type of clothing")) {
                    ForEach(0 ..< typesOfClothing.count) {
                        switch typesOfClothing[$0] {
                        case .shirt:
                            Text("Shirt")
                                .foregroundColor(ClothingSubmissionSwiftUIView.creamColor)
                                .font(.custom("Sunday Morning", size: 24))
                        case .longSleeveShirt:
                            Text("Long-Sleeve Shirt")
                                .foregroundColor(ClothingSubmissionSwiftUIView.creamColor)
                                .font(.custom("Sunday Morning", size: 24))
                        case .pants:
                            Text("Pants")
                                .foregroundColor(ClothingSubmissionSwiftUIView.creamColor)
                                .font(.custom("Sunday Morning", size: 24))
                        case .shorts:
                            Text("Shorts")
                                .foregroundColor(ClothingSubmissionSwiftUIView.creamColor)
                                .font(.custom("Sunday Morning", size: 24))
                        case .skirt:
                            Text("Skirt")
                                .foregroundColor(ClothingSubmissionSwiftUIView.creamColor)
                                .font(.custom("Sunday Morning", size: 24))
                        } // switch
                    } // ForEach
                } // Picker
                .shadow(radius: 5)
                .padding(.top, -30)
                Spacer()
                
            } // whatever ends here
            .background(FitFinderColors.blueColor.color.ignoresSafeArea(.all))
            .sheet(isPresented: self.$isImagePickerDisplay) {
                ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType)
            } // sheet
            .padding(.top, -100)
        } // NavigationView (entire page)
        .navigationBarItems(trailing: Button("Save") {
            addArticleOfClothing()
            self.mode.wrappedValue.dismiss()
        }) // navigationBarItema
        .onAppear { checkForExistingArticleOfClothing() }
    }
    
    
    
    // function to add an article of clothing
    func addArticleOfClothing() {
        if existingArticleOfClothing != nil {

            if pickedFormality == 0 {
                existingArticleOfClothing!.rawFormality = Formality.casual.rawValue
            } else {
                existingArticleOfClothing!.rawFormality = Formality.formal.rawValue
            }
            
            let rgb1 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 95, y: 95))
            let rgb2 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 105, y: 95))
            let rgb3 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 100, y: 100))
//            let rgb4 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 70, y: 110))
//            let rgb5 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 70, y: 100))
//            let rgb6 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 70, y: 90))
//            let rgb7 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 140))
//            let rgb8 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 130))
//            let rgb9 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 120))
//            let rgb10 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 110))
//            let rgb11 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 100))
//            let rgb12 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 90))
            
            let rred = (rgb1.red + rgb2.red + rgb3.red) / 3
            let rgreen = (rgb1.green + rgb2.green + rgb3.green) / 3
            let rblue = (rgb1.blue + rgb2.blue + rgb3.blue) / 3
            let rgb = (red: rred, green: rgreen, blue:rblue)
            
            existingArticleOfClothing!.red = Int16(rgb.red)
            existingArticleOfClothing!.green = Int16(rgb.green)
            existingArticleOfClothing!.blue = Int16(rgb.blue)
            
            if selectedTemperature == 0 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.veryCold.rawValue
            } else if selectedTemperature == 1 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.cold.rawValue
            } else if selectedTemperature == 2 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.mild.rawValue
            } else if selectedTemperature == 3 {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.hot.rawValue
            } else {
                existingArticleOfClothing!.rawAppropriateTemperature = Temperature.veryHot.rawValue
            }

            existingArticleOfClothing!.rawTypeOfClothing = typesOfClothing[selectedTypeOfClothing].rawValue
            existingArticleOfClothing!.image = selectedImage
            
            do {
                try existingArticleOfClothing!.managedObjectContext?.save()
            } catch {
                print(error)
            }
        
        } else {
            let newArticleOfClothing = ArticleOfClothing(context: viewContext)

            if pickedFormality == 0 {
                newArticleOfClothing.rawFormality = Formality.casual.rawValue
            } else {
                newArticleOfClothing.rawFormality = Formality.formal.rawValue
            }
            
            let rgb1 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 95, y: 95))
            let rgb2 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 105, y: 95))
            let rgb3 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 100, y: 100))
//            let rgb4 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 70, y: 110))
//            let rgb5 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 70, y: 100))
//            let rgb6 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 70, y: 90))
//            let rgb7 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 140))
//            let rgb8 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 130))
//            let rgb9 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 120))
//            let rgb10 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 110))
//            let rgb11 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 100))
//            let rgb12 = getPixelColor(image: selectedImage!, pos: CGPoint(x: 130, y: 90))
//
            let rred = (rgb1.red + rgb2.red + rgb3.red) / 3
            let rgreen = (rgb1.green + rgb2.green + rgb3.green) / 3
            let rblue = (rgb1.blue + rgb2.blue + rgb3.blue) / 3
            let rgb = (red: rred, green: rgreen, blue:rblue)
            
            
            newArticleOfClothing.red = Int16(rgb.red)
            newArticleOfClothing.green = Int16(rgb.green)
            newArticleOfClothing.blue = Int16(rgb.blue)
            
            if selectedTemperature == 0 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.veryCold.rawValue
            } else if selectedTemperature == 1 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.cold.rawValue
            } else if selectedTemperature == 2 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.mild.rawValue
            } else if selectedTemperature == 3 {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.hot.rawValue
            } else {
                newArticleOfClothing.rawAppropriateTemperature = Temperature.veryHot.rawValue
            }
            
            newArticleOfClothing.rawTypeOfClothing = typesOfClothing[selectedTypeOfClothing].rawValue
            newArticleOfClothing.image = selectedImage
            newArticleOfClothing.picked = 0
            do {
                try viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    
    
    // function to check for existing article of clothing
    func checkForExistingArticleOfClothing() {
        if existingArticleOfClothing != nil {
            if existingArticleOfClothing!.appropriateTemperature == Temperature.veryCold {
                selectedTemperature = 0
            } else if existingArticleOfClothing!.appropriateTemperature == Temperature.cold {
                selectedTemperature = 1
            } else if existingArticleOfClothing!.appropriateTemperature == Temperature.mild{
                selectedTemperature = 2
            } else if existingArticleOfClothing!.appropriateTemperature == Temperature.hot {
                selectedTemperature = 3
            } else {
                selectedTemperature = 4
            }
            selectedImage = existingArticleOfClothing!.image
            switch existingArticleOfClothing!.formality {
            case .casual:
                pickedFormality = 0
            case .formal:
                pickedFormality = 1
            }
            
            switch existingArticleOfClothing!.typeOfClothing {
            case .shirt:
                selectedTypeOfClothing = 0
            case .longSleeveShirt:
                selectedTypeOfClothing = 1
            case .pants:
                selectedTypeOfClothing = 2
            case .shorts:
                selectedTypeOfClothing = 3
            case .skirt:
                selectedTypeOfClothing = 4
            }

        }
    }
    
    
    
    // function to resize image
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
//    self.resizeImage(UIImage(named: "Image")!, targetSize: CGSizeMake(200.0, 200.0))

    
    
    // function to get pixel color
    func getPixelColor(image: UIImage, pos: CGPoint) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 250.0, height: 250.0))
        
        let pixelData = (resizedImage.cgImage!).dataProvider!.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        let pixelInfo: Int = ((Int(resizedImage.size.width) * Int(pos.y)) + Int(pos.x)) * 4

        let r = CGFloat(data[pixelInfo + 2])
        let g = CGFloat(data[pixelInfo + 1])
        let b = CGFloat(data[pixelInfo])

        return (r, g, b)
    }
}



struct ClothingSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        ClothingSubmissionSwiftUIView()
    }
}
