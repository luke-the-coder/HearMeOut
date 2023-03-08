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
                .foregroundColor(Color(uiColor: .systemGray5))
                .frame(width: 380, height: 130)
            
            HStack(spacing: 30) {
                Button {
                    vm.goPrevious()
                } label: {
                    Capsule()
                        .stroke(.blue , lineWidth: 2)
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .shadow(radius: 5)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text("Previous").foregroundColor(.blue).font(.headline)
                        }
                }
                Button {
                    vm.createMidi()
                    vm.playStopMidi()
                } label: {
                    Circle()
                        .stroke(.blue, lineWidth: 2)
                        .shadow(radius: 5)
                        .frame(width: 80)
                        .foregroundColor(Color(uiColor: .systemGray3))
                        .overlay {
                            Image(systemName: "play.fill")
                                .scaleEffect(vm.isPlaying ? 0 : 1)
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                            
                            Image(systemName: "stop.fill")
                                .scaleEffect(vm.isPlaying ? 1 : 0)
                                .font(.system(size: 50))
                                .foregroundColor(.blue)
                        }
                }
                
                Button {
                    vm.goNext()
                } label: {
                    Capsule()
                        .stroke(.blue , lineWidth: 2)
                        .foregroundColor(Color(uiColor: .systemGray3))
                       .shadow(radius: 5)
                        .frame(width: 100, height: 50)
                        
                        .overlay {
                            Text("Next")
                                .foregroundColor(.blue).font(.headline)
                        }
                }
                
                
            }
            
        }
    }
}

struct PreviewsNextButton_Previews: PreviewProvider {
    static var previews: some View {
        PreviewsNextButton(vm: ScoreViewModel.shared)
    }
}
