//
//  MC3App.swift
//  MC3
//
//  Created by luke-the-coder on 13/02/23.
//

import SwiftUI

@main
struct HearMeOutApp: App {
    var body: some Scene {
        WindowGroup {
            LibraryView()
            //            ScoreView(url:Bundle.main.url(forResource: "MozartPianoSonata" , withExtension: "musicxml")!)
        }
    }
}
