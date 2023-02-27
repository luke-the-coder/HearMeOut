//
//  MeasureScore.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

struct StaffGroup: Identifiable {
    let id: String = UUID().uuidString
    let group: [GroupNote]
}

struct GroupNote: Identifiable {
    let id: String = UUID().uuidString
    let note: [[NoteScore]]
}

class MeasureScore: ParserBase {
    var id: Int = 0
    var attributes = AttributeScore()
    private var notes: [NoteScore] = []
    
    var staffGroup: [StaffGroup] = []
    
    private func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        print("processing <\(elementName)> tag from MeasureScore")
        
        if elementName == "measure" {
            
            var notesCopy = notes
            print("number of staff \(numberOfStaff().count )")
            
            if numberOfStaff().count != 0 {
                for staffIndex in 0..<numberOfStaff().count {
                    var staffNotes: [NoteScore] = []
                    var groupNotesTemp: [GroupNote] = []
                    let currentStaff = numberOfStaff()[staffIndex]
                    let numberOfVoiceInStaff = numberOfVoiceInStaff(notes: notes, staff: currentStaff)
                    
                    var endNotesIndex = 0
                    
                    for _ in numberOfVoiceInStaff {
                        staffNotes = []
                        var groupedStaffNotes: [[NoteScore]] = []
                        
                        for (index, note) in notesCopy.enumerated() {
                            var indexNext = index
                            if index < notesCopy.endIndex - 1 {
                                indexNext += 1
                            }
                            
                            endNotesIndex = index
                            
                            if note.isForward || note.staff == currentStaff {
                                
                                if notesCopy[indexNext].isChord || note.notations.arpeggiante || note.isChord {
                                    
                                    staffNotes.append(note)
                                } else {
                                    if !staffNotes.isEmpty {
                                        groupedStaffNotes.append(staffNotes)
                                        staffNotes = []
                                    }
                                    
                                    groupedStaffNotes.append([note])
                                }
                                
                            }
                            if note.isBackup {
                                break
                            }
                            
                        }
                        notesCopy.removeSubrange(0...endNotesIndex)
                        if !staffNotes.isEmpty {
                            groupedStaffNotes.append(staffNotes)
                            staffNotes = []
                        }
                        let notesGroup = GroupNote(note: groupedStaffNotes)
                        print("group notes in \(notesGroup)")
                        groupNotesTemp.append(notesGroup)
                    }
                    let staffGroup = StaffGroup(group: groupNotesTemp)
                    self.staffGroup.append(staffGroup)
                }
            } else {
                
                
                
                let numberOfVoiceInStaff = numberOfVoiceInStaff(notes: notes)
                var groupNotesTemp: [GroupNote] = []
                var staffNotes: [NoteScore] = []
                
                for _ in numberOfVoiceInStaff {
                    staffNotes = []
                    var groupedStaffNotes: [[NoteScore]] = []
                    var endNotesIndex = 0
                    for (index, note) in notesCopy.enumerated() {
                        var indexNext = index
                        if index < notesCopy.endIndex - 1 {
                            indexNext += 1
                        }
                        
                        endNotesIndex = index
                        
                            
                            if notesCopy[indexNext].isChord || note.notations.arpeggiante || note.isChord {
                                
                                staffNotes.append(note)
                            } else {
                                if !staffNotes.isEmpty {
                                    groupedStaffNotes.append(staffNotes)
                                    staffNotes = []
                                }
                                
                                groupedStaffNotes.append([note])
                            }
                        if note.isBackup {
                            break
                        }
                        
                    }
                    notesCopy.removeSubrange(0...endNotesIndex)
                    if !staffNotes.isEmpty {
                        groupedStaffNotes.append(staffNotes)
                        staffNotes = []
                    }
                    let notesGroup = GroupNote(note: groupedStaffNotes)
                    print("group notes in \(notesGroup)")
                    groupNotesTemp.append(notesGroup)
                }
                let staffGroup = StaffGroup(group: groupNotesTemp)
                self.staffGroup.append(staffGroup)
            }
            
            for staff in 0..<staffGroup.count {
                print("staff number \(staff)")
                for group in 0..<staffGroup[staff].group.count {
                    print("group number \(group)")
                    for note in staffGroup[staff].group[group].note {
                        print("group note: \(note)")
                        for singleNote in note {
                            print("note \(singleNote.pitch.step.rawValue)")
                        }
                    }
                }
            }
            
            parser.delegate = self.parent
        }
        
        foundCharacters = ""
    }
    
    internal override func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
//        print("processing <\(elementName)> tag from MeasureScore")
        
        if elementName == "attributes" {
            
            parser.delegate = attributes
            
            attributes.parent = self
        } else if elementName == "note" {
            let note = NoteScore()
            self.notes.append(note)
            
            parser.delegate = note
            note.parent = self
        } else if elementName == "backup" {
            print("dentro a backup")
            let note = NoteScore()
            note.isBackup = true
            self.notes.append(note)
            
            
            parser.delegate = note
            note.parent = self
        } else if elementName == "forward" {
            print("dentro a forward")
            let note = NoteScore()
            note.isForward = true
            self.notes.append(note)
            
            
            parser.delegate = note
            note.parent = self
        }
        
        foundCharacters = ""
    }
    
    private func numberOfVoiceInStaff(notes: [NoteScore], staff: Int? = nil) -> [Int] {
        var currentVoice = 0
        var number: [Int] = []
        if let staff {
            for note in notes {
                if note.voice != currentVoice && note.voice != 0 && note.staff == staff {
                    number.append(note.voice)
                    currentVoice = note.voice
                }
            }
        } else {
            for note in notes {
                if note.voice != currentVoice && note.voice != 0 {
                    number.append(note.voice)
                    currentVoice = note.voice
                }
            }
        }
        
        return number
    }
    
    private func numberOfStaff() -> [Int] {
        var currentStaff = 0
        var number: [Int] = []
        for note in notes {
            
            if note.staff != currentStaff && note.staff != 0 {
                print("currentStaff \(note.staff)")
                number.append(note.staff)
                currentStaff = note.staff
            }
        }
        return number
    }
    
}


