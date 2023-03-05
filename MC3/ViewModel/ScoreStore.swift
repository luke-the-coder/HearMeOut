//
//  ScoreStore.swift
//  MC3
//
//  Created by luke-the-coder on 24/02/23.
//

import SwiftUI
import CoreData

class ScoreStore: ObservableObject {
    @Published var scores: [Score] = []
    @Published var searchText = ""
    @AppStorage("firstLoad") var firstLoad: Bool = false
    
    init() {
        if !firstLoad {
            firstUpload()
        }
        fetchScores()
        checkDeletedFile()
    }
    
    private func firstUpload() {
        let scoreItems: [String] = ["Chant", "MozartPianoSonata"]
        
        for score in scoreItems {
            let fileUrl = Bundle.main.url(forResource: score , withExtension: "musicxml")!
            
            do {
                let musicScore = try MusicXMLDecoder.decode(type: ScoreModel.self, from: fileUrl)
                if (musicScore.movementTitle != nil) {
                    checkSavedScores(fileURL: fileUrl, Title: (musicScore.movementTitle) ?? "", Author:  (musicScore.identification?.creator) ?? "")
                } else {
                    checkSavedScores(fileURL: fileUrl, Title: (musicScore.work?.workTitle) ?? "", Author:  (musicScore.identification?.creator) ?? "")
                }
                firstLoad = true
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchScores() {
        let request = NSFetchRequest<Score>(entityName: "Score")
        do {
            scores = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    private func saveChanges() {
        PersistenceController.shared.saveContext() { error in
               guard error == nil else {
                   print("An error occurred while saving: \(error!)")
                   return
               }
               self.fetchScores()
           }
       }
    
    private func addItem(fileURL : URL, Title : String, Author: String){
        let newItem = Score(context: PersistenceController.shared.container.viewContext)
        newItem.timestamp = Date()
        newItem.path = fileURL
        newItem.composer = Author
        newItem.movementTitle = Title
        newItem.filename = fileURL.deletingPathExtension().lastPathComponent
        saveChanges()
    }
    
    func checkDeletedFile(){
        let fileManager = FileManager.default
        
        for Score in scores{
            if fileManager.fileExists(atPath: Score.path!.path) {
                print("File found in file manager")
            } else {
                print("File not found in file manager, deleting it in core data...")
                deleteScore(Score: Score)
            }
        }
    }
    
    func checkSavedScores(fileURL : URL, Title : String, Author: String){
        for Score in scores{
            if (Score.path! == fileURL){
                print("ERROR: FILE ALREADY SAVED")
                return
            }
        }
        print("New file found: let me add it.")
        addItem(fileURL: fileURL, Title: Title, Author: Author)
    }
    
    func deleteScore(Score: Score) {
        PersistenceController.shared.container.viewContext.delete(Score)
        saveChanges()
    }
    
    func deleteItems(offsets: IndexSet) {
        offsets.map { scores[$0] }.forEach(PersistenceController.shared.container.viewContext.delete)
       saveChanges()
    }
    var filteredScores: [Score] {
            if searchText.isEmpty {
                return scores
            } else {
                return scores.filter { $0.movementTitle?.range(of: searchText, options: .caseInsensitive) != nil }
            }
        }
        
    func filterScores() {
        let request = NSFetchRequest<Score>(entityName: "Score")
        if !searchText.isEmpty {
            request.predicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
        }
        do {
            scores = try PersistenceController.shared.container.viewContext.fetch(request)
        } catch {
            print("Error fetching. \(error)")
        }
    }
    
    func updateScore(score: Score, bpm: Int16, hasMetronome: Bool, staff : String, tempo: String) {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "path == %@", score.path! as CVarArg)
        do {
            let fetchedScore = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            if (fetchedScore.first != nil) {
                fetchedScore.first!.bpm = bpm
                fetchedScore.first!.hasMetronome = hasMetronome
                fetchedScore.first!.staff = staff
                fetchedScore.first!.tempo = tempo
                print("Succesfully updated the settings!")
                saveChanges()
            }
        } catch {
            print("Error fetching user: \(error)")
        }
    }
    
    func retrieveScore(path: URL) -> Score {
        let fetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
        var fetchedScore : [Score] = []
        fetchRequest.predicate = NSPredicate(format: "path == %@", path as CVarArg)
        do {
            fetchedScore = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            
        } catch {
            print("Error fetching user: \(error)")
        }
        return fetchedScore.first!
    }

}
