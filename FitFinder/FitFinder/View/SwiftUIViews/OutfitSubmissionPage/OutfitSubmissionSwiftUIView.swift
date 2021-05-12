//
//  OutfitSubmissionSwiftUIView.swift
//  FitFinder
//
//  Created by Noah Frew on 2/15/21.
//

import SwiftUI
import CoreData

struct OutfitSubmissionSwiftUIView: View {
    
    // initializing custom colors
    private static let yellowColor = Color(red: 221/255, green: 184/255, blue: 106/255)
    private static let peachColor = Color(red: 228/255, green: 169/255, blue: 135/255)
    private static let blueColor = Color(red: 155/255, green: 174/255, blue: 191/255)
    private static let creamColor = Color(red: 233/255, green: 215/255, blue: 195/255)
    
    // set weather to -99 by default
    let e = Weathers(t:-99)
    
    @State private var matchedTops = [ArticleOfClothing]()
    @State private var matchedBottoms = [ArticleOfClothing]()

    @FetchRequest(entity: ArticleOfClothing.entity(), sortDescriptors: []) var articlesOfClothing: FetchedResults<ArticleOfClothing>
    @Environment(\.managedObjectContext) private var viewContext
    
    // initialize
    @State private var showingAlert = false
    @State private var selectedFormality: Formality = .casual
    @State private var state: MatchingState = .unmatched
    
    
    
    // view
    var body: some View {
        HStack {
            // for spacing
            Spacer()
            VStack {
                if state == .matched {
                    // title saying today's picks
                    HStack {
                        Spacer()
                        Text("Today's Picks for \(String(Int(e.getTemp())))º")
                            .font(.custom("Sunday Morning", size: 38))
                            .fontWeight(.bold)
                            .font(.largeTitle)
                            .foregroundColor(OutfitSubmissionSwiftUIView.creamColor)
                            .padding(.top, 50)
                        Spacer()
                    } // HStack
//                    .padding(8)
                    
                    // title saying the weather- might need this ScrollView back
                    //ScrollView(.vertical, showsIndicators: false) {
                        HStack {
                            Text("Now the weather is \(e.getWeatherCode())!")
                                .font(.custom("Sunday Morning", size: 30))
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundColor(OutfitSubmissionSwiftUIView.creamColor)
                        } // HStack
//                        .padding(3)
                        // can go out of bounds if not enough data
                        ForEach(0..<matchedTops.count) { index in
                            MatchedOutfitSwiftUIView(numberPicked: index, matchedTops[index], matchedBottoms[index]) // matchedTops[0], matchedBottoms[0]
                        } // ForEach
                    //} // ScrollView
                } // if
                Spacer()
            } // VStack
//            .padding(.top, -40)
            .background(OutfitSubmissionSwiftUIView.blueColor.ignoresSafeArea(.all))
            .onAppear {
                if checkNewDay() {
                    showingAlert = true
                } else {
                    showingAlert = false
                    createOutfits()
                    state = .matched
                }
            } // onAppear
            // alert for the user
            .alert(isPresented: $showingAlert) { () -> Alert in
                let firstButton = Alert.Button.default(Text("Casual")) {
                    selectedFormality = .casual
                    createOutfits()
                    state = .matched
                }
                let secondButton = Alert.Button.default(Text("Formal")) {
                    selectedFormality = .formal
                    createOutfits()
                    state = .matched
                }
                return Alert(title: Text("What kind of outfits are you looking for?"), primaryButton: firstButton, secondaryButton: secondButton)
            } // alert
            Spacer()
            
// when I was merging I didn't know what to do with this section- I don't remember deleting the alert but maybe I did, if so add this back in
//        } // HStack (entire age)
//    } // end view
    
// and delete from here
        } // HStack
        .padding(.top, -40)
        .onAppear {
            showingAlert = true
        } // onAppear
        .alert(isPresented: $showingAlert) { () -> Alert in
            let firstButton = Alert.Button.default(Text("Casual")) {
                selectedFormality = .casual
                createOutfits()
            } // let
            let secondButton = Alert.Button.default(Text("Formal")) {
                selectedFormality = .formal
                createOutfits()
            } // let
            return Alert(title: Text("What kind of outfits are you looking for?"), primaryButton: firstButton, secondaryButton: secondButton)
        } // alert
        .background(FitFinderColors.blueColor.color.ignoresSafeArea(.all))
    } // end view
// to here
    
