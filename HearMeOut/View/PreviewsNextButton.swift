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
                .foregroundColor(.indigo)
                .frame(width: 380, height: 130)
            
            HStack(spacing: 30) {
                Button {
                    vm.goPrevious()
                } label: {
                    Capsule()
                        .foregroundColor(.white)
                        .shadow(radius: 10)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Previous").foregroundColor(.indigo).font(.headline)
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
                            Image(systemName: "play.fill")
                                .scaleEffect(vm.isPlaying ? 0 : 1)
                                .font(.system(size: 50))
                                .foregroundColor(.indigo)
                            
                            Image(systemName: "pause.fill")
                                .scaleEffect(vm.isPlaying ? 1 : 0)
                                .font(.system(size: 50))
                                .foregroundColor(.indigo)
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
                                .foregroundColor(.indigo).font(.headline)
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
