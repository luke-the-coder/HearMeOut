////
////  RecordingView.swift
////  HearMeOut
////
////  Created by Marta Michelle Caliendo on 07/03/23.
////
//
import SwiftUI

struct RecordingView: View {
    
    @StateObject private var audioPlayer = AudioPlayer()
    let fileName: String
  
        var body: some View {
            NavigationStack {
                ZStack(alignment: .bottom) {
                    VStack {
              
                        List {
                            ForEach(audioPlayer.recordingsList, id: \.createdAt) { recording in
                                HStack {
                                    Text("\(recording.fileURL.lastPathComponent)")
                                    Button {
                                        
                                        if recording.isPlaying {
                                            audioPlayer.stopPlaying(url: recording.fileURL) }
                                        else {
                                            audioPlayer.startPlaying(url: recording.fileURL)
                                        }
                                    } label: {
                                        Image(systemName: recording.isPlaying ? "stop.fill" : "play.fill")
                                    }

                              
                                }
                             
                            }
                        }.refreshable {
                            audioPlayer.fetchAllRecording(folderName: fileName)
                        }
                        
                    }
                    Rectangle()
                        .ignoresSafeArea()
                        .frame(height: 130)
                    
                    RecordingButtonView(audioPlayer: audioPlayer, fileName: fileName)
                    
                   
                } .navigationTitle("Recording List")
                    .onAppear {
                        audioPlayer.fetchAllRecording(folderName: fileName)
                    }
                
         
            }
        }
    }

    


struct RecordingView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingView(fileName: "")
    }
}
