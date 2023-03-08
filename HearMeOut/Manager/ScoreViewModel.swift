//
//  ScoreViewModel.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 19/01/23.
//

import Foundation
import MidiParser
import AVFoundation
import AVFAudio
import Combine
import SwiftUI

class ScoreViewModel: ObservableObject {
    
    static let shared = ScoreViewModel()
    
    @Published var musicScore: ScorePartwise?
    @Published private var originalScore: ScorePartwise?
    @Published var measureIndex: Int = 0
    
    private var midiURL: URL? = nil
    
    @Published var staffDictionary: [StaffSettingModel] = []
    
    private let parserManager: ParserManager = ParserManager()
    private let midiManager: MidiManager = MidiManager.shared
    
    @Published var focusElements: [FocusModel] = []
    
    @Published var accessibilityString: [String] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var divisionPlay: DivisionPlay = .all
    @Published var divisionRead: DivisionRead = .note
    
    @Published var isPlaying: Bool = false
    
    private var minIndexScore: Int? {
        if let musicScore {
           return musicScore.part.measure[0].id
        }
        return nil
    }
    
    private var maxIndexScore: Int? {
        if let musicScore {
            let endIndex = musicScore.part.measure.endIndex
            return musicScore.part.measure[endIndex].id
        }
        return nil
    }
    
    private var maxIndexMeasure: Int? {
        if let musicScore {
            return musicScore.part.measure.count - 1
        }
        return nil
    }
    
    var checkStafSelection: Bool {
        print("checkStafSelection")
        var allIsActive: Bool = true
        for staf in staffDictionary {
            if !staf.isActive {
               allIsActive = false
            }
        }
        print("all is active \(allIsActive.description)")
        return allIsActive
    }
    
    var indexCheckStaffActive: Int? {
        guard let index = staffDictionary.firstIndex(where: { $0.isActive == true }) else { return  nil}
        print("indexCheckStaffActive \(index)")
        return index
    }
    
    
    private init() {
        
        
        $originalScore
            .combineLatest($staffDictionary)
            .map(filterByStaff)
            .sink {[weak self] returnedScore in
                self?.musicScore = returnedScore
//                self?.generateStafAccessibility()
                print("ESEGUO SINK HOME VM")
            }
            .store(in: &cancellables)
        
        
        
    }
    
    func decodeScoreFrom(_ url: URL) {
        measureIndex = 0
        originalScore = parserManager.parseFromUrl(url: url)
        generateStaffDictionary()
        
        generateFocusArray()
    }
    
    func goNext() {
        guard let maxIndexMeasure else { return }
        
        if measureIndex < maxIndexMeasure {
            measureIndex += 1
            generateStafAccessibility(musicScore: musicScore)
        }
    }
    
