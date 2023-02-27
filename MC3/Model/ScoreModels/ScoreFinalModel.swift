//
//  ScoreFinalModel.swift
//  MC3
//
//  Created by Nicola Rigoni on 26/02/23.
//

import Foundation

struct ScoreFinalModel {
    let version: Int
    let work: String
    let measure: [MeasureFinal]
}

struct MeasureFinal {
    let id: Int
    let voice: [NoteGroup]
    let time: Time
    let key: Key
    let clef: Clef
}

struct NoteGroup {
    let note: [NoteFinal]
    let duration: Double
    let timestamp: Double
}

struct NoteFinal {
    let pitch: Pitch
    let type: NoteType
}
