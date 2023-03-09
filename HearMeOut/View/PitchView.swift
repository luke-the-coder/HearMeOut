//
//  PitchView.swift
//  MC3
//
//  Created by Marta Michelle Caliendo on 28/02/23.
//

import SwiftUI

struct PitchView: View {
    let notes: [NoteScore]
    @State private var accessibilityString: String = ""
    var body: some View {
        VStack(spacing: 10){
            //tutte le note che compongono il gruppo di note nella voce
            ForEach(notes) { note in
                if note.pitch.step != .none {
                    HStack { 
                        Text(LocalizedStringKey(note.pitch.step.rawValue))
                            .fixedSize(horizontal: false, vertical: true)
                        VStack {
                            Text(note.pitch.alter == 1 ? "#" : note.pitch.alter == -1 ? "b" : "")
                                .font(.caption)
                            Text("\(note.pitch.octave)")
                                .font(.caption)
                        }
                    }
                }
            }
        }
        .onAppear {
            print("PitchView \(notes)")
            createString()
        }
        .accessibilityChildren {
            Text(accessibilityString)
        }
    }
    
    func createString(){
        
        if notes.count > 1 {
            accessibilityString = "Chord,"
        }
        
        for note in notes {
            accessibilityString += "\(note.isRest ? "rest" : note.pitch.step.rawValue) \(note.pitch.octave)"
                if note.pitch.alter == 1 {
                    accessibilityString += "sharp"
                } else if note.pitch.alter == -1 {
                    accessibilityString += "flet"
                }
                
                accessibilityString += ","
            
            
        }
        
        if notes.count > 1 {
            accessibilityString += "end chord"
        }
        
        
    }
}

struct PitchView_Previews: PreviewProvider {
    static var previews: some View {
        PitchView(notes: [])
    }
}
