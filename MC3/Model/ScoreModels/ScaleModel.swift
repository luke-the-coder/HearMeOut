//
//  ScaleModel.swift
//  BlindMusic
//
//  Created by Nicola Rigoni on 17/02/23.
//

import Foundation

enum ScaleModel: String {
    case major = "major"
    case minor = "minor"
    
    func checkStep(_ fifth: Int, _ step: Step, scale: ScaleModel) -> Step {
        switch scale {
        case .major:
            switch fifth {
            case 1:
                switch step {
                case .F:
                    return .Fs
                default:
                    return step
                }
            case 2:
                switch step {
                case .C:
                    return .Cs
                case .F:
                    return .Fs
                default:
                    return step
                }
            
            default:
                return step
            }
            //return step
        case .minor:
            return step
        }
    }
    
    

    
}
