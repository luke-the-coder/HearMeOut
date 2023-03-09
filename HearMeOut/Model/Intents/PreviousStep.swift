//
//  PreviousStep.swift
//  HearMeOut
//
//  Created by Nicola Rigoni on 08/03/23.
//

import Foundation
import AppIntents

@available(iOS 16, *)
struct PreviousStep: AppIntent {
    
    static var title: LocalizedStringResource = "Previous"
    static var description = IntentDescription("Go previous in the score")
    
    static var openAppWhenRun: Bool = true
    static var parameterSummary: some ParameterSummary {
        Summary("Previous measure in the current score")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ScoreViewModel.shared.goPrevious()
        return .result(dialog: "Okay, previous measure performed")
    }
}
