//
//  ScoreView.swift
//  ReaderMusic
//
//  Created by Marta Michelle Caliendo on 23/02/23.
//

import SwiftUI

enum FocusModel: Hashable {
    case clef(id: Int)
    case beat(id: Int)
    case note(id: Int)
}

struct ScoreView: View {
    @State var isNavigated: Bool = false
    @State var isActive: Bool = false
    @StateObject private var vm: ScoreViewModel
    @State private var clef: [ClefScore] = []
    @State private var beatType: BeatType = .none
    @State private var focusArray: [FocusModel] = [FocusModel.note(id: 0), FocusModel.note(id: 1)]
    @AccessibilityFocusState var focus: FocusModel?
    let scoreData : Score
    
    init(url: URL) {
        self._vm = StateObject(wrappedValue: ScoreViewModel(url: url))
        self.scoreData = ScoreStore().retrieveScore(path: url)
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        VStack{
            contentLayer
                .padding(.bottom, 40)
            Spacer()
            HStack(spacing: 180) {
                Button {
                    isActive.toggle()
                } label: {
                    Text("Voice")
                        .foregroundColor(.black)
                        .background(
                    Capsule()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: 110, height: 50))

                }
                Button {
                    isActive.toggle()
                } label: {
                    Text("Sound")
                        .foregroundColor(.black)
                        .background(
                    Capsule()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: 110, height: 50))

                }
            }
            ZStack {
                Capsule()
                    .foregroundColor(Color("Backgroundcolor2"))
                    .frame(width: 400, height: 130)
                    .padding()
                HStack(spacing: 30) {
                    Button {
                        vm.goPrevious()
                    } label: {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .overlay {
                                Text("Previews")
                                    .foregroundColor(.black)
                            }
                    }
                    Button {
                        
                    } label: {
                        Circle()
                            .frame(width: 80)
                            .foregroundColor(.white)
                            .overlay {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.black)

                            }
                    }

                    Button {
                        vm.goNext()
                    } label: {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .overlay {
                                Text("Next")
                                    .foregroundColor(.black)
                            }
                    }


                }

            }
    
        
//    Spacer()
        }
        .navigationTitle(scoreData.movementTitle ?? "Musical Score")
        .toolbar {
            Button {
                isNavigated.toggle()
            } label: {
                Text("Settings")
            }

        }
        .sheet(isPresented: $isNavigated) {
           SettingsView()
        }
        .onChange(of: vm.measureIndex) { measure in
            if let score = vm.musicScore {
                for _ in  score.part.measure[vm.measureIndex].staffGroup {
                    if !score.part.measure[vm.measureIndex].attributes.clef.isEmpty {
                        clef = score.part.measure[vm.measureIndex].attributes.clef
                    }
                    if score.part.measure[vm.measureIndex].attributes.time.beatType != .none {
                        beatType = score.part.measure[vm.measureIndex].attributes.time.beatType
                    }
                }
            }
        }
        .onAppear {
            if let score = vm.musicScore {
                for _ in  score.part.measure[vm.measureIndex].staffGroup {
                    if !score.part.measure[vm.measureIndex].attributes.clef.isEmpty {
                        clef = score.part.measure[vm.measureIndex].attributes.clef
                    }
                    if score.part.measure[vm.measureIndex].attributes.time.beatType != .none {
                        beatType = score.part.measure[vm.measureIndex].attributes.time.beatType
                    }
                }
            }
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                focus = focusArray[0]
//            }
        }
    }
    
    @ViewBuilder
    var contentLayer: some View {
        if let score = vm.musicScore {
            
            //qui prende ogni pentagramma per la battuta nell'indice
            ForEach(Array(score.part.measure[vm.measureIndex].staffGroup.enumerated()), id: \.offset) { index, staff in
                HStack {
                    
                    if !clef.isEmpty {
                        Image(clef[index].sign.rawValue)
                            .resizable()
                            .frame(width: 50, height: 80)
//                            .accessibilityFocused($focus, equals: focusArray[0])
                            .accessibility(sortPriority: 2)
             
                    }
                    
                    if beatType != .none {
                        beatTypeView(beatType)
                            
                            .accessibility(sortPriority: 1)
                    }
   
                    //di ogni pentagramma
                    VStack(alignment: .leading, spacing: 10) {
                        //cicla per tutte le voci (gruppi) e crea le note/accordi
                        ForEach(staff.group) { group in
                            HStack(spacing: 20) {
                                ForEach(group.note, id: \.self) { notes in
                                    
                                    PitchView(notes: notes)
                                        .accessibility(sortPriority: 0)
                                    
                                }
                            }
                            //                        .accessibilityElement(children: .combine)
                        }
                    }
                }
                .accessibilityElement(children: .contain)
                .frame(maxWidth: .infinity, alignment: .leading)
                .frame(height: 150)
                .background(.gray.opacity(0.6))
                .cornerRadius(5)
//                .shadow(color: .gray , radius: 10, y: 10)
                .padding(.horizontal)
            }
        }
    }
    
    @ViewBuilder
    func beatTypeView(_ beatType: BeatType) -> some View {
        let fullString = beatType.rawValue.components(separatedBy: "/")
        let numerator = fullString[0]
        let denominator = fullString[1]
        VStack(spacing: 1.5) {
            Text(numerator)
                .font(.title2)
            Rectangle()
                .frame(width: 20, height: 1.5)
            Text(denominator)
                .font(.title2)
        }
        .accessibilityElement(children: .combine)
        .accessibility(label: Text(beatType.description))
        .padding(.trailing)
    }
    
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScoreView(url: Bundle.main.url(forResource: "MozartPianoSonata" , withExtension: "musicxml")!)
        }
    }
}

struct MyContent: View {
    let title: String
    let image: String
    let notes: String
    var body: some View {
        VStack{
            Text(title)
                .font(.title2)
                .padding(.trailing, 300)
            HStack {
                Image(image)
                    .accessibilityRemoveTraits(.isImage)
                    .padding(.trailing, 5)
                Text(notes)
                    .font(.title)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("Backgroundcolor"))
                    .frame(width: 380, height: 100))
                    .padding(.bottom, 20)
        }
    }
}