    // function to createOutfits
    func createOutfits() {
        
        if checkNewDay() {
            var matchedOutfits: Int16 = 1
            var consideredClothes = ([ArticleOfClothing](), [ArticleOfClothing]())
            var consideredTops = [ArticleOfClothing]()
            var consideredBottoms =  [ArticleOfClothing]()
            
            consideredClothes = getConsideredClothing()
            consideredTops = consideredClothes.0
            consideredBottoms = consideredClothes.1
            
            // Matching Colors
            for _ in 0..<5 {
                guard matchedTops.count < 5 && !consideredTops.isEmpty && !consideredBottoms.isEmpty else {
                    break
                }
                // grab random top
                let randomIndex = Int.random(in: 0..<consideredTops.count)
                matchedTops.insert(consideredTops[randomIndex], at: Int(matchedOutfits - 1))
                matchedTops[Int(matchedOutfits - 1)].picked = matchedOutfits
                
                let matchedIndex = matchComplementaryColors(inputColor: consideredTops[randomIndex].color, consideredBottoms: consideredBottoms) // get the index for the matched bottom
                matchedBottoms.insert(consideredBottoms[matchedIndex], at: Int(matchedOutfits - 1)) // insert the matched bottom using the array
                matchedBottoms[Int(matchedOutfits - 1)].picked = matchedOutfits
                consideredTops.remove(at: randomIndex)
                consideredBottoms.remove(at: matchedIndex) // remove, no repeats
                matchedOutfits += 1
            }
            
            for top in matchedTops {
                do {
                    try top.managedObjectContext?.save()
                } catch {
                    print(error)
                }
            }
            
            for bottom in matchedBottoms {
                do {
                    try bottom.managedObjectContext?.save()
                } catch {
                    print(error)
                }
            }
            
            state = .matched
        } else {
            let sortedArticlesOfClothing = articlesOfClothing.sorted { $0.picked < $1.picked }
            for articleOfClothing in sortedArticlesOfClothing {
                if articleOfClothing.picked == 0 {
                    continue
                }
                if articleOfClothing.clothingCategory == "top" {
                    matchedTops.insert(articleOfClothing, at: Int(articleOfClothing.picked - 1))
                } else {
                    matchedBottoms.insert(articleOfClothing, at: Int(articleOfClothing.picked - 1))
                }
            }
            
            state = .matched
        }
    }
    
    
    
