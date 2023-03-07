//
//  AudioManager.swift
//  HearMeOut
//
//  Created by Marta Michelle Caliendo on 07/03/23.
//

import Foundation
import Combine
import AVFoundation

class AudioPlayer: NSObject, ObservableObject, AVAudioPlayerDelegate {
    
    let objectChange = PassthroughSubject<AudioPlayer, Never>()
    
    var isPlaying = false {
        didSet {
            objectChange.send(self)
        }
    }
    
    var audioPlayer: AVAudioPlayer!
    func startPlay(audio: URL) {
        let playbackSession = AVAudioSession.sharedInstance()
        
        do {
            try playbackSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audio)
            audioPlayer.delegate = self
            audioPlayer.play()
            isPlaying = true
        } catch {
            print("Play failed.")
        }
    }
    
    func stopPlay() {
        audioPlayer.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            isPlaying = false
        }
    }
    
}
