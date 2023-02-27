//
//  AttributeScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class AttributeScore: ParserBase {
    var divisions: Int = 0
    var staves: Int = 0
    var key: KeyScore = KeyScore()
    var time: TimeScore = TimeScore()
    var clef: [ClefScore] = []
    
    
    private func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
//        print("processing didEnd <\(elementName)> tag from AttributeScore")
        
        if elementName == "divisions" {
            if let divisions = Int(foundCharacters) {
                self.divisions = divisions
                foundCharacters = ""
                print("divisions: \(divisions)")
            }
            
        } else if elementName == "staves" {
            if let staves = Int(foundCharacters) {
                self.staves = staves
                foundCharacters = ""
                print("staves: \(staves)")
            }
        } else if elementName == "attributes" {
            parser.delegate = self.parent
        }
        foundCharacters = ""
    }
    
    internal override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
//        print("processing didStart <\(elementName)> tag from AttributeScore")
        
        if elementName == "key" {
            
            parser.delegate = key
            key.parent = self
            
        } else if elementName == "time" {
            print("dentro a time")
            
            parser.delegate = time
            time.parent = self
            
        } else if elementName == "clef" {
            print("dentro a clef")
            let clef = ClefScore()
            self.clef.append(clef)
            
            if let c = Int(attributeDict["number"] ?? "1") {
                clef.id = c
            }
            print("id = \(clef.id)")
            
            parser.delegate = clef

            clef.parent = self
        }
        
        foundCharacters = ""
    }
}