    // function to match complementary colors
    func matchComplementaryColors(inputColor: Colors, consideredBottoms: [ArticleOfClothing]) -> Int {
        switch inputColor {
        case .red:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .cyan ||
                    consideredBottoms[i].color == .blue {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .yellow:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .green:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                consideredBottoms[i].color == .gray ||
                consideredBottoms[i].color == .white ||
                consideredBottoms[i].color == .magenta ||
                consideredBottoms[i].color == .blue {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .cyan:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .red ||
                    consideredBottoms[i].color == .gray {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .blue:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .yellow ||
                    consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .magenta:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        case .white:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .red ||
                    consideredBottoms[i].color == .green {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
            
        case .black:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .gray ||
                    consideredBottoms[i].color == .white ||
                    consideredBottoms[i].color == .black {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
            
        case .gray:
            for i in 0..<consideredBottoms.count {
                if consideredBottoms[i].color == .black ||
                    consideredBottoms[i].color == .blue ||
                    consideredBottoms[i].color == .white {
                    return i
                }
            }
            return Int.random(in: 0..<consideredBottoms.count)
        }
    }

    
    
    // function to check new day
    func checkNewDay() -> Bool {
        let defaults = UserDefaults.standard
        let savedDate = defaults.object(forKey: "LastRun") as? Date
        if savedDate == nil {
            defaults.setValue(Date(), forKey: "LastRun")
            return true
        } else if !(Calendar.current.isDateInToday(savedDate!)) {
            defaults.setValue(Date(), forKey: "LastRun")
            return true
        } else {
            return false
        }
    }
    
    func getConsideredClothing() -> (top: [ArticleOfClothing], bottom: [ArticleOfClothing]) {
        var unconsideredClothing = [ArticleOfClothing]()
        var consideredTops = [ArticleOfClothing]()
        var consideredBottoms = [ArticleOfClothing]()
        let temperature = Double(e.getAnalyzeData(option: "AVGTEMP")) ?? 0
        var topCount = 0
        var bottomCount = 0
        var unconsideredCount = 0
        
        for i in 0..<articlesOfClothing.count {
            // set picked back to zero and save
            articlesOfClothing[i].picked = 0
            do {
                try articlesOfClothing[i].managedObjectContext?.save()
            } catch {
                print(error)
            }
        }
        
        for i in 0..<articlesOfClothing.count {
            // check formality then temperature then type of clothing
            if articlesOfClothing[i].formality == selectedFormality {
                if temperature < 32 &&
                    articlesOfClothing[i].appropriateTemperature == .veryCold {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        // add to considered tops, add to top count, and remove the clothing from unconsideredClothing
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: i)
                        bottomCount += 1
                    }
                } else if temperature >= 32 &&
                            temperature < 50 &&
                            articlesOfClothing[i].appropriateTemperature == .cold {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else if temperature >= 50 &&
                            temperature < 65 &&
                            articlesOfClothing[i].appropriateTemperature == .mild {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else if temperature >= 65 &&
                            temperature < 85 &&
                            articlesOfClothing[i].appropriateTemperature == .hot {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else if temperature >= 85 &&
                            articlesOfClothing[i].appropriateTemperature == .veryHot {
                    if articlesOfClothing[i].clothingCategory == "top" {
                        consideredTops.insert(articlesOfClothing[i], at: topCount)
                        topCount += 1
                    } else {
                        consideredBottoms.insert(articlesOfClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                } else {
                    unconsideredClothing.insert(articlesOfClothing[i], at: unconsideredCount)
                    unconsideredCount += 1
                }
            }
        }
        
        if !unconsideredClothing.isEmpty && topCount < 3 {
            for i in 0..<unconsideredCount {
                if unconsideredClothing[i].formality == selectedFormality &&
                    unconsideredClothing[i].clothingCategory == "top" {
                    if temperature < 32 &&
                        unconsideredClothing[i].appropriateTemperature == .cold ||
                        unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    } else if temperature >= 32 &&
                                temperature < 50 &&
                                unconsideredClothing[i].appropriateTemperature == .veryCold ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    } else if temperature >= 50 &&
                                temperature < 65 &&
                                unconsideredClothing[i].appropriateTemperature == .cold ||
                                unconsideredClothing[i].appropriateTemperature == .hot {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                        unconsideredClothing.remove(at: i)
                    } else if temperature >= 65 &&
                                temperature < 85 &&
                                unconsideredClothing[i].appropriateTemperature == .mild ||
                                unconsideredClothing[i].appropriateTemperature == .veryHot {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    } else if temperature >= 85 &&
                                unconsideredClothing[i].appropriateTemperature == .hot ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredTops.insert(unconsideredClothing[i], at: topCount)
                        topCount += 1
                    }
                }
            }
        }
        
        if !unconsideredClothing.isEmpty && bottomCount < 3 {
            for i in 0..<unconsideredCount {
                if unconsideredClothing[i].formality == selectedFormality && unconsideredClothing[i].clothingCategory == "bottom" {
                    if temperature < 32 &&
                        unconsideredClothing[i].appropriateTemperature == .cold ||
                        unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 32 &&
                                temperature < 50 &&
                                unconsideredClothing[i].appropriateTemperature == .veryCold ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 50 &&
                                temperature < 65 &&
                                unconsideredClothing[i].appropriateTemperature == .cold ||
                                unconsideredClothing[i].appropriateTemperature == .hot {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 65 &&
                                temperature < 85 &&
                                unconsideredClothing[i].appropriateTemperature == .mild ||
                                unconsideredClothing[i].appropriateTemperature == .veryHot {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    } else if temperature >= 85 &&
                                unconsideredClothing[i].appropriateTemperature == .hot ||
                                unconsideredClothing[i].appropriateTemperature == .mild {
                        consideredBottoms.insert(unconsideredClothing[i], at: bottomCount)
                        bottomCount += 1
                    }
                }
            }
        }
        
        return (consideredTops, consideredBottoms)
    }

}



struct OutfitSubmissionSwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        OutfitSubmissionSwiftUIView()
    }
}
