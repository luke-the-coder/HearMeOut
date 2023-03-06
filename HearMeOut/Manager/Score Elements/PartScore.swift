//
//  PartScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class PartScore: ParserBase {
    var measure: [MeasureScore] = []
    
    init(measure: [MeasureScore] = []) {
        self.measure = measure
    }
    
    internal override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {

//            print("processing <\(elementName)> tag from PartScore")

            if elementName == "measure" {
                let measure = MeasureScore()
                self.measure.append(measure)
                
                if let c = Int(attributeDict["number"]!) {
                    measure.id = c
                }
                
                parser.delegate = measure

                measure.parent = self
            }
            else {
                parser.delegate = self.parent
            }

            foundCharacters = ""
        }
}
