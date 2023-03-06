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
    @State var url: URL?
    @StateObject private var viewModel = ScoreStore()
    @State private var selectedFile: IdentifiedURL?
    var body: some View {
        NavigationStack {
            if let url = url {
                ScoreView(url: url)
            } else {
                List(){
                    ForEach(viewModel.filteredScores) { score in
                        if let destination = ScoreView(url: score.path!) {
                            NavigationLink(destination: destination) {
                                ScoreRowView(score: score)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.deleteItems)
                }.navigationTitle("Scores").toolbar{
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Add") {
                            self.openFile.toggle()
                        }
                    }
                }
            }
        }
        
        .searchable(text: $viewModel.searchText, prompt: "Songs, Composer...")
        .fileImporter(isPresented: $openFile, allowedContentTypes: [UTType(filenameExtension: "musicxml")!]) { (res) in
            do {
                let fileUrl = try res.get()
                MusicScoreLoader().loadMusicScore(url: fileUrl, viewModel: viewModel)
            } catch {
                print ("error reading")
                print (error.localizedDescription)
            }
        }
        .onOpenURL{ url in
            MusicScoreLoader().loadMusicScore(url: url, viewModel: viewModel)
            self.url = url
        }
    }
}


struct MusicScoreLoader {
    
    func loadMusicScore(url: URL, viewModel: ScoreStore) {
        do {
            guard url.startAccessingSecurityScopedResource() else { return }
            do {
                let musicScore = try MusicXMLDecoder.decode(type: ScoreModel.self, from: url)
                if (musicScore.movementTitle != nil) {
                    viewModel.checkSavedScores(fileURL: url, Title: (musicScore.movementTitle) ?? "null", Author:  (musicScore.identification?.creator) ?? "null")
                } else {
                    viewModel.checkSavedScores(fileURL: url, Title: (musicScore.work?.workTitle) ?? "null", Author:  (musicScore.identification?.creator) ?? "null")
                }
            } catch {
                print(error.localizedDescription)
            }
            url.stopAccessingSecurityScopedResource()
        }
    }
}

//struct LibraryView_Previews: PreviewProvider {
//    static var previews: some View {
//        LibraryView()
//    }
//}

struct IdentifiedURL: Identifiable {
    var id = UUID()
    var url: URL
}



private struct ScoreRowView: View {
    let score: Score
    var body: some View {
        HStack(spacing: 16){
                Image(systemName: "music.note.list").font(.system(size: 35.0)).foregroundColor(.accentColor)
                VStack(alignment: .leading){
                    Text(score.movementTitle ?? "No title").bold()
                    Text(score.composer ?? "")
//                    Text("---- DEBUG LINE ----")
//
//                    Text("\(score)")
//
//                    Text("---- DEBUG LINE ----")
                    Spacer()

                }
            }
            Spacer()

    }
}
