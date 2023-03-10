//
//  Shortcuts.swift
//  HearMeOut
//
//  Created by Nicola Rigoni on 08/03/23.
//

import Foundation
import AppIntents

@available(iOS 16, *)
struct SiriAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: NextStep(),
            phrases: ["Next \(.applicationName)r"] //
        )
        AppShortcut(
            intent: PreviousStep(),
            phrases: ["Previous \(.applicationName)"]
        )
        
    }
}
