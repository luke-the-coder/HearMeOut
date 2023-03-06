//
//  SettingsView.swift
//  MC3
//
//  Created by Marta Michelle Caliendo on 24/02/23.
//

import SwiftUI


struct SettingsView: View {
    @ObservedObject var scoreViewModel: ScoreViewModel
    @State private var done: Bool = false
//    @State private var toggleDictionary: [String: Bool] = ["Staff 1": false, "Staff 2": false, "Staff 3": false]
    @State private var selectedIndex: String? = nil
    private var pickerArray2 = ["4/4", "3/4", "2/4", "1/4"]
    @State private var selectedIndex2: String
    
    @State private var showView = true
    @State var count: Int
    @StateObject var vm2 = Metronome()
    
    @Environment (\.dismiss) private var dismiss
    let countMin: Int = 40
    let countMax: Int = 120
    
    init(scoreViewModel: ScoreViewModel) {
        self.scoreViewModel = scoreViewModel
        self._count = State(initialValue: countMin)
        self._selectedIndex2 = State(initialValue: pickerArray2[0])
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Reading by") {
                    ForEach(DivisionRead.allCases, id: \.rawValue) { division in
                        DivisionView(currentSelection: $scoreViewModel.divisionRead, division: division)
//                            .contentShape(Rectangle())c
//                            .onTapGesture {
//                                scoreViewModel.divisionRead = division
//                            }
                    }
                }
                
                Section("Reproduce by") {
                    ForEach(DivisionPlay.allCases, id: \.rawValue) { division in
                        DivisionView(currentSelection: $scoreViewModel.divisionPlay, division: division)
//                            .contentShape(Rectangle())
//                            .onTapGesture {
//                                scoreViewModel.divisionPlay = division
//                            }
                    }
                }
                
                Section("Select staff")
                {
                    ForEach($scoreViewModel.staffDictionary) { $staf in
                        Toggle(staf.name, isOn: $staf.isActive)
                    }
                    
                }
                
                Section {
                    VStack {
                        Toggle("Metronomo", isOn: $showView)
                            .onChange(of: showView) { newValue in
                                vm2.enabled.toggle()
                            }
                        
                        if showView {
                            VStack {
                                HStack {
                                    Text("BPM")
                                        .padding(.trailing, 30)
                                    Button {
                                        if count > countMin {
                                            count -= 1
                                        }
                                        
                                    } label: {
                                        RoundedRectangle(cornerRadius: 2)
                                            .frame(width: 60)
                                            .foregroundColor(.white)
                                            .shadow(radius: 5)
                                            .overlay {
                                                Text("-")
                                            }
                                    }
                                    .buttonStyle(.plain)
                                    RoundedRectangle(cornerRadius: 2)
                                        .foregroundColor(Color.gray)
                                        .frame(width: 100)
                                        .overlay {
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
                                        RoundedRectangle(cornerRadius: 2)
                                            .frame(width: 60)
                                            .foregroundColor(.white)
                                            .shadow(radius: 5)
                                            .overlay {
                                                Text("+")
                                            }
                                    }
                                    .buttonStyle(.plain)
                                    
                                }
                                VStack {
                                    Picker("Beat", selection: $selectedIndex2) {
                                        ForEach(pickerArray2, id: \.self) {
                                            Text($0)
                                                .id($0)
                                        }
                                    }
                                }.padding(.top, 10)
                            } .padding(.top, 15)
                        }
                    }
                }
                //.listRowInsets(.init())
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        done.toggle()
                        dismiss()
                        
                    } label: {
                        Text("Done")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        done.toggle()
                        dismiss()
                        
                    } label: {
                        Text("Cancel")
                        
                    }
                }
            }
        }
        .interactiveDismissDisabled()
        
    }
    
//    private var allKeys: [String] {
//        return scoreViewModel.staffDictionary.keys.sorted().map { String($0)
//        }
//    }
//
//
//    private func binding(for key: String) -> Binding<Bool> {
//        return Binding(get: {
//            return scoreViewModel.staffDictionary[key] ?? false
//        }, set: {
//            scoreViewModel.staffDictionary[key] = $0
//        })
//    }
}




struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView(scoreViewModel: ScoreViewModel(url: Bundle.main.url(forResource: "Chant" , withExtension: "musicxml")!))
        }
        
    }
}



