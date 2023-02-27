//
//  MusicManager.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 19/01/23.
//

import Foundation
import MidiParser
import AVFAudio
import AVFoundation

class MusicScoreViewModel: ObservableObject {
    @Published var musicScore: ScorePartwise?
    let url: URL = Bundle.main.url(forResource: "Chant" , withExtension: "musicxml")! //MozartPianoSonata
    let soundBankURL: URL = Bundle.main.url(forResource: "YDP-GrandPiano-20160804" , withExtension: "sf2")!
    let midiSoundURL: URL = Bundle.main.url(forResource: "for_elise_by_beethoven" , withExtension: "mid")!

    let midi = MidiData()
    var midiPlayer: AVMIDIPlayer!
    var midiURL: URL? = nil
    
    let parserManager: ParserManager = ParserManager()
    
    
    init() {
        musicScore = parserManager.parseFromUrl(url: url)
        
        createMidi(measureStart: 1, measureEnd: 1, bpm: 60)
    }
    

    
    func createMidi(measureStart: Int, measureEnd: Int, bpm: Int) {
        guard let musicScore else { return }
        
        print("CREATE MIDI")
        let track1 = midi.addTrack()
        track1.patch = .init(channel: 0, patch: .acousticGrand)
        
        var measures: [MeasureScore] = []
        let bpmTime: Float32 = 60.0 / Float32(bpm)
        var timeBase: MusicTimeStamp = 0.0 /* 60 / 120 */
        
        var division: Int = 0
        var lastDivision: Int = 0
        /* durata / division */
        measures = musicScore.part.measure.filter({ $0.id >= measureStart && $0.id <= measureEnd })
        print("measure \(measures)")
        var midiNoteGroup: [MidiNote] = []
        for measure in measures {
            division = measure.attributes.divisions
            
            for staff in 0..<measure.staffGroup.count {
//                print("staff number MIDI \(staff)")
                timeBase = 0.0
                for group in 0..<measure.staffGroup[staff].group.count {
//                    print("group number MIDI \(group)")
                    timeBase = 0.0
                    
                    for noteGroup in measure.staffGroup[staff].group[group].note {
//                        print("group note MIDI: \(note)")
                            print("noteGroup MIDI \(noteGroup)")
                        for singleNote in noteGroup {
                            print("note MIDI \(singleNote.pitch.step.rawValue), time \(timeBase), midiNote \(MidiModel().getMidiNumber(step: singleNote.pitch.step, octave: singleNote.pitch.octave, alter: singleNote.pitch.alter)), octave \(singleNote.pitch.octave)")
                            if lastDivision != division && division != 0 {
                                lastDivision = division
                            }
                            print("duration \(Float32(singleNote.duration)), division \(Float32(lastDivision)), bpm \(bpmTime) ")
                            let regularDuration: Float32 = (Float32(singleNote.duration) / Float32(lastDivision)) * bpmTime
                            if singleNote.pitch.step != .none {
                                let note = MidiNote(regularTimeStamp: timeBase, regularDuration: regularDuration, note: MidiModel().getMidiNumber(step: singleNote.pitch.step, octave: singleNote.pitch.octave, alter: singleNote.pitch.alter), velocity: 100, channel: 0)
                                midiNoteGroup.append(note)
                            }
                            
                            timeBase = MusicTimeStamp(regularDuration) + timeBase
                        }
                        track1.add(notes: midiNoteGroup)
                        midiNoteGroup = []
                    }
                }
            }
        }
        
        track1.patch = MidiPatch(channel: 0, patch: .acousticGrand)
        track1.name = "Track 1"
        
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("Track 1.mid") else { return }
        
        do {
            try midi.writeData(to: url)
            print("midi created \(url)")
            midiURL = url
        } catch {
            print("write midi: \(error.localizedDescription)")
        }
        
    }
    
    func playMidi() {
        guard let midiURL = midiURL else { return }
        
        print("playurl \(midiURL)")
        do {
            midiPlayer = try AVMIDIPlayer(contentsOf: midiURL, soundBankURL: soundBankURL)
            midiPlayer.prepareToPlay()
            midiPlayer.play() {
                print("finished playing")
            }
        } catch {
            print("could not create MIDI player")
        }
    }
}



