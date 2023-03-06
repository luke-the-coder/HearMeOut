//
//  SettingsDivions.swift
//  MC3
//
//  Created by Nicola Rigoni on 06/03/23.
//

import Foundation

protocol DivisionProtocol {
    associatedtype SomeType: RawRepresentable where SomeType.RawValue: StringProtocol
    
    func rawValue(SomeType: SomeType) -> String
    func isEqual (to: SomeType) -> Bool
}

extension DivisionProtocol where Self : Equatable {
    func isEqual (to: SomeType) -> Bool {
        return (to as? Self).flatMap({ $0 == self }) ?? false
    }
}

enum DivisionPlay: String, CaseIterable, Equatable, DivisionProtocol {
    
    typealias SomeType = DivisionPlay
    
    case bar = "Bar"
//    case line = "Line"
    case all = "All"
    
    func rawValue(SomeType: DivisionPlay) -> String {
        switch SomeType {
        case .bar:
            return SomeType.rawValue
        case .all:
            return SomeType.rawValue
        }
    }
}

enum DivisionRead: String, CaseIterable, Equatable, DivisionProtocol {
    typealias SomeType = DivisionRead
    
    case bar = "Bar"
//    case line = "Line"
    case note = "Single note"
    
    func rawValue(SomeType: DivisionRead) -> String {
        switch SomeType {
        case .bar:
            return SomeType.rawValue
        case .note:
            return SomeType.rawValue
        }
    }

}
