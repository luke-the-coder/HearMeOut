//
//  LibraryView.swift
//  MC3
//
//  Created by luke-the-coder on 13/02/23.
//

import SwiftUI
import UniformTypeIdentifiers
import MusicXML
import XMLCoder

struct LibraryView: View {
    @State private var openFile = false
    @State var showingAlert = false
    @StateObject private var viewModel = ScoreStore()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List{
                ForEach(viewModel.filteredScores) { score in
                        NavigationLink(value: score) {
                            ScoreRowView(score: score)
                        }
                }.onDelete(perform: viewModel.deleteItems)
            }
            .navigationTitle("Scores")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        self.openFile.toggle()
                    }
                }
            }
            .navigationDestination(for: Score.self){ score in
                ScoreView(url: score.path!, fileName: score.filename!)
            }
        }
        .alert("Attention: you have already added this file", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        }
        .searchable(text: $viewModel.searchText, prompt: "Songs, Composer...")
        .fileImporter(isPresented: $openFile, allowedContentTypes: [UTType(filenameExtension: "musicxml")!]) { (res) in
            do {
                let fileUrl = try res.get()
                print(fileUrl)
                showingAlert = MusicScoreLoader().loadMusicScore(url: fileUrl, viewModel: viewModel)
            } catch {
                print ("error reading")
                print (error.localizedDescription)
            }
        }
        .onOpenURL{ url in
            _ = MusicScoreLoader().loadMusicScore(url: url, viewModel: viewModel)
            path.append(viewModel.retrieveScore(path: url))
        }
    }
}

struct MusicScoreLoader {
    func loadMusicScore(url: URL, viewModel: ScoreStore) -> Bool{
        var showingAlert : Bool = false
        do {
            guard url.startAccessingSecurityScopedResource() else { return false }
            do {
                let musicScore = try MusicXMLDecoder.decode(type: ScoreModel.self, from: url)
                if (musicScore.movementTitle != nil) {
                    showingAlert = viewModel.checkSavedScores(fileURL: url, Title: (musicScore.movementTitle) ?? "Unkown title", Author:  (musicScore.identification?.creator) ?? "Unkown author")
                } else {
                    showingAlert = viewModel.checkSavedScores(fileURL: url, Title: (musicScore.work?.workTitle) ?? "Unkown title", Author:  (musicScore.identification?.creator) ?? "Unkown author")
                }
            } catch {
                print(error.localizedDescription)
            }
            url.stopAccessingSecurityScopedResource()
        }
        return showingAlert
    }
}

//struct LibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibraryView()
//    }
//}

private struct ScoreRowView: View {
    let score: Score
    var body: some View {
        HStack(spacing: 16){
            Image(systemName: "music.note.list").font(.system(size: 35.0)).foregroundColor(.accentColor)
            VStack(alignment: .leading){
                Text(score.movementTitle ?? "No title").bold()
                Text(score.composer ?? "")
                Spacer()
            }
        }
        Spacer()
    }
}
