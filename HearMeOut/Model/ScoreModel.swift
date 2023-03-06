import Foundation
import XMLCoder

struct MusicXMLDecoder {
    
    static func decode<T: Decodable>(type: T.Type, from url: URL) throws -> T {
        let string = try String(contentsOf: url)
        let data = string.data(using: .utf8)!
        let decoder = XMLDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(type, from: data)
    }
    
}

struct ScoreModel: Codable {
    let version: String?
    let work: Work?
    let part: PartModel?
    let movementTitle: String?
    let identification: Identification?

    enum CodingKeys: String, CodingKey {
        case part = "part"
        case version = "version"
        case work = "work"
        case movementTitle = "movement-title"
        case identification = "identification"
    }
}

struct Work: Codable {
    let workNumber: String?
    let workTitle: String?

    enum CodingKeys: String, CodingKey {
        case workNumber = "work-number"
        case workTitle = "work-title"
    }
}

struct Identification: Codable {
    let creator: String?
    let rights: String?
    let encoding: Encoding?
    
    enum CodingKeys: String, CodingKey {
        case creator = "creator"
        case rights = "rights"
        case encoding = "encoding"
    }
}

struct Encoding: Codable {
    let software: String?
    let encodingDate: String?
    let supports: [Supports]?
    
    enum CodingKeys: String, CodingKey {
        case software = "software"
        case encodingDate = "encoding-date"
        case supports = "supports"
    }
}

struct Supports: Codable {
    let attribute: String?
    let element: String?
    let type: String?
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case attribute = "attribute"
        case element = "element"
        case type = "type"
        case value = "value"
    }
}


struct PartModel: Codable {
    let id: String?
    let measure: [MeasureModel]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case measure = "measure"
    }
}

struct MeasureModel: Codable, Identifiable {
    let id = UUID()
    let number: String?
    let attributes: AttributesModel?
    let note: [NoteModel]?

    enum CodingKeys: String, CodingKey {
        case number = "number"
        case attributes = "attributes"
        case note = "note"
    }
}

struct AttributesModel: Codable {
    let divisions: String?
    let key: KeyModel?
    let time: TimeModel?
    let clef: ClefModel?

    enum CodingKeys: String, CodingKey {
        case divisions = "divisions"
        case key = "key"
        case time = "time"
        case clef = "clef"
    }
}

struct KeyModel: Codable {
    let fifths: String?
    let mode: String?

    enum CodingKeys: String, CodingKey {
        case fifths = "fifths"
        case mode = "mode"
    }
}

struct TimeModel: Codable {
    let beats: String?
    let beatType: String?

    enum CodingKeys: String, CodingKey {
        case beats = "beats"
        case beatType = "beat-type"
    }
}

struct ClefModel: Codable {
    let sign: String?
    let line: String?

    enum CodingKeys: String, CodingKey {
        case sign = "sign"
        case line = "line"
    }
}

struct NoteModel: Codable, Identifiable {
    let id = UUID()
    let pitch: PitchModel?
    let duration: String?
    let voice: String?

    enum CodingKeys: String, CodingKey {
        case pitch = "pitch"
        case duration = "duration"
        case voice = "voice"
    }
}


struct PitchModel: Codable {
    let step: String?
    let octave: String?

    enum CodingKeys: String, CodingKey {
        case step = "step"
        case octave = "octave"
    }
}
