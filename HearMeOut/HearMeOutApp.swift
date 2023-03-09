//
//  MC3App.swift
//  MC3
//
//  Created by luke-the-coder on 13/02/23.
//

import SwiftUI
import AVFoundation

@main
struct HearMeOutApp: App {
    init() {
#if os(iOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let err {
            print(err)
        }
#endif
    }
    var body: some Scene {
        WindowGroup {
            LibraryView()
            //            ScoreView(url:Bundle.main.url(forResource: "MozartPianoSonata" , withExtension: "musicxml")!)
        }
    }
}
