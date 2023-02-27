//
//  ScoreModel.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 20/01/23.
//

import Foundation

//starting
struct ScoreModel2: Codable {
//    let movementTitle: String
    //let identification: Identification
    //let defaults: Defaults
    //let partList: PartList
    let part: Part?
    let version: String?
    
}


// MARK: - Part
struct Part: Codable {
    let measure: [Measure]?
    let id: String?
}

// MARK: - Measure
struct Measure: Codable {
    //let print: Print
    let attributes: Attributes?
    let sound: Sound?
    //let direction: [Direction]
    let note: [Note]
    //let barline: Barline
    let number, width: String?
    let backup: BackupUnion?
    let forward: BackupElement?
    
    init(attributes: Attributes?, sound: Sound?, note: [Note], number: String?, width: String?, backup: BackupUnion?, forward: BackupElement?) {
        self.attributes = attributes
        self.sound = sound
        self.note = note
        self.number = number
        self.width = width
        self.backup = backup
        self.forward = forward
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.attributes = try container.decodeIfPresent(Attributes.self, forKey: .attributes)
        self.sound = try container.decodeIfPresent(Sound.self, forKey: .sound)
        self.note = try container.decode([Note].self, forKey: .note)
        self.number = try container.decodeIfPresent(String.self, forKey: .number)
        self.width = try container.decodeIfPresent(String.self, forKey: .width)
        self.backup = try container.decodeIfPresent(BackupUnion.self, forKey: .backup)
        self.forward = try container.decodeIfPresent(BackupElement.self, forKey: .forward)
        if let forward {
            print("forward found: \(forward)")
        }
        if let backup {
            print("backup found: \(backup)")
        }
    }
    
    
    
}


// MARK: - Attributes
struct Attributes: Codable {
    let divisions: String?
    let key: Key?
    let time: Time?
    let clef: [Clef]?
}

// MARK: - Clef
struct Clef: Codable, Identifiable {
    let id: UUID
    let sign: ClefSign?
    let line: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.sign = try container.decodeIfPresent(ClefSign.self, forKey: .sign)
        self.line = try container.decodeIfPresent(String.self, forKey: .line)
        self.id = UUID()
    }
}

enum ClefSign: String, Codable {
    case G, F, C, percussion, TAB, jianpu, none
}

// MARK: - Key
struct Key: Codable {
    let fifths, mode: String?
    
    var fifthsToInt: Int {
        guard let fifths else { return 0 }
        return Int(fifths) ?? 0
    }
    
    var modeToScaleType: ScaleModel {
        guard let mode else { return .major }
        return ScaleModel(rawValue: mode) ?? .major
    }
}

// MARK: - Note
struct Note: Codable {
    let id: UUID
    let pitch: Pitch?
    private let duration, voice: String?
    let type: NoteType?
    let notations: Notations?
                        //let stem: Stem
                    //let lyric: Lyric?
    let chord: String?
    let staff: String?
    let defaultX: String?
    
    var durationToDouble: Double {
        return 0.0
    }
    
    var voiceToInt: Int {
        guard let voice else { return 1}
        return Int(voice) ?? 1
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.pitch = try container.decodeIfPresent(Pitch.self, forKey: .pitch)
        self.duration = try container.decodeIfPresent(String.self, forKey: .duration)
        self.voice = try container.decodeIfPresent(String.self, forKey: .voice)
        self.type = try container.decodeIfPresent(NoteType.self, forKey: .type)
        self.chord = try container.decodeIfPresent(String.self, forKey: .chord)
        self.staff = try container.decodeIfPresent(String.self, forKey: .staff)
        self.defaultX = try container.decodeIfPresent(String.self, forKey: .defaultX)
        self.notations = try container.decodeIfPresent(Notations.self, forKey: .notations)
        self.id = UUID()
    }
}

// MARK: - Pitch
struct Pitch: Codable {
    let step: Step?
    private let octave: String?
    
    var octaveToInt: Int {
        guard let octave else { return 0 }
        return Int(octave) ?? 0
    }
}

enum Step: String, Codable {
    case A, B, C, D, E, F, G, Af, As, Bf, Bs, Cf, Cs, Df, Ds, Ef, Es, Ff, Fs, Gf, Gs, none
}

enum NoteType: String, Codable {
    case maxima, long, breve, whole, half, quarter, eighth, the16Th = "16th", the32Nd = "32nd"
}

// MARK: - Sound
struct Sound: Codable {
    let tempo: String?
}

struct Time: Codable {
    let senzaMisura, beats, beatType: String?
    
    enum CodingKeys: String, CodingKey {
        case senzaMisura, beats
        case beatType = "beat-type"
    }
    
    var beatsToInt: Int {
        guard let beats else { return 0 }
        return Int(beats) ?? 0
    }
    
    var beatTypeToInt: Int {
        guard let beatType else { return 0 }
        return Int(beatType) ?? 0
    }
}

// MARK: - Notation
struct Notations: Codable {
    let arpeggiate: Arpeggiate?
    //let slur: Slur?
    let articulations: Articulations?
}

// MARK: - Arpeggiate
struct Arpeggiate: Codable {
    let defaultX, number: String?
}

// MARK: - Articulations
struct Articulations: Codable {
    let staccato: Staccato?
}

// MARK: - Staccato
struct Staccato: Codable {
    let defaultX, defaultY: String?
    let placement: Placement?
}

// MARK: - Placement
enum Placement: String, Codable {
    case above
    case below
}

// MARK: - Slur
//struct Slur: Codable {
//    let bezierX, bezierY, defaultX, defaultY: String
//    let number: String
//    let placement: Placement?
//    let type: TypeEnum
//    let orientation: String?
//}

// MARK: - BackupElement
struct BackupElement: Codable {
    let duration: String?
    let voice: String?
}

// MARK: - BackupUnion
//enum BackupUnion: Codable {
//    case backupElement(BackupElement)
//    case backupElementArray([BackupElement])
//}
struct BackupUnion: Codable {
    let duration: String?
}
