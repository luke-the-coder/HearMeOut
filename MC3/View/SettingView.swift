//
//  SettingsView.swift
//  MC3
//
//  Created by Marta Michelle Caliendo on 24/02/23.
//
import SwiftUI

struct SettingsView: View {
    @State private var done: Bool = false
    private var pickerArray = ["Staff 1", "Staff 2", "Staff 3"]
    @State private var selectedIndex = ""
    private var pickerArray2 = ["4/4", "3/4", "2/4", "1/4"]
    @State private var selectedIndex2 = ""
    @State var currentSelection: Division = .all
    @State private var showView = true
    @State var count: Int16
    @Environment (\.dismiss) private var dismiss
    let countMin: Int16 = 40
    let countMax: Int16 = 120
    
    @StateObject private var viewModel = ScoreStore()
    let score: Score
    init(score : Score) {
        self.score = score
        self._count = State(initialValue: countMin)
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Reading by") {
                    ForEach(Division.allCases, id: \.rawValue) { division in
                        Content(currentSelection: currentSelection, division: division).onTapGesture {
                                currentSelection = division
                        }
                    }
                }
                Section{
                    VStack {
                        Picker("Choose a staff", selection: $selectedIndex) {
                            ForEach(pickerArray, id: \.self) {
                                Text($0).id($0)
                            }
                        }
                    }
                }
                Section("Metronomo") {
                    VStack {
                        Toggle("Metronomo", isOn: $showView)
                        if showView {
                            VStack {
                                HStack {
                                    Text("BPM").padding(.trailing, 30)
                                    Button {
                                        if count > countMin {
                                            count -= 1
                                        }
                                    } label: {
                                        RoundedRectangle(cornerRadius: 2).frame(width: 60).foregroundColor(.white).shadow(radius: 5).overlay {
                                                Text("-")
                                            }
                                    }.buttonStyle(.plain)
                                    RoundedRectangle(cornerRadius: 2).foregroundColor(Color.gray).frame(width: 100).overlay {
                                            Text("\(count)")
                                                .foregroundColor(.white)
                                        }
                                    Button {
                                        if  count < countMax {
                                            count += 1
                                        } else {
                                            return
                                        }
                                    } label: {
                                        RoundedRectangle(cornerRadius: 2).frame(width: 60).foregroundColor(.white).shadow(radius: 5).overlay {
                                                Text("+")
                                            }
                                    }.buttonStyle(.plain)
                                }
                                VStack {
                                    Picker("Choose a tempo", selection: $selectedIndex2) {
                                        ForEach(pickerArray2, id: \.self) {
                                            Text($0).id($0)
                                        }
                                    }
                                }.padding(.top, 20)
                            } .padding(.top, 20)
                        }
                    }
                }
            } .navigationTitle("Settings")
                .toolbar {
                    Button {
                        done.toggle()
                        viewModel.updateScore(score: score, bpm: count, hasMetronome: showView, staff: selectedIndex, tempo: selectedIndex2)
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
        }
    }
}

enum Division: String, CaseIterable {
    case bar = "Bar"
    case line = "Line"
    case all = "All"
}


//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            SettingsView()
//        }
//
//    }
//}


struct Content: View {
    let currentSelection: Division
    let division: Division
    var body: some View {
        HStack {
            Text(division.rawValue)
            Spacer()
            Image(systemName: "checkmark")
                .opacity(division == currentSelection ? 1.0 : 0.0)
            
        }
    }
    
}
