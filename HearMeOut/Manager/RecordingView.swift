////
////  RecordingView.swift
////  HearMeOut
////
////  Created by Marta Michelle Caliendo on 07/03/23.
////
//
//import SwiftUI
//
//struct RecordingView: View {
//    
//    @StateObject private var audioRecorder = AudioRecorder()
//  
//        var body: some View {
//            NavigationView {
//                VStack {
//                 
//                    
//                    if audioRecorder.recording == false {
//                        Button(action: {self.audioRecorder.startRecording()}) {
//                            Image(systemName: "circle.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 50, height: 50)
//                                .padding(.bottom, 40)
//                        }
//                    } else {
//                        Button(action: {self.audioRecorder.stopRecording()}) {
//                            Image(systemName: "stop.fill")
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .frame(width: 50, height: 50)
//                                .padding(.bottom, 40)
//                        }
//                    }
//                }
//                .navigationBarTitle("Audio Recorder")
//            }
//        }
//    }
//
//    
//
//
//struct RecordingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingView()
//    }
//}
