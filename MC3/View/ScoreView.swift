//
//  ScoreView.swift
//  ReaderMusic
//
//  Created by Marta Michelle Caliendo on 23/02/23.
//

import SwiftUI

struct ScoreView: View {
    @State var isNavigated: Bool = false
    @State var isActive: Bool = false
    var body: some View {
        VStack{
            contentLayer
                .padding(.bottom, 40)
            HStack(spacing: 180) {
                Button {
                    isActive.toggle()
                } label: {
                    Text("Voice")
                        .foregroundColor(.black)
                        .background(
                        Capsule()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: 110, height: 50))
                  
                }
                Button {
                    isActive.toggle()
                } label: {
                    Text("Sound")
                        .foregroundColor(.black)
                        .background(
                        Capsule()
                        .stroke(Color.gray, lineWidth: 2)
                        .frame(width: 110, height: 50))
                  
                }
            }
            Spacer()
            ZStack {
                Capsule()
                    .foregroundColor(Color("Backgroundcolor2"))
                    .frame(width: 400, height: 130)
                    .padding()
                HStack(spacing: 30) {
                    Button {
                        
                    } label: {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .overlay {
                                Text("Previews")
                                    .foregroundColor(.black)
                            }
                    }
                    Button {
                        
                    } label: {
                        Circle()
                            .frame(width: 80)
                            .foregroundColor(.white)
                            .overlay {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 50))
                                    .foregroundColor(.black)
                               
                            }
                    }

                    Button {
                        
                    } label: {
                        Capsule()
                            .foregroundColor(.white)
                            .frame(width: 100, height: 50)
                            .overlay {
                                Text("Next")
                                    .foregroundColor(.black)
                            }
                    }

              
                }
     
            }
    
        
    Spacer()
        }

        .navigationTitle("Piano Sonta N.17")
        .toolbar {
            Button {
                isNavigated.toggle()
            } label: {
                Text("Settings")
            }

        }.sheet(isPresented: $isNavigated) {
           SettingsView()
        }
    }
    
    var contentLayer: some View {
        VStack {
            MyContent(title: "Staff 1", image: "Key", notes:  "G4 C6 A9 B2 G3 R8 M5")
            MyContent(title: "Staff 2", image: "Key", notes: "G4 C6 A9 B2 G3 R8 M5")
        }
    }
    
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ScoreView()
        }
    }
}

struct MyContent: View {
    let title: String
    let image: String
    let notes: String
    var body: some View {
        VStack{
            Text(title)
                .font(.title2)
                .padding(.trailing, 300)
            HStack {
                Image(image)
                    .accessibilityRemoveTraits(.isImage)
                    .padding(.trailing, 5)
                Text(notes)
                    .font(.title)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color("Backgroundcolor"))
                    .frame(width: 380, height: 100))
                    .padding(.bottom, 20)
        }
    }
}
