//
//  WorkScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class WorkScore: ParserBase {
    var workTitle: String = ""
    
    private func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {

//            print("processing <\(elementName)> tag from WorkScore")

            if elementName == "work-title" {
                workTitle = foundCharacters
                print("work title: \(workTitle)")
                parser.delegate = self.parent
            }
        
            foundCharacters = ""
        }
}
