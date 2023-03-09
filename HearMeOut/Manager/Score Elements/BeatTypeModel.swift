//
//  BeatTypeModel.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 23/02/23.
//

import Foundation

enum BeatType: String {
    case oneQuarter = "1/4"
    case twoQuarter = "2/4"
    case threeQuarter = "3/4"
    case fourQaurter = "4/4"
    case threeEight = "3/8"
    case sixtEight = "6/8"
    case nineEight = "9/8"
    case twelveEight = "12/8"
    case none
    
    var description: String {
        switch self {
        case .oneQuarter:
            return String(localized: "oneQuarter", table: "Localizable")
        case .twoQuarter:
            return String(localized: "twoQuarter", table: "Localizable")
        case .threeQuarter:
            return String(localized: "threeQuarter", table: "Localizable")
        case .fourQaurter:
            return String(localized: "fourQaurter", table: "Localizable")
        case .threeEight:
            return String(localized: "oneQuarter", table: "Localizable")
        case .sixtEight:
            return String(localized: "sixtEight", table: "Localizable")
        case .nineEight:
            return String(localized: "nineEight", table: "Localizable")
        case .twelveEight:
            return String(localized: "twelveEight", table: "Localizable")
        case .none:
            return ""
            
        }
    }
    
    func getBeatType(_ numerator: Int, _ denominator: Int) -> Self {
        if denominator == 4 {
            switch numerator {
            case 1:
                return .oneQuarter
            case 2:
                return .twoQuarter
            case 3:
                return .threeQuarter
            case 4:
                return .fourQaurter
            default:
                return .fourQaurter
            }
        } else if denominator == 8 {
            switch numerator {
            case 3:
                return .threeEight
            case 6:
                return .sixtEight
            case 9:
                return .nineEight
            case 12:
                return .twelveEight
            default:
                return .threeEight
            }
        } else {
            return .oneQuarter
        }
    }
}
