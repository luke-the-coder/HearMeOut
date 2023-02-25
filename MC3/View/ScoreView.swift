//
//  ScoreView.swift
//  MC3
//
//  Created by luke-the-coder on 24/02/23.
//

import SwiftUI

struct ScoreView: View {
    let musicSheet: Score
    let score: ScoreModel
    
    init(musicSheet: Score) throws {
        self.musicSheet = musicSheet
        self.score = try MusicXMLDecoder.decode(type: ScoreModel.self, from: musicSheet.path!)
    }
    
    var body: some View {
        List {
            ForEach(score.part?.measure ?? []) { measure in
                ForEach(measure.note ?? []) { note in
                    Text("\(note.pitch?.step ?? "")\(note.pitch?.octave ?? "")")
                }
            }
        }
    }
}



//struct ScoreView_Previews: PreviewProvider {
//    static var previews: some View {
//        ScoreView()
//    }
//}
