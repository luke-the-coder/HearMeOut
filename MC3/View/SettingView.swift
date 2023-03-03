//
//  SettingsView.swift
//  MC3
//
//  Created by Marta Michelle Caliendo on 24/02/23.
//

import SwiftUI


struct SettingsView: View {
    @State private var done: Bool = false
    @State private var toggleDictionary: [String: Bool] = ["Staff 1": false, "Staff 2": false, "Staff 3": false]
    @State private var selectedIndex = ""
    private var pickerArray2 = ["4/4", "3/4", "2/4", "1/4"]
    @State private var selectedIndex2 = ""
    @State var currentSelection: Division = .all
    @State private var showView = true
    @State var count: Int
    @StateObject var vm2 = Metronome()
    
    @Environment (\.dismiss) private var dismiss
    let countMin: Int = 40
    let countMax: Int = 120
    
    init() {
        self._count = State(initialValue: countMin)
        
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section("Reading by") {
                    ForEach(Division.allCases, id: \.rawValue) { division in
                        Content(currentSelection: currentSelection, division: division)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                currentSelection = division
                            }
                    }
                }
                Section("Select staff")
                {
                    ForEach(allKeys, id: \.self) { key in
                        Toggle(key, isOn: binding(for: key))
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
        
    }
    
    private var allKeys: [String] {
        return toggleDictionary.keys.sorted().map { String($0)
        }
    }
    
    
    private func binding(for key: String) -> Binding<Bool> {
        return Binding(get: {
            return self.toggleDictionary[key] ?? false
        }, set: {
            self.toggleDictionary[key] = $0
        })
    }
}

enum Division: String, CaseIterable {
    case bar = "Bar"
    case line = "Line"
    case all = "All"
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        //        Content(currentSelection: .all, division: .all)
        NavigationStack {
            SettingsView()
        }
        
    }
}


struct Content: View {
    let currentSelection: Division
    let division: Division
    var body: some View {
        HStack {
            Text(LocalizedStringKey(division.rawValue))
            Spacer()
//            Text(division.rawValue).accessibilityLabel("\(division.rawValue) \(division == currentSelection ? "is on" : "is off")")
            Spacer()
            Image(systemName: "checkmark")
                .opacity(division == currentSelection ? 1.0 : 0.0)
                .accessibilityHidden(true)
                
        }
    }
    
}
