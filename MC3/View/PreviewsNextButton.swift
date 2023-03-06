//
//  PreviewsNextButton.swift
//  MC3
//
//  Created by Marta Michelle Caliendo on 05/03/23.
//

import SwiftUI

struct PreviewsNextButton: View {
    @ObservedObject var vm: ScoreViewModel
    
    var body: some View {
   
        ZStack {
            Capsule()
                .foregroundColor(Color.gray.opacity(0.6))
                .frame(width: 400, height: 130)
                .padding()
            HStack(spacing: 30) {
                Button {
                    vm.goPrevious()
                } label: {
                    Capsule()
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Previews")
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                }
                Button {
                    vm.createMidi()
                    vm.playStopMidi()
                } label: {
                    Circle()
                        .shadow(radius: 10)
                        .frame(width: 80)
                        .foregroundColor(.white)
                        .overlay {
                            Image(systemName: vm.isPlaying ? "stop.fill" : "play.fill")
                                .font(.system(size: 50))
                                .foregroundColor(Color(UIColor.systemBlue))

                        }
                }

                Button {
                    vm.goNext()
                } label: {
                    Capsule()
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Next")
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                }


            }

        }
    }
}

struct PreviewsNextButton_Previews: PreviewProvider {
    static var previews: some View {
        PreviewsNextButton(vm: ScoreViewModel(url: Bundle.main.url(forResource: "Chant" , withExtension: "musicxml")!))
    }
}
