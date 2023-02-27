//
//  ScorePartwise.swift
//  MC3
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class ScorePartwise: ParserBase {
    var version = 0.0
    
    var work = WorkScore()
    var part = PartScore()
    
    internal override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
//        print("processing <\(elementName)> tag from ScorePartwise")
        
        if elementName == "score-partwise" {
            
            if let c = Double(attributeDict["version"]!) {
                version = c
            }
        }
        
        if elementName == "work" {
            parser.delegate = work
            work.parent = self
        }
        
        if elementName == "part" {
            parser.delegate = part
            part.parent = self
        }
    }
}
