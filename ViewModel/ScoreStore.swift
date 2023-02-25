//
//  ScoreStore.swift
//  MC3
//
//  Created by luke-the-coder on 24/02/23.
//

import Foundation
import CoreData

class ScoreStore: ObservableObject {
    @Published var scores: [Score] = []
    @Published var searchText = ""
    
    init() {
        fetchScores()
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
}
