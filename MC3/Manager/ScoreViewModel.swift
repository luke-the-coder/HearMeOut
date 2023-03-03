//
//  ScoreViewModel.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 19/01/23.
//

import Foundation
import MidiParser
import AVFAudio
import AVFoundation

class ScoreViewModel: ObservableObject {
    @Published var musicScore: ScorePartwise?
    @Published var measureIndex: Int = 0
    
    let url: URL = Bundle.main.url(forResource: "Chant" , withExtension: "musicxml")! //MozartPianoSonata
    let soundBankURL: URL = Bundle.main.url(forResource: "YDP-GrandPiano-20160804" , withExtension: "sf2")!

    let midi = MidiData()
    var midiPlayer: AVMIDIPlayer!
    var midiURL: URL? = nil
    
    let parserManager: ParserManager = ParserManager()
    
    @Published var focusElements: [FocusModel] = []
    
    var minIndexScore: Int? {
        if let musicScore {
           return musicScore.part.measure[0].id
        }
        return nil
    }
    
    var maxIndexScore: Int? {
        if let musicScore {
            let endIndex = musicScore.part.measure.endIndex
            return musicScore.part.measure[endIndex].id
        }
        return nil
    }
    
    var maxIndexMeasure: Int? {
        if let musicScore {
            return musicScore.part.measure.count - 1
        }
        return nil
    }
    
    
    init(url: URL) {
        musicScore = parserManager.parseFromUrl(url: url)
        
        createMidi(measureStart: 1, measureEnd: 1, bpm: 60)
        
        
        generateFocusArray()
    }
    

    func goNext() {
        guard let maxIndexMeasure else { return }
        
        if measureIndex < maxIndexMeasure {
            measureIndex += 1
        }
    }
    
    func goPrevious() {
        
        if measureIndex > 0 {
            measureIndex -= 1
        }
    }
    
    func generateFocusArray() {
        guard let musicScore else { return }
        
        let measureAtIndex = musicScore.part.measure[measureIndex]
        var clefIndex: Int = 0
        var beatIndex: Int = 0
        
        
        
        for staf in measureAtIndex.staffGroup {
            for groupIndex in 0..<staf.group.count {
                if !measureAtIndex.attributes.clef.isEmpty {
                    let clefFocusElement: FocusModel = FocusModel.clef(id: clefIndex)
                    focusElements.append(clefFocusElement)
                    clefIndex += 1
                }
                
                if measureAtIndex.attributes.time.beatType != .none {
                    let beatFocusElement: FocusModel = FocusModel.beat(id: beatIndex)
                    focusElements.append(beatFocusElement)
                    beatIndex += 1
                }
                
                let groupFocusElement: FocusModel = FocusModel.note(id: groupIndex)
                focusElements.append(groupFocusElement)
            }
        }
        
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



