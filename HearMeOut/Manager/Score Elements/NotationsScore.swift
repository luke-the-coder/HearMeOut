//
//  NotationsScore.swift
//  MC3
//
//  Created by Nicola Rigoni on 25/02/23.
//

import Foundation

class NotationsScore: ParserBase {
    var arpeggiante: Bool = false
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print("processing didEnd <\(elementName)> tag from NotationsScore")
        
        if elementName == "arpeggiate" {
            arpeggiante = true
            
            
        } else if elementName == "notations" {
            parser.delegate = self.parent
        }
                    
        foundCharacters = ""
    }
}
