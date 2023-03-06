//
//  TimeScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation


class TimeScore: ParserBase {
    var beatType: BeatType = .none
    
    private var numerator: Int = 1
    private var denominator: Int = 4
    
    init(beatType: BeatType = .none) {
        self.beatType = beatType
    }
    
    private func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
//        print("processing <\(elementName)> tag from TimeScore")
        
        if elementName == "beats" {
            if let beat = Int(foundCharacters) {
                numerator = beat
                print("beats numerator: \(numerator)")
            }
        } else if elementName == "beat-type" {
            if let beat = Int(foundCharacters) {
                denominator = beat
                print("beats denominator: \(denominator)")
                beatType = beatType.getBeatType(numerator, denominator)
            }
        } else if elementName == "time" {
            print("beatType: \(beatType.rawValue)")
            parser.delegate = self.parent
        }
        
        foundCharacters = ""
    }
    
}
