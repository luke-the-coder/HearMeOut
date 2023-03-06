//
//  BackupScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class BackupScore: ParserBase {
    var duration: Int = 0
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print("processing <\(elementName)> tag from BackupScore")
        
        if elementName == "duration" {
            if let duration = Int(foundCharacters) {
                print("duration: \(duration)")
                self.duration = duration
            }
        } else if elementName == "backup" {
            parser.delegate = self.parent
        }
        
        foundCharacters = ""
    }
}
