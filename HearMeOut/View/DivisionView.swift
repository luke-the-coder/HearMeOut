//
//  DivisionView.swift
//  MC3
//
//  Created by Nicola Rigoni on 06/03/23.
//

import SwiftUI

struct DivisionView<T>: View where T: RawRepresentable, T.RawValue == String {
    @Binding var currentSelection: T
    let division: T
    var body: some View {
        HStack {
            Text(LocalizedStringKey(division.rawValue))
            Spacer()
            Image(systemName: "checkmark")
                .opacity(division == currentSelection ? 1.0 : 0.0)
                .accessibilityHidden(true)
                .foregroundColor(.blue)
                
        }
        .contentShape(Rectangle())
        .onTapGesture {
            currentSelection = division
        }
    }
    
}
