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
    @StateObject private var viewModel = ScoreStore()
    @State private var selectedFile: IdentifiedURL?
    var body: some View {
        NavigationStack {
            List(){
                ForEach(viewModel.filteredScores) { score in
                    if let destination = try? ScoreView(musicSheet: score) {
                        NavigationLink(destination: destination) {
                            ScoreRowView(score: score)
                        }
                    }
                }
                .onDelete(perform: viewModel.deleteItems)
            }
            .navigationTitle("Music Reader").toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        self.openFile.toggle()
                    }
                }
            }.searchable(text: $viewModel.searchText, prompt: "Songs, Composer...")
                .fileImporter(isPresented: $openFile, allowedContentTypes: [UTType(filenameExtension: "musicxml")!]) { (res) in
                    
                    do{
                        let fileUrl = try res.get()
                        print(fileUrl)
                        
                        guard fileUrl.startAccessingSecurityScopedResource() else { return }
                        self.selectedFile = IdentifiedURL(url: fileUrl)
                        do {
                            let musicScore = try MusicXMLDecoder.decode(type: ScoreModel.self, from: fileUrl)
                            if (musicScore.movementTitle != nil){
                                viewModel.checkSavedScores(fileURL: fileUrl, Title: (musicScore.movementTitle) ?? "null", Author:  (musicScore.identification?.creator) ?? "null")
                            } else {
                                viewModel.checkSavedScores(fileURL: fileUrl, Title: (musicScore.work?.workTitle) ?? "null", Author:  (musicScore.identification?.creator) ?? "null")
                            }


                        } catch {
                            print(error.localizedDescription)
                            debugPrint(error)
                        }
                        fileUrl.stopAccessingSecurityScopedResource()
                    } catch{
                        print ("error reading")
                        print (error.localizedDescription)
                    }
                }
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
                Image(systemName: "music.note.list").font(.system(size: 35.0))
                VStack(alignment: .leading){
                    Text(score.movementTitle ?? "null").bold()
                    Text(score.composer ?? "null")
                }
            }
            
            Spacer()
        
    }
}
