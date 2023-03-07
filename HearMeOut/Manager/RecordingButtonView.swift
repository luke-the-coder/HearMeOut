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
        VStack {
         
            
            if audioPlayer.isRecording == false {
                Button(action: {self.audioPlayer.startRecording(folderName: fileName, recordeName: UUID().uuidString)}) {
                    Image(systemName: "circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .padding(.bottom, 40)
                }
            } else {
                Button(action: {self.audioPlayer.stopRecording()}) {
                    Image(systemName: "stop.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .padding(.bottom, 40)
                }
            }
        }

    }
}

struct RecordingButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingButtonView(audioPlayer: AudioPlayer(), fileName: "")
    }
}
