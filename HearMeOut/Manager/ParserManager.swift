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
//        print("URL EXT 1 \(url)")
//        guard url.startAccessingSecurityScopedResource() else { return nil }
        print("URL EXT 2 \(url)")
        // MozartPianoSonata
//        let url: URL = Bundle.main.url(forResource: "MozartPianoSonata" , withExtension: "musicxml")!
//        print("URL BUNDLE \(url)")
        
        do {
            let string = try String(contentsOf: url)
            let data = string.data(using: .utf8)!
            let parser = XMLParser(data: data)

            let score = ScorePartwise()
            parser.delegate = score

            parser.parse()
//            url.stopAccessingSecurityScopedResource()
            return score
            //print("SCORE: \(score.work.workTitle)")
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
