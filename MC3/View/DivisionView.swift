//
//  DivisionView.swift
//  MC3
//
//  Created by Nicola Rigoni on 06/03/23.
//

import SwiftUI

struct DivisionView<current: DivisionProtocol, div: DivisionProtocol>: View {
    @Binding var currentSelection: current
    let division: div
    var body: some View {
        HStack {
            Text(LocalizedStringKey(division.rawValue(SomeType: division as! div.SomeType)))
            Spacer()
            Image(systemName: "checkmark")
                .opacity(division.isEqual(to: currentSelection as! div.SomeType) ? 1.0 : 0.0)
                .accessibilityHidden(true)
                .foregroundColor(.blue)
                
        }
        .contentShape(Rectangle())
        .onTapGesture {
            currentSelection = division as! current
        }
    }
    
}
