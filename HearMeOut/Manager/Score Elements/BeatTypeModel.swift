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
            return "oneQuarter"
        case .twoQuarter:
            return "twoQuarter"
        case .threeQuarter:
            return "threeQuarter"
        case .fourQaurter:
            return "fourQaurter"
        case .threeEight:
            return "threeEight"
        case .sixtEight:
            return "sixtEight"
        case .nineEight:
            return "nineEight"
        case .twelveEight:
            return "twelveEight"
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
