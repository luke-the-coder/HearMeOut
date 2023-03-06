//
//  ParserManager.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

class ParserManager {
    let url: URL = Bundle.main.url(forResource: "Chant" , withExtension: "musicxml")!
    
    init() {
        
    }
    
    func parseFromUrl(url: URL) -> ScorePartwise? {
//        print("parseFromUrl \(url)")
        // MozartPianoSonata
        let url: URL = Bundle.main.url(forResource: "MozartPianoSonata" , withExtension: "musicxml")!
//        print("parseFromUrl \(url)")
        do {
            let string = try String(contentsOf: url)
            let data = string.data(using: .utf8)!
            let parser = XMLParser(data: data)

            let score = ScorePartwise()
            parser.delegate = score

            parser.parse()
            return score
            //print("SCORE: \(score.work.workTitle)")
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
