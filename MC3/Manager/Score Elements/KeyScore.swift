//
//  KeyScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class KeyScore: ParserBase {
    var fifths: Int = 0
    
    private func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
//        print("processing <\(elementName)> tag from KeyScore")
        
        if elementName == "fifths" {
            if let fifths = Int(foundCharacters) {
                self.fifths = fifths
                foundCharacters = ""
                print("fifths: \(fifths)")
            }
            parser.delegate = self.parent
        }
        foundCharacters = ""
    }
}
