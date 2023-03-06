////
////  Model.swift
////  MetronomoForBlind
////
////  Created by Marta Michelle Caliendo on 21/02/23.
////
//
//import Foundation
//import AVFoundation
//
//
//class MetronomoManager: ObservableObject {
//
//    //    let sequencer = AppleSequencer()
//    //    let data: ShakerMetronomeData = ShakerMetronomeData()
//
//    var timer: Timer? = nil
//    var count: Int = 0
//
//    var player = AVAudioPlayer()
//
//    init() {
//        //        updateSequences()
//        //        sequencer.enableLooping()
//        //        sequencer.play()
//        startMetronome(timeInterval: calculateBeatDuration(bpm: 60), beatNumber: 4)
//    }
//
//    func calculateBeatDuration(bpm: Int) -> Double {
//        60.0 / Double(bpm)
//    }
//
//    func startMetronome(timeInterval: Double, beatNumber: Int) {
//        print("start metronome")
//        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
//            print("trick")
//            print(self.count)
//            if beatNumber != 1 {
//                if self.count == 0 {
//                    self.playBeat(beat: "beatUp")
//                    self.count += 1
//                } else if self.count < beatNumber {
//                    self.playBeat(beat: "beatDown")
//                    self.count += 1
//                    if self.count >= beatNumber {
//                        self.count = 0
//                    }
//                }
//            } else {
//                self.playBeat(beat: "beatUp")
//            }
//
//        }
//    }
//
//    func stopMetronome() {
//        guard let timer else { return }
//
//        timer.invalidate()
//    }
//
//    func playBeat(beat: String) {
//        let path = Bundle.main.path(forResource: beat, ofType: "wav")!
//        let url = URL(filePath: path)
//
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player.play()
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//
//
//}
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
