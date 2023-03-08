//
//  NextStepIntent.swift
//  HearMeOut
//
//  Created by Nicola Rigoni on 08/03/23.
//

import Foundation
import AppIntents

@available(iOS 16, *)
struct NextStep: AppIntent {
    
    static var title: LocalizedStringResource = "Next"
    static var description = IntentDescription("Go next in the score")
    
    static var openAppWhenRun: Bool = true
    static var parameterSummary: some ParameterSummary {
        Summary("Next measure in the current score")
    }
    
    @MainActor
    func perform() async throws -> some IntentResult {
        ScoreViewModel.shared.goNext()
        return .result(dialog: "Okay, next measure performed")
    }
}
