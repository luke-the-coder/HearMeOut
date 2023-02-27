//
//  ClefScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class ClefScore: ParserBase {
    var id: Int = 0
    var sign: ClefSign = .none
    var line: Int = 0
    
    private func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
//        print("processing <\(elementName)> tag from ClefScore")
        
        if elementName == "sign" {
            if let sign = ClefSign(rawValue: foundCharacters) {
                self.sign = sign
                print("sign: \(sign)")
            }
        } else if elementName == "line" {
            if let line = Int(foundCharacters) {
                print("line: \(line)")
                self.line = line
            }
        } else if elementName == "clef" {
            parser.delegate = self.parent
        }
        
        foundCharacters = ""
    }
}