    func goPrevious() {
        
        if measureIndex > 0 {
            measureIndex -= 1
            generateStafAccessibility(musicScore: musicScore)
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
    
    private func filterByStaff(_ musicScore: ScorePartwise?, _ staffDictionary: [StaffSettingModel]) -> ScorePartwise? {
        var staffBoolArray: [Bool] = []
        var index: Int?
        
        for staf in staffDictionary {
            
            staffBoolArray.append(staf.isActive)
        }
        
        if !staffBoolArray.allSatisfy({ $0 }) {
            index = staffBoolArray.firstIndex(where: { $0 == true })
//            print("index true \(index)")
        }
        
        guard let index else {
            generateStafAccessibility(musicScore: musicScore)
            return musicScore
            
        }
        
        guard let musicScore else {
            generateStafAccessibility(musicScore: musicScore)
            return musicScore
            
        }
        
        var measures: [MeasureScore] = []
        
        for measure in musicScore.part.measure {
            let staffGroup = measure.staffGroup[index]
            
            let measure: MeasureScore = MeasureScore(id: measure.id, attributes: measure.attributes, staffGroup: [staffGroup])
            measures.append(measure)
        }
        
        let part = PartScore(measure: measures)
        let scorePartwise = ScorePartwise(version: musicScore.version, work: musicScore.work, part: part)
        generateStafAccessibility(musicScore: scorePartwise)
        return scorePartwise
    }
    
        
    private func generateStaffDictionary() {
        guard let originalScore else { return }
        
        guard let measure = originalScore.part.measure.first else { return }
        
        for staves in 0..<measure.attributes.staves {
            let staffRow = StaffSettingModel(name: NSLocalizedString("Staff \(staves + 1)", comment: "Staff"))
            staffDictionary.append(staffRow)
        }
    }
    
    func createMidi() {
        guard let musicScore else { return }
        print("CREATE MIDI")
        let midi = MidiData()
        let track1 = midi.addTrack()
        track1.patch = .init(channel: 0, patch: .acousticGrand)
        
        var measures: [MeasureScore] = []
        let bpmTime: Float32 = 60.0 / Float32(60) //sostituire con bpm
        
        
        
        var timeBases: [MusicTimeStamp] = [] /* 60 / 120 */
        
        for _ in staffDictionary {
            timeBases.append(0.0)
        }
        
        var division: Int = 0
        var lastDivision: Int = 0
        /* durata / division */
        
        if divisionPlay == .all {
            measures = musicScore.part.measure
        } else if divisionPlay == .bar {
            measures = [musicScore.part.measure[measureIndex]]
        }
        
//        measures = musicScore.part.measure.filter({ $0.id >= measureStart && $0.id <= measureEnd })
        print("measure \(measures)")
        var midiNoteGroup: [MidiNote] = []
        
        //prendo sempre dal primo a prescindere da modificare
        guard let originalScore else { return }
        guard let originalMeasure = originalScore.part.measure.first else { return }
        
        division = originalMeasure.attributes.divisions
        
        
        
        
        for measure in measures {
//            division = measure.attributes.divisions
            
            for staff in 0..<measure.staffGroup.count {
                print("staff number MIDI \(staff)")
//                timeBase = 0.0
                var groupTime = 0.0
                for group in 0..<measure.staffGroup[staff].group.count {
                    print("group number MIDI \(group)")
//                    timeBase = 0.0
                    groupTime = 0.0
                    for noteGroup in measure.staffGroup[staff].group[group].note {
//                        print("group note MIDI: \(note)")
                            print("noteGroup MIDI \(noteGroup)")
                        var regularDuration: Float32 = 0.0
                        for singleNote in noteGroup {
                            print("note MIDI \(singleNote.pitch.step.rawValue), time \(timeBases[staff]), midiNote \(MidiModel().getMidiNumber(step: singleNote.pitch.step, octave: singleNote.pitch.octave, alter: singleNote.pitch.alter)), octave \(singleNote.pitch.octave)")
                            if lastDivision != division && division != 0 {
                                lastDivision = division
                            }
                            var singleNoteDuration: Float32 = Float32(singleNote.duration)
                            
                            if singleNote.type == .the32Nd {
                                singleNoteDuration = 1
                            }
                            
                            let regularTimeStamp: MusicTimeStamp = groupTime + timeBases[staff]
                            print("duration \(singleNoteDuration), division \(Float32(lastDivision)), bpm \(bpmTime), timestamp \(regularTimeStamp) ")
                            
                            regularDuration = (singleNoteDuration / Float32(lastDivision)) * bpmTime
                            
                            if singleNote.pitch.step != .none {
                                let note = MidiNote(regularTimeStamp: regularTimeStamp, regularDuration: regularDuration, note: MidiModel().getMidiNumber(step: singleNote.pitch.step, octave: singleNote.pitch.octave, alter: singleNote.pitch.alter), velocity: 100, channel: 0)
                                midiNoteGroup.append(note)
                            }
                            
                        }
                        groupTime = MusicTimeStamp(regularDuration) + groupTime
                        track1.add(notes: midiNoteGroup)
                        midiNoteGroup = []
                    }
                }
                timeBases[staff] += groupTime
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
    
    private func playMidi() {
        isPlaying = true
        midiManager.playMidi(midiURL: midiURL) { _ in
            DispatchQueue.main.async {
                self.isPlaying = false
            }
            
        }
    }
    
    private func stopMidi() {
        isPlaying = false
        midiManager.stopMidi()
    }
    
    func playStopMidi() {
        if !isPlaying {
            playMidi()
        } else {
            stopMidi()
        }
    }
    
    func generateStafAccessibility(musicScore: ScorePartwise?) {
        guard let musicScore else { return }
        let measure = musicScore.part.measure[measureIndex]
        let clef = measure.attributes.clef
        let beatType = measure.attributes.time.beatType
        accessibilityString = []
        for staff in 0..<measure.staffGroup.count {
            print("music \(staff) clef \(clef)")
           var string = ""
            if !clef.isEmpty {
                var indexStaf = staff
                if !checkStafSelection {
                    print("check")
                    guard let indexCheckStaffActive else { print("return"); return }
                   indexStaf = indexCheckStaffActive
                    print("indexStaf \(indexStaf)")
                }
                print("key")
                string += String(localized: "Key,", table: "Localizable")
                string += NSLocalizedString(clef[indexStaf].sign.rawValue, tableName: "Localizable", comment: "pitch")
                string += ","
            }
            if beatType != .none {
                string += beatType.description
                string += ","
            }
            for group in 0..<measure.staffGroup[staff].group.count {
                for noteGroup in measure.staffGroup[staff].group[group].note {
                    if noteGroup.count > 1 {
                        string += String(localized: "Chord,", table: "Localizable")
                    }
                    
                    for note in noteGroup {
                        string += "\(note.isRest ? "rest" : NSLocalizedString(note.pitch.step.rawValue, tableName: "Localizable", comment: "pitch")) \(note.pitch.octave)"
                        
                            if note.pitch.alter == 1 {
                                string += String(localized: "sharp", table: "Localizable")
                            } else if note.pitch.alter == -1 {
                                string += String(localized: "flet", table: "Localizable")
                            }
                        string += ","
                    }
                    
                    if noteGroup.count > 1 {
                        string += String(localized: "end chord", table: "Localizable")
                    }
                }
            }
            accessibilityString.append(string)
        }
    }
}



