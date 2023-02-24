//
//  LibraryView.swift
//  MC3
//
//  Created by luke-the-coder on 13/02/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
    @State private var openFile = false
    @StateObject private var viewModel = ScoreStore()    
    var body: some View {
        NavigationStack {
            List(){
                ForEach(viewModel.filteredScores) { score in
                    HStack(spacing: 16){
                        Image(systemName: "music.note.list").font(.system(size: 35.0))
                        VStack(alignment: .leading){
                            Text(score.name ?? "null").bold()
                            Text("Composer")
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
                    viewModel.checkSavedScores(fileURL: fileUrl)
                    guard fileUrl.startAccessingSecurityScopedResource() else { return }
                    do {
                        let string = try String(contentsOf: fileUrl)
                        let data = string.data(using: .utf8)!
                        //                      musicScore = try decoder.decode(ScoreModel.self, from: data)
                        //                      print("version: \(String(describing: musicScore?.version))")
                        //                      print("note: \(String(describing: musicScore?.part?.measure?.note))")
                        //                      print("clef: \(String(describing: musicScore?.part?.measure?.attributes?.clef?.sign))")
                    } catch {
                        print(error.localizedDescription)
                    }
                    //                fileUrl.stopAccessingSecurityScopedResource()
                } catch{
                    print ("error reading")
                    print (error.localizedDescription)
                }
            }
        }
    }

}


struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
