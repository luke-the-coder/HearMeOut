//
//  PitchScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class PitchScore: ParserBase {
    var step: Step = .none
    var octave: Int = 0
    var alter: Int = 0
    
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print("processing <\(elementName)> tag from PitchScore")
        
        if elementName == "step" {
            if let step = Step(rawValue: foundCharacters) {
                self.step = step
                print("step: \(step)")
            }
        } else if elementName == "octave" {
            if let octave = Int(foundCharacters) {
                print("octave: \(octave)")
                self.octave = octave
            }
        } else if elementName == "alter" {
            if let alter = Int(foundCharacters) {
                print("alter: \(alter)")
                self.alter = alter
            }
        } else if elementName == "pitch" {
            parser.delegate = self.parent
        }
        
        foundCharacters = ""
    }
}
