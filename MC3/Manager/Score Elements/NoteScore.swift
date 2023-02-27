//
//  NoteScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class NoteScore: ParserBase {
    let id: String = UUID().uuidString
    var pitch: PitchScore = PitchScore()
    var duration: Int = 0
    var voice: Int = 0
    var type: NoteType = .breve
    var staff: Int = 0
    var isBackup: Bool = false
    var isForward: Bool = false
    var isChord: Bool = false
    var isRest: Bool = false
    var notations: NotationsScore = NotationsScore()
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print("processing didEnd <\(elementName)> tag from NoteScore")
        
        if elementName == "duration" {
            if let duration = Int(foundCharacters) {
                self.duration = duration
                foundCharacters = ""
                print("duration: \(duration)")
            }
        } else if elementName == "voice" {
            if let voice = Int(foundCharacters) {
                self.voice = voice
                foundCharacters = ""
                print("voice: \(voice)")
            }
        } else if elementName == "type" {
            if let type = NoteType(rawValue: foundCharacters) {
                self.type = type
                print("type: \(type)")
            }
        } else if elementName == "staff" {
            if let staff = Int(foundCharacters) {
                self.staff = staff
                foundCharacters = ""
                print("staff: \(staff)")
            }
        } else if elementName == "chord" {
            self.isChord = true
        } else if elementName == "rest" {
            self.isRest = true
        } else if elementName == "note" {
            parser.delegate = self.parent
        } else if elementName == "backup" {
            parser.delegate = self.parent
        } else if elementName == "forward" {
            parser.delegate = self.parent
        }
        
        foundCharacters = ""
    }
    
    
    override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        print("processing didStart <\(elementName)> tag from NoteScore")
        
        if elementName == "pitch" {
            
            parser.delegate = pitch
            pitch.parent = self
            
        } else if elementName == "notations" {
            parser.delegate = notations
            notations.parent = self
        }
        
        
        // reset found characters
        foundCharacters = ""
    }
    
}
