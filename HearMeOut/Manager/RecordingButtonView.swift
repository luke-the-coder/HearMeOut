//
//  RecordingButtonView.swift
//  HearMeOut
//
//  Created by Marta Michelle Caliendo on 07/03/23.
//

import SwiftUI

struct RecordingButtonView: View {
  
@ObservedObject var audioPlayer: AudioPlayer
    
let fileName: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color(uiColor: .systemGray5)
                .ignoresSafeArea()
            
//            VStack {
            HStack(alignment: .center, spacing: 40) {
                    if audioPlayer.isRecording == false {
                        Button {
                            audioPlayer.startRecording(folderName: fileName, recordeName: UUID().uuidString)
                        } label: {
                            Image(systemName: "mic.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .accessibilityLabel("Start recording")
                        }
                    } else {
                        Button {
                            audioPlayer.stopRecording(folderName: fileName)
                        } label: {
                            Image(systemName: "stop.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .accessibilityLabel("Stop recording")
                        }
                    }
                    
                    Text(audioPlayer.timer)
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .accessibilityLabel("Recording time \(audioPlayer.timer)")
                    
                }
                .padding(.bottom, 40)
                
//            }
            
        }
        
        
    }
}

struct RecordingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingButtonView(audioPlayer: AudioPlayer(), fileName: "")
    }
}
