//
//  MidiManager.swift
//  MC3
//
//  Created by Nicola Rigoni on 04/03/23.
//

import Foundation
import AVFoundation

class MidiManager {
    static let shared = MidiManager()
    
    private let soundBankURL: URL = Bundle.main.url(forResource: "YDP-GrandPiano-20160804" , withExtension: "sf2")!
    
    private var midiPlayer: AVMIDIPlayer!
    
    func playMidi(midiURL: URL?, completion: @escaping (Bool) -> ()) {
        guard let midiURL = midiURL else { return }

        print("playurl \(midiURL)")
        do {
            midiPlayer = try AVMIDIPlayer(contentsOf: midiURL, soundBankURL: soundBankURL)
            midiPlayer.prepareToPlay()
            midiPlayer.play() {
                completion(true)
            }
        } catch {
            print("could not create MIDI player")
            completion(false)
        }
    }
    
    func stopMidi() {
        midiPlayer.stop()
    }
}
