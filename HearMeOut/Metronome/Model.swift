//
//  Model.swift
//  MetronomoForBlind
//
//  Created by Marta Michelle Caliendo on 21/02/23.
//

import Foundation
import AVFoundation

class Metronome: ObservableObject {
    var bpm: Float = 60.0 { didSet {
        bpm = min(300.0,max(30.0,bpm))
        }}
    var enabled: Bool = false { didSet {
        if enabled {
            start()
        } else {
            stop()
        }
        }}
    var onTick: ((_ nextTick: DispatchTime) -> Void)?
    var nextTick: DispatchTime = DispatchTime.distantFuture

    let player: AVAudioPlayer = {
        do {
            let soundURL = Bundle.main.url(forResource: "beatUp", withExtension: "wav")!
            let soundFile = try AVAudioFile(forReading: soundURL)
            let player = try AVAudioPlayer(contentsOf: soundURL)
            return player
        } catch {
            print("Oops, unable to initialize metronome audio buffer: \(error)")
            return AVAudioPlayer()
        }
    }()
    

    private func start() {
        print("Starting metronome, BPM: \(bpm)")
        player.prepareToPlay()
        nextTick = DispatchTime.now()
        tick()
    }

    private func stop() {
        player.stop()
        print("Stoping metronome")
    }

    private func tick() {
        guard
            enabled,
            nextTick <= DispatchTime.now()
            else { return }

        let interval: TimeInterval = 60.0 / TimeInterval(bpm)
        nextTick = nextTick + interval
        DispatchQueue.main.asyncAfter(deadline: nextTick) { [weak self] in
            print("reproduce")
            self?.tick()
        }

        player.play(atTime: interval)
        onTick?(nextTick)
    }
}
